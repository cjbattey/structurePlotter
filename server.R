shinyServer(function(input,output,session){
  require(magrittr);require(colourpicker);require(viridis);require(RColorBrewer);require(data.table);require(plyr)
  source("functions.R")

  #reading in data
  data <- reactive({
    inFile <- input$file1
    mat <- input$matrix
    
    if (is.null(inFile) & is.null(mat)){
      parseStructureOutput("./testRun1.strOut_f")
    } else if(is.null(inFile)==F & is.null(mat)==T){
      parseStructureOutput(inFile$datapath)
    } else if(is.null(inFile)==T & is.null(mat)==F){
      mat <- fread(mat$datapath) %>% data.frame()
      mat$pop <- apply(mat,1,function(e) names(e[e==max(e)]))
      return(mat)
    }
  })
  
  #sorting samples
  data2 <- reactive({
    tmp <- data()
    tmp$maxQ <- apply(tmp[1:ncol(tmp)-1],1,function(e) max(e))
    if(input$sortByPop==T & input$sortByQ==F){
      tmp <- tmp[order(tmp$pop), , drop=F]
    } else if(input$sortByPop==F & input$sortByQ==T){
      tmp <- tmp[order(tmp$maxQ), , drop=F]
    } else if(input$sortByPop==T & input$sortByQ==T){
      dt <- tmp[0,]
      for(i in sort(unique(as.numeric(tmp$pop)))){
        a <- subset(tmp,pop==i)
        a <- a[order(a$maxQ),,drop=F]
        dt <- rbind(dt,a)
      }
      tmp <- dt
    }
    return(tmp[1:(ncol(tmp)-1)])
  })
  
  #color matching
  colors <- reactive({
    pal <- input$palettes
    if(is.null(pal)){
      colorMatchR(ancestry=data2(),colors=c(input$pop1.col,input$pop2.col,input$pop3.col,
                                                           input$pop4.col,input$pop5.col,input$pop6.col,
                                                           input$pop7.col,input$pop8.col))
    } else if(pal %in% c("Accent","Dark2","Paired","Pastel1","Pastel2","Set1","Set2","Set3")){
      colorMatchR(ancestry=data2(),colors=brewer.pal(n=ncol(data2()-1),name=pal))
    } else if(pal=="Viridis"){
      colorMatchR(ancestry=data2(),colors=sample(viridis(ncol(data2()-1))))
    } else if(pal=="Custom"){
      colorMatchR(ancestry=data2(),colors=c(input$pop1.col,input$pop2.col,input$pop3.col,
                                           input$pop4.col,input$pop5.col,input$pop6.col,
                                           input$pop7.col,input$pop8.col))
    }
  })

  #output$table <- renderTable({data()})
  
  border.col <- reactive({
      if(input$border==T){
        return("white")
      } else {
        return(NA)
      }
    })
  
  output$plot <- renderPlot({
    barplot(t(data2()[1:(ncol(data2())-1)]),axes=FALSE,col=colors(),border=border.col(),
            names=rownames(data2()),cex.names=input$cex.names,las=2,cex.main=0.75,
            font.main=1,space=0,xpd=FALSE,inside=T)
  })
  
  output$download <- downloadHandler(
    filename="plot.pdf",
    content=function(file){
              pdf(file,width=8,height=4)
              a <- barplot(t(data2()[1:(ncol(data2())-1)]),axes=FALSE,col=colors(),border=border.col(),
                          names=rownames(data2()),cex.names=input$cex.names,las=2,cex.main=0.75,
                          font.main=1,space=0,xpd=FALSE,inside=T)
              print(a)
              dev.off()
              },
    contentType = "pdf"
  )
  
})



