library(shiny)


shinyUI(
  fluidPage(
    titlePanel("Linear Regression"),
    p("Documentation"),
    p("For Coursera evaluation - Perform linear regression on your csv/txst file and predict based on new entries"),
    p("The first tab shows the model and its parameters"),
    p("The second tab shows your predict data plus the prediction it makes based on the training data you have uploaded"),
    sidebarLayout(
      sidebarPanel(width=3,
                   fileInput('training_data', 'Training Data', multiple=FALSE,
                             accept=c('text/csv', 
                                      'text/comma-separated-values,text/plain', 
                                      '.csv')),
                   fileInput('predict_data', 'predict Data', multiple=FALSE,
                             accept=c('text/csv', 
                                      'text/comma-separated-values,text/plain', 
                                      '.csv')),
                   
                   selectInput('y_variable', 'choose y-variable', choices = "To Be Updated!", multiple = FALSE),
                   
                   selectizeInput('x_variable', 'select cols to be factor variables', choices = "To Be Updated!", multiple = TRUE),
                   downloadButton('Prediction','Download predicted Data')
                   
                   
                   
      ),
      mainPanel(
        tabsetPanel(
          tabPanel("Regression Analysis",verbatimTextOutput("raw_output")),
          tabPanel("predict output",htmlOutput("predict_table"))
        )
      )
    ) 
  )
)