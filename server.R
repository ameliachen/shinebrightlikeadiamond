library(shiny)
library(plyr)
library(stringr)

shinyServer(
  function(input, output, session){
    
    training_data<-reactive({
      data<-input$training_data
      if(is.null(data)) return(NULL)
      data<-read.csv(data$datapath)
    })
    
    predict_data<-reactive({
      data<-input$predict_data
      if(is.null(data)) return(NULL)
      data<-read.csv(data$datapath)
    })
    
    observe({
      data<-training_data()
      col_names<-names(data)
      if (is.null(data()))
        return()
      updateSelectInput(session, 'y_variable', choices=col_names)
    })
    
    observe({
      data<-training_data()
      col_names<-names(data)
      if (is.null(data()))
        return()
      updateSelectizeInput(session, 'x_variable', choices=col_names)
    })
    
    y_variable<-reactive({
      y_variable<-input$y_variable
      y_variable
    })
    
    x_variable<-reactive({
      x_variable<-input$x_variable
      x_variable
    })
    
    lm_model<-reactive({
      training_data<-training_data()
      if(is.null(training_data)){
        return(NULL)
      }
      y_variable<-y_variable()
      names(training_data)[which(names(mtcars)==y_variable)]<-"y"
      x_variable<-x_variable()
      if(!is.null(x_variable)){
        for(i in x_variable){
          training_data[,i]<-as.factor(training_data[,i])
        }
      }
      model<-lm(y~.,training_data)
      model
    })
    
    model_AIC<-reactive({
      training_data<-training_data()
      if(is.null(training_data)){
        return(NULL)
      }
      y_variable<-y_variable()
      names(training_data)[which(names(mtcars)==y_variable)]<-"y"
      x_variable<-x_variable()
      if(!is.null(x_variable)){
        for(i in x_variable){
          training_data[,i]<-as.factor(training_data[,i])
        }
      }
      model<-lm(y~.,training_data)
      model<-step(model)
      model
    })
    
    prediction<-reactive({
      predict_data<-predict_data()
      predicted_value<-predict(model_AIC(),predict_data)
      predict_data<-cbind(predict_data,predicted_value)
      predict_data
    })
    
    output$raw_output<-renderPrint({
      print("trained with all the avaliable parameters")
      print(lm_model())
      print("model after using the AIC step algorthim")
      print(model_AIC())
      })
    
    output$predict_table<-renderTable({
      prediction()
    })
    
    output$Prediction<-downloadHandler(
      filename=function() { paste("updated data",'.csv',sep='') },
      content=function(file){
        write.csv(prediction(),file)
      }
    )
    
    
    
    
  }
)
