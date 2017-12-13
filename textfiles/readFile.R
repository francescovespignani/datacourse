readSj <- function(i) {
  noun = sprintf('S%03d',i)
  tmp = read.table(paste('astudy/',noun,'.txt', sep=''), header=T, as.is =T)
  tmp$subject = noun
  tmp$trial = 1:dim(tmp)[1]
  return(tmp)
}



