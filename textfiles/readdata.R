# when you debug/try/program execute frequently 
# the following command

rm(list=ls())

#
#  try to access data file with low level functions
#

Lines = readLines('astudy/S001.txt')
head(Lines)
str(Lines)

cLines = gsub('\"','',Lines)

splitLines = strsplit(cLines,'\t')
head(splitLines)
str(splitLines)

t(as.data.frame(splitLines))

# etc. etc. 


#
# Using high level function
#

sjdata = read.table('astudy/S001.txt')
head(sjdata)

#  ok we have extra info at the beginning

good = sjdata[2:101,]
plot(good$V2~good$V1)

#  what the hell is this?

str(good)

# I  do not want factors but numbers:

good$V2 = as.numeric(good$V2)
head(good)

# gosh,  I lost my data!

good$V2 = as.numeric(as.character(good$V2))
head(good)

# gosh,  I really lost my data!

good = sjdata[2:101,]
good$V2 = as.numeric(as.character(good$V2))
head(good)

plot(good$V2~good$V1)

#  that sounds good but let's go back and see if we can do a better work

?read.table

# the optional arguments header and as.is sound interesting:

good2 = read.table('astudy/S001.txt', header=T, as.is =T)
head(good2)
str(good2)


plot(good2$rt~good2$item)

#  many things go better,  but item is a factor ...  the final solution:
good2 = read.table('astudy/S001.txt', header=T, as.is =T)
good2$item = factor(good2$item)
plot(good2$rt~good2$item)


# it works, let's go on, Copy Paste & Replace
sj1 = read.table('astudy/S001.txt', header=T, as.is =T)
sj2 = read.table('astudy/S002.txt', header=T, as.is =T)
sj3 = read.table('astudy/S003.txt', header=T, as.is =T)
sj4 = read.table('astudy/S004.txt', header=T, as.is =T)
sj5 = read.table('astudy/S005.txt', header=T, as.is =T)


all = rbind(sj1, sj2,sj3,sj4,sj5)

#
#  do I miss something?
#


# I've lost subject and trial order 
# information,  let's go back

sj1 = read.table('astudy/S001.txt', header=T, as.is =T)
sj1$subject = 'S001'
sj1$trial = 1:dim(sj1)[1]


# generalize to loop/repeat across subjects

sjs = 1:18
sj = sjs[1]

paste('astudy/S','00',as.character(sj),'.txt')
?paste
paste('astudy/S','00',as.character(sj),'.txt', sep ='')

sj = 18
paste('astudy/S','00',as.character(sj),'.txt', sep ='')

# different if sj>9,  if sj>9 add 2 zeros etc...
# try sprintf!

?sprintf
sprintf('S%03d',1)
sprintf('S%03d',18)

sj = 18
noun = sprintf('S%03d',sj)
tmp = read.table(paste('astudy/',noun,'.txt', sep=''), header=T, as.is =T)
tmp$subject = noun
tmp$trial = 1:dim(sj1)[1]


#  the loop solution
rm(list=ls())
sjs =1:18
out = data.frame()
for (sj in sjs){
  noun = sprintf('S%03d',sj)
  tmp = read.table(paste('astudy/',noun,'.txt', sep=''), header=T, as.is =T)
  tmp$subject = noun
  tmp$trial = 1:dim(tmp)[1]
  out = rbind(out, tmp)
}


##  whops: error


out = data.frame()
for (sj in sjs){
  noun = sprintf('S%03d',sj)
  tmp = read.table(paste('astudy/',noun,'.txt', sep=''), header=T, as.is =T)
  tmp$subject = noun
  tmp$trial = 1:dim(tmp)[1]
  out = rbind(out, tmp)
}

table(out$subject)
str(out)

# item is init and subject is chr!

out$item = factor(out$item)
out$subject = factor(out$subject)

plot(out$subject,out$rt)
plot(out$item,out$rt)

# fine! but ...  we can make it a function

readSj <- function(i) {
  noun = sprintf('S%03d',i)
  tmp = read.table(paste('astudy/',noun,'.txt', sep=''), header=T, as.is =T)
  tmp$subject = noun
  tmp$trial = 1:dim(tmp)[1]
  return(tmp)
}
sjs = 1:18
out = data.frame()
for (sj in sjs){
  asubj = readSj(sj)
  out = rbind(out, asubj)
}
out$item = factor(out$item)
out$subject = factor(out$subject)

#
#  we can also make some checks
#

rm(list=ls())
sj = 7
noun = sprintf('S%03d',sj)
tmp = read.table(paste('astudy/',noun,'.txt', sep=''), header=T, as.is =T)
tmp$subject = noun
tmp$trial = 1:dim(tmp)[1]


dim(tmp)
table(tmp$item)


#  can I make the user to know that something wrong is happening here?

dim(tmp)[1]==100
table(tmp$item) == 10

#  I can assign these boolean values to variables

numOk = (dim(tmp)[1]==100)

if (!(numOk)) {
  warning (sprintf('Subject %d has a wrong number of items',sj))
}

if (!(numOk)) {
  warning (sprintf('Subject %d has %d items instead of 100',sj,dim(tmp)[1]))
}

itemsOk = all(table(tmp$item)==10)

if (!(itemsOk)) {
  warning (sprintf('Subject %d has not 10 trial for each item',sj,dim(tmp)[1]))
}

if (!(itemsOk & numOk)) {
  warning (sprintf('Something wrong with subject %d, please check',sj,dim(tmp)[1]))
}



#
#  the final product
#
rm(list=ls())

readSj <- function(i) {
  noun = sprintf('S%03d',sj)
  tmp = read.table(paste('astudy/',noun,'.txt', sep=''), header=T, as.is =T)
  tmp$subject = noun
  tmp$trial = 1:dim(tmp)[1]
  numOk = dim(tmp)[1]==100
  itemsOk = all(table(tmp$item)==10)
  if (!(itemsOk & numOk)) {
    warning (sprintf('Something wrong with subject %d, please check',sj,dim(tmp)[1]))
  }
  return(tmp)
}

sjs = 1:18
out = data.frame()
for (sj in sjs){
  asubj = readSj(sj)
  out = rbind(out, asubj)
}
out$item = factor(out$item)
out$subject = factor(out$subject)

#
# save your work with meaningful variable name
#

rtData = out
save(rtData, file='rtData.Rdata')

write.table(rtData, file='rtData.txt', row.names=F, quote=F)
write.csv(rtData, file='rtData.csv', row.names=F, quote=F)

out = c()
for (i in 1:18) { 
  a = sprintf('S%03d',i)
  #print(a)
  out = c(out,a)
}
