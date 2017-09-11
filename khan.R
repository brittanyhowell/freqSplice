args = commandArgs(TRUE)

# load required libraries
library(IRanges)
library(ggplot2)
require(magrittr); require(tidyr) # to unite cols
library(reshape) # for melt
library(scales) # to access break formatting functions
library(plyr) # to make frequency plots
library("RColorBrewer") # For 16 colours in the Rpalette


# setwd("~/Documents/University/Honours_2016/Project/freqSplice/gapTables/human1045")
setwd(args[1])



# Plot all reads
  # reads <- read.table(file = "gapsIn0h_Ctrl_R2_intervals.txt")
  reads <- read.table(file = args[2])
  colnames(reads) <- c("chr", "LStart", "LEnd", "mapStart", "mapEnd")
  
  start <- reads$mapStart
  end <- reads$mapEnd
  
  # intervals stored as an IRanges object
    intervals <- IRanges(start = start, end = end)
    cov <- coverage(intervals)
  
    # ggplot - stacked bar plot
      bins <- disjointBins(IRanges(start(intervals), end(intervals) + 1))
      dat <- cbind(as.data.frame(intervals), bin = bins)
      
      ggplot(dat) + 
        geom_rect(aes(xmin = start, xmax = end,
                      ymin = bin, ymax = bin + 0.9 )) 
    
    # line coverage plot
      plot(cov, type = "l", main = args[1], xlab = "L1 coordinate", ylab = "Coverage")
      par(mar = c(5,5,2,3))
    
# Read Summary Section - How many reads align to each L1 and how many are spliced.
    readSummaryRaw <- read.table(file = "gapsIn24h_5FU_R1_readSummary.txt")
    colnames(readSummaryRaw) <- c("Chr", "lStart", "lEnd", "numReads", "splReads", "nonSplReads", "propSplice")
    readSummary <- readSummaryRaw[order(-readSummaryRaw$numReads, -readSummaryRaw$splReads),] # have to order it, so that levels=unique works
    
    # paste coordinates into the one column:
    readSummary %<>%
    unite( L1, Chr, lStart, lEnd, remove = TRUE) # makes Chr, Lstart and Lend into one 'L1' col
 
    # makes separate rows based on numReads and splReads - allows for grouped columns
    df <- melt(readSummary[,c('L1','numReads','splReads')],id.vars = 1) 
    df$L1 <- factor(df$L1, levels=unique(as.character(df$L1))) # plots IN ORDER - so, it has to be sorted.
    
    ggplot(df,aes(x = L1 ,y = value+1)) + # value is + 1 because otherwise (due to log scale) 0 is negative.
      geom_bar(aes(fill = variable),stat = "identity",position = "dodge") +
      xlab("L1 chr and interval") +
      ylab("Reads aligned on L1") +
      scale_y_continuous(trans = "log10", breaks = trans_breaks("log10", function(x) 10^x)) +
      theme(axis.text.x=element_text(angle=50,hjust=1), plot.margin=unit(c(1,1,1.5,1.2),"cm")) + # top, right, bottom, left  
      scale_fill_hue(name="Read type") +
      theme(legend.position=c(.9, .8))  
    
    
  
# Split read section 
      splitReads <- read.table("gapsIn24h_5FU_R1_splitReads.txt")
      colnames(splitReads) <- c("ID", "chr", "cStart", "cEnd", "lStart", "lEnd", "class5", "class3","Nclass5", "Nclass3", "gapLen", "cigar", "flags")   
    
      # Making frequency table
      
      freqSplits <- splitReads[,c(5:11)]
      dfAll <- as.data.frame(freqSplits)
      
      df <- dfAll[dfAll$gapLen > 0,]
 
      df <- dfAll[dfAll$class5 >1 &  dfAll$class5 < 33,]
      
      counts <- ddply(df, .(df$lStart, df$lEnd, df$gapLen, df$class5, df$class3, df$Nclass5, df$Nclass3), nrow)
      names(counts) <- c("start", "end", "len","fSJ", "tSJ","nfSJ", "ntSJ","freq")
      number_ticks <- function(n) {function(limits) pretty(limits, n)} # allows control of number of ticks
      
      plotTitle <- "human MCF7"
      
      base_breaks <- function(n = 10){
        function(x) {
          axisTicks(log10(range(x, na.rm = TRUE)), log = TRUE, n = n)
        }
      }
        
      # pdf("hum2.pdf", width = 14, height = 8)
      ggplot(counts) +
        geom_segment(aes(x = counts$start, y = counts$freq, xend = counts$end, yend = counts$freq,  color = factor(counts$ntSJ)), size = 2, alpha=.5, data = counts) +
      scale_y_continuous(trans = "log10", minor_breaks = seq(100, 10000, 100), breaks=base_breaks()) + 
        scale_fill_manual(values = colorRampPalette(brewer.pal(12, "Accent"))(16)) +
        labs(title = plotTitle, x = "L1 coordinate", y = "Reads supporting gap") +
        coord_cartesian(xlim = NULL, ylim = c(5, max(counts$freq))) +
        theme(legend.title=element_blank()) 
      # graphics.off()
      
      write.table(counts, "/Users/brittanyhowell/Documents/University/Honours_2016/Project/freqSplice/counts.txt", sep="\t", row.names = FALSE, quote = FALSE, col.names = FALSE)
      

      