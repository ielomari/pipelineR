library(shiny)
library(DBI)
library(RPostgres)
library(dplyr)
library(bslib)
library(ggplot2)

# Connect to DB
connect_db <- function() {
  DBI::dbConnect(
    RPostgres::Postgres(),
    dbname = Sys.getenv("PG_DB"),
    host = Sys.getenv("PG_HOST"),
    user = Sys.getenv("PG_USER"),
    password = Sys.getenv("PG_PASSWORD")
  )
}

ui <- fluidPage(
  theme = bslib::bs_theme(version = 5, bootswatch = "flatly"),
  titlePanel("📊 Pipeline Logs"),
  sidebarLayout(
    sidebarPanel(
      dateRangeInput("date_range", "📅 Filter by date", start = Sys.Date() - 10, end = Sys.Date()),
      selectInput("status", "Status", choices = c("ALL", "OK", "ERROR"), selected = "ALL"),
      textInput("symbol", "Symbol", "")
    ),
    mainPanel(
      tableOutput("log_table")
    )
  )
)

server <- function(input, output, session) {
  con <- connect_db()
  on.exit(DBI::dbDisconnect(con), add = TRUE)

  logs <- reactive({
    query <- "SELECT * FROM student_ibtissam.pipeline_logs"
    df <- DBI::dbGetQuery(con, query)

    df <- df |>
      filter(timestamp >= input$date_range[1], timestamp <= input$date_range[2])

    if (input$status != "ALL") {
      df <- df |> filter(status == input$status)
    }

    if (input$symbol != "") {
      df <- df |> filter(grepl(input$symbol, symbol, ignore.case = TRUE))
    }

    df
  })

  output$log_table <- renderTable({
    logs()
  })
}

shinyApp(ui, server)
