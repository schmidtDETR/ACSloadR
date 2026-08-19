library(shiny)
library(leaflet)
library(leaflet.extras)
library(tigris)
library(sf)
library(dplyr)
library(jsonlite)
library(geojsonsf)
library(bslib)

# Cache tigris data so it doesn't redownload every time you change states
options(tigris_use_cache = TRUE)

# Define the UI
ui <- page_sidebar(
  title = "Geographic Region Selector",

  # Inject custom CSS to make the code output box larger and scrollable
  tags$head(
    tags$style(HTML("
      #r_code_output {
        height: 350px;
        overflow-y: auto;
      }
    "))
  ),

  sidebar = sidebar(
    selectInput(
      "state",
      "Select State:",
      choices = state.abb,
      selected = "NV"
    ),
    selectInput(
      "geometry",
      "Select Geometry:",
      choices = c(
        "Counties",
        "Tracts",
        "Block Groups",
        "PUMAs",
        "ZCTAs",
        "Core-based Areas",
        "County Subdivisions",
        "Census Places",
        "School Districts",
        "Lower State Legislative Districts",
        "Upper State Legislative Districts",
        "Urban Areas",
        "Voting Districts"
      ),
      selected = "Counties"
    ),
    actionButton("clear", "Clear Selection", class = "btn-warning"),
    hr(),
    h5("Export R Code"),
    p("Copy the code below to use your selected regions in R:"),
    verbatimTextOutput("r_code_output")
  ),

  # Main map area
  card(
    full_screen = TRUE,
    leafletOutput("map", height = "100%")
  )
)

# Define the Server logic
server <- function(input, output, session) {

  # Reactive value to store selected IDs
  selected_geos <- reactiveVal(character(0))

  # Clear selections when state, geometry, or the clear button changes
  observeEvent(c(input$state, input$geometry, input$clear), {
    selected_geos(character(0))
  })

  # Helper function to fetch tigris data with fallbacks
  fetch_geo_robustly <- function(geom_type, state_id) {

    call_tigris <- function(use_cb, target_year = NULL) {
      # Build arguments list
      args <- list(cb = use_cb, progress_bar = FALSE)
      if (!is.null(target_year)) args$year <- target_year

      # ZCTAs often require 2020 explicitly to avoid API errors
      if (geom_type == "ZCTAs" && is.null(target_year)) {
        args$year <- 2020
      }

      # State-level geometries require the state argument
      state_level_geoms <- c(
        "Counties", "Tracts", "Block Groups", "PUMAs",
        "County Subdivisions", "Census Places", "School Districts",
        "Lower State Legislative Districts", "Upper State Legislative Districts",
        "Voting Districts"
      )
      if (geom_type %in% state_level_geoms) {
        args$state <- state_id
      }

      # Specific geometry arguments
      if (geom_type == "Lower State Legislative Districts") args$house <- "lower"
      if (geom_type == "Upper State Legislative Districts") args$house <- "upper"


      # Execute appropriate tigris function
      raw_shape <- switch(
        geom_type,
        "Counties" = do.call(tigris::counties, args),
        "Tracts" = do.call(tigris::tracts, args),
        "Block Groups" = do.call(tigris::block_groups, args),
        "PUMAs" = do.call(tigris::pumas, args),
        "ZCTAs" = do.call(tigris::zctas, args),
        "Core-based Areas" = do.call(tigris::core_based_statistical_areas, args),
        "County Subdivisions" = do.call(tigris::county_subdivisions, args),
        "Census Places" = do.call(tigris::places, args),
        "School Districts" = do.call(tigris::school_districts, args),
        "Lower State Legislative Districts" = do.call(tigris::state_legislative_districts, args),
        "Upper State Legislative Districts" = do.call(tigris::state_legislative_districts, args),
        "Urban Areas" = do.call(tigris::urban_areas, args),
        "Voting Districts" = do.call(tigris::voting_districts, args)
      )

      # Filter National geometries by the selected state (Overlap only, ignore touches)
      national_geoms <- c("ZCTAs", "Core-based Areas", "Urban Areas")
      if (geom_type %in% national_geoms) {
        state_args <- list(cb = use_cb, progress_bar = FALSE)
        if (!is.null(target_year)) state_args$year <- target_year
        state_boundary <- do.call(tigris::states, state_args)

        state_boundary <- state_boundary[state_boundary$STUSPS == state_id, ]
        state_boundary <- sf::st_transform(state_boundary, sf::st_crs(raw_shape))

        # Intersects matches overlaps + borders. Touches matches ONLY borders.
        intersects <- sf::st_intersects(raw_shape, state_boundary, sparse = FALSE)[, 1]
        touches <- sf::st_touches(raw_shape, state_boundary, sparse = FALSE)[, 1]

        # Keep shapes that intersect the state but don't merely touch its border
        raw_shape <- raw_shape[intersects & !touches, ]
      }

      return(raw_shape)
    }

    # Try current year CB, fallback to 2020 CB, fallback to current year Detailed, fallback to 2020 Detailed
    tryCatch({
      call_tigris(use_cb = TRUE)
    }, error = function(e1) {
      tryCatch({
        call_tigris(use_cb = TRUE, target_year = 2020)
      }, error = function(e2) {
        tryCatch({
          call_tigris(use_cb = FALSE)
        }, error = function(e3) {
          call_tigris(use_cb = FALSE, target_year = 2020)
        })
      })
    })
  }

  # Fetch spatial data based on inputs
  map_data <- reactive({
    req(input$state, input$geometry)

    msg <- "Fetching geographic data..."
    national_geoms <- c("ZCTAs", "Core-based Areas", "Urban Areas")
    if (input$geometry %in% national_geoms) {
      msg <- paste("Fetching national", input$geometry, "and filtering to state...")
    }

    showNotification(msg, id = "geo_fetch", duration = NULL, type = "message")

    raw_data <- fetch_geo_robustly(input$geometry, input$state)

    # Robustly identify the ID column (Census files change depending on year/geography)
    possible_ids <- c("GEOID", "GEOID20", "GEOID10", "ZCTA5CE20", "ZCTA5CE10")
    id_col <- intersect(possible_ids, names(raw_data))[1]

    if (is.na(id_col)) {
      id_col <- grep("^GEOID|^ZCTA", names(raw_data), value = TRUE)[1]
    }

    raw_data$MAP_GEOID <- as.character(raw_data[[id_col]])
    processed_data <- sf::st_transform(raw_data, 4326)

    removeNotification(id = "geo_fetch")
    return(processed_data)
  })

  # Initialize the base map
  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addDrawToolbar(
        targetGroup = "draw",
        editOptions = editToolbarOptions(selectedPathOptions = selectedPathOptions()),
        polylineOptions = FALSE,
        markerOptions = FALSE,
        circleMarkerOptions = FALSE,
        circleOptions = FALSE
      )
  })

  # Automatically adjust the map bounds when the state/geometry changes
  observeEvent(map_data(), {
    req(map_data())
    bbox <- sf::st_bbox(map_data())

    leafletProxy("map") %>%
      fitBounds(
        lng1 = as.numeric(bbox["xmin"]),
        lat1 = as.numeric(bbox["ymin"]),
        lng2 = as.numeric(bbox["xmax"]),
        lat2 = as.numeric(bbox["ymax"])
      )
  })

  # Update polygons when data or selection changes
  observe({
    req(map_data())
    data <- map_data()
    selections <- selected_geos()

    data$poly_color <- ifelse(data$MAP_GEOID %in% selections, "#e74c3c", "#3498db")
    data$poly_opacity <- ifelse(data$MAP_GEOID %in% selections, 0.7, 0.2)

    leafletProxy("map", data = data) %>%
      clearShapes() %>%
      addPolygons(
        layerId = ~MAP_GEOID,
        fillColor = ~poly_color,
        fillOpacity = ~poly_opacity,
        color = "black",
        weight = 1,
        label = ~MAP_GEOID,
        highlightOptions = highlightOptions(
          weight = 3,
          color = "#e67e22",
          bringToFront = TRUE
        )
      )
  })

  # Handle individual click events
  observeEvent(input$map_shape_click, {
    click <- input$map_shape_click
    req(click$id)

    current_selection <- selected_geos()

    if (click$id %in% current_selection) {
      selected_geos(setdiff(current_selection, click$id))
    } else {
      selected_geos(c(current_selection, click$id))
    }
  })

  # Handle drawn shapes (rectangles / polygons)
  observeEvent(input$map_draw_new_feature, {
    feature <- input$map_draw_new_feature
    req(feature)

    feature_json <- jsonlite::toJSON(feature, auto_unbox = TRUE, force = TRUE)
    drawn_polygon <- geojsonsf::geojson_sf(feature_json)

    data <- map_data()
    sf::st_crs(drawn_polygon) <- sf::st_crs(data)

    intersects <- sf::st_intersects(data, drawn_polygon, sparse = FALSE)
    intersecting_ids <- data$MAP_GEOID[intersects[, 1]]

    current_selection <- selected_geos()
    new_selection <- unique(c(current_selection, intersecting_ids))
    selected_geos(new_selection)

    # Correctly wipe the drawn geometries using leaflet.extras functions
    leafletProxy("map") %>%
      removeDrawToolbar(clearFeatures = TRUE) %>%
      addDrawToolbar(
        targetGroup = "draw",
        editOptions = editToolbarOptions(selectedPathOptions = selectedPathOptions()),
        polylineOptions = FALSE,
        markerOptions = FALSE,
        circleMarkerOptions = FALSE,
        circleOptions = FALSE
      )
  })

  # Generate R code for copy-pasting
  output$r_code_output <- renderText({
    selections <- selected_geos()
    geom <- input$geometry
    state <- input$state

    # Clean up the geometry name for the R variable (e.g., "Core-based Areas" -> "core_based_areas")
    geom_name <- tolower(gsub(" |-", "_", geom))

    # Construct the appropriate download string for tigris
    tigris_code <- switch(
      geom,
      "Counties" = sprintf('shape <- tigris::counties(state = "%s", cb = TRUE)', state),
      "Tracts" = sprintf('shape <- tigris::tracts(state = "%s", cb = TRUE)', state),
      "Block Groups" = sprintf('shape <- tigris::block_groups(state = "%s", cb = TRUE)', state),
      "PUMAs" = sprintf('shape <- tigris::pumas(state = "%s", cb = TRUE)', state),
      "ZCTAs" = 'shape <- tigris::zctas(cb = TRUE, year = 2020)',
      "Core-based Areas" = 'shape <- tigris::core_based_statistical_areas(cb = TRUE)',
      "County Subdivisions" = sprintf('shape <- tigris::county_subdivisions(state = "%s", cb = TRUE)', state),
      "Census Places" = sprintf('shape <- tigris::places(state = "%s", cb = TRUE)', state),
      "School Districts" = sprintf('shape <- tigris::school_districts(state = "%s", cb = TRUE)', state),
      "Lower State Legislative Districts" = sprintf('shape <- tigris::state_legislative_districts(state = "%s", house = "lower", cb = TRUE)', state),
      "Upper State Legislative Districts" = sprintf('shape <- tigris::state_legislative_districts(state = "%s", house = "upper", cb = TRUE)', state),
      "Urban Areas" = 'shape <- tigris::urban_areas(cb = TRUE)',
      "Voting Districts" = sprintf('shape <- tigris::voting_districts(state = "%s", cb = TRUE)', state)
    )

    # Append spatial filtering code for national-level geometry
    national_geoms <- c("ZCTAs", "Core-based Areas", "Urban Areas")
    if (geom %in% national_geoms) {
      filter_code <- sprintf(
        "state_boundary <- tigris::states(cb = TRUE)\nstate_boundary <- state_boundary[state_boundary$STUSPS == \"%s\", ]\nshape <- sf::st_transform(shape, sf::st_crs(state_boundary))\n\n# Filter to regions that overlap the state (excluding those that only touch the border)\nintersects <- sf::st_intersects(shape, state_boundary, sparse = FALSE)[, 1]\ntouches <- sf::st_touches(shape, state_boundary, sparse = FALSE)[, 1]\nshape <- shape[intersects & !touches, ]",
        state
      )
      tigris_code <- paste(tigris_code, filter_code, sep = "\n")
    }

    # Format the selected IDs
    if (length(selections) == 0) {
      selection_code <- sprintf("selected_%s <- c()", geom_name)
    } else {
      ids_formatted <- paste(sprintf('  "%s"', selections), collapse = ",\n")
      selection_code <- sprintf("selected_%s <- c(\n%s\n)", geom_name, ids_formatted)
    }

    # Combine and return
    paste(
      "# 1. Download the geometry",
      tigris_code,
      "",
      "# 2. Selected regions",
      selection_code,
      sep = "\n"
    )
  })
}

# Run the application
shinyApp(ui = ui, server = server)
