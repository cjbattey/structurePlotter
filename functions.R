parseStructureOutput <- function(infile){
  require(magrittr);require(colourpicker)
  tmp <- readLines(infile,warn=FALSE)
  a <- grep("Inferred ancestry of individuals:",tmp)+2
  c <- grep("Estimated Allele Frequencies in each cluster",tmp)-3
  df <- read.table(file=infile,skip=a-1,nrow=(c-a+1))
  df <- df[2:ncol(df)]
  splitCol <- lapply(df[1,],function(e) grep(":",e)) %>% 
    unlist() %>% names() %>% strsplit("") %>% 
      unlist() %>% .[2] %>% as.numeric()-1 # :(
  k <- ncol(df)-splitCol
  ancestry <- df[(splitCol+1):(splitCol+k)]
  rownames(ancestry) <- as.character(unlist(df[1]))
  colnames(ancestry) <- 1:k
  if(splitCol==4){
    ancestry$pop <- factor(unlist(df[3]))
  } else {
    ancestry$pop <- apply(ancestry,1,function(e) names(e[e==max(e)]))
  }
  return(ancestry)
}

colorMatchR <- function(ancestry,colors=c("gold","forestgreen","magenta3","orangered","cornflowerblue",
                                          "orange","sienna","dodgerblue4")){
    k <- ncol(ancestry)-1
    palette <- c(rep("NA",k))
    for(i in unique(as.numeric(ancestry$pop))){
      d <- subset(ancestry,pop==i)
      e <- colMeans(d[1:k])
      f <- names(e[e==max(e)]) %>% as.numeric()
      if (palette[f] == "NA"){
        palette[f] <- colors[i]
      }
    }
    palette[which(palette == "NA")] <- colors[which(colors%in%palette == FALSE)]
    colors <- palette
    return(colors)
}









