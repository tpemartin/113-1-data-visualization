# Load the shiny library
library(shiny)
library(ggplot2)

# Define the UI for the app
ui <- fluidPage(
  
  # Application title
  titlePanel("Point Size Adjuster"),
  
  # Sidebar layout with input and output definitions
  sidebarLayout(
    sidebarPanel(
      # Slider input for point size
      sliderInput("point_size",
                  "Point Size:",
                  min = 1,
                  max = 10,
                  value = 3)  # Default point size
    ),
    
    # Show the plot in the main panel
    mainPanel(
      plotOutput("scatterPlot")
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  # Generate the scatter plot based on the point size input
  output$scatterPlot <- renderPlot({
    # Create the ggplot with the specified point size from user input
    ggplot(mtcars, aes(x = wt, y = mpg)) +
      geom_point(size = input$point_size) +  # Adjust the point size
      labs(title = "Scatter Plot of MPG vs Weight",
           x = "Weight (1000 lbs)",
           y = "Miles per Gallon (MPG)")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
