require(magrittr);require(colourpicker);require(data.table)
shinyUI(fluidPage(
  titlePanel("structurePlotter v0.1"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file1","upload structure output"),
      #fileInput("matrix","upload ancestry matrix"),
      numericInput("cex.names","Sample ID Font Scaling (default=0.75)",value=0.75),
      checkboxInput("border","Border Clusters?",value=T),
      checkboxInput("sortByPop","Sort by population?",value=F),
      checkboxInput("sortByQ","Sort by maximum ancestry?",value=F),
      radioButtons("palettes","Palettes",choices = c("Accent","Dark2","Paired","Pastel1","Pastel2",
                                                     "Set1","Set2","Set3","Viridis","Custom"),
                   inline=T,selected="Custom"),
      colourInput("pop1.col",label="pop 1",value="gold"),
      colourInput("pop2.col",label="pop 2",value="forestgreen"),
      colourInput("pop3.col",label="pop 3",value="magenta3"),
      colourInput("pop4.col",label="pop 4",value="orangered"),
      colourInput("pop5.col",label="pop 5",value="cornflowerblue"),
      colourInput("pop6.col",label="pop 6",value="orange"),
      colourInput("pop7.col",label="pop 7",value="sienna"),
      colourInput("pop8.col",label="pop 8",value="dodgerblue4")
    ),
    mainPanel(style="position:fixed;margin-left:32vw;",
      plotOutput("plot"),
      downloadButton("download","Download Plot")
      #tableOutput("table")
    )
  )))