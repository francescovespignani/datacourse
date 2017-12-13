rm(list=ls())
load('rtData.Rdata')
head(rtData)
str(rtData)

#  alternatively
rm(list=ls())
rtData = read.table('rtData.txt')
head(rtData)
str(rtData)

#  oh yes
rtData = read.table('rtData.txt', header=T)
head(rtData)
str(rtData)
rtData$item = factor(rtData$item)

#  note if you want that read.table automatically recognizes 
# items as factor you could have saved differently

rm(list=ls())
load('rtData.Rdata')
head(rtData)
str(rtData)

paste('w', rtData$item, sep='')
rtData$item = factor(paste('w', rtData$item, sep=''))
write.table(rtData, file = 'rtData.txt', row.names=F, quote=F)

# how is it the txt file read now?

rtData = read.table('rtData.txt', header=T)
head(rtData)
str(rtData)

# now R automatically encodes item as a factor
# if we want to be comunicatively cooperative with
# a possible non expert user of our data it is 
# better to give non-numeric values to levels of a
# non numerical variable


#
#  in case we like to pursue this we can either
#      A) go back on the reading stage and do that
#      or
#      B) do it at the end of the process when we 
#         define the final storage format of our data

#
#  in the astudy folder we have other info and data
#  that we may want to use/share in the future
#  how shall we integrate them?
#

# let's read

tinfo = read.table('astudy/items.txt')
tinfo
tinfo = read.table('astudy/items.txt', header=T)
str(tinfo)

#  how to merge the information in the large file?

?merge

rm(list=ls())
rtData = read.table('rtData.txt', header=T)
tinfo = read.table('astudy/items.txt', header=T)
all = merge(rtData,tinfo)
all
all = merge(rtData,tinfo,all.x =T)


# gosh, items are w1 or 1?

tinfo = read.table('astudy/items.txt', header=T)
tinfo$item = paste('w', tinfo$item, sep='')
all = merge(rtData,tinfo)
head(all)
dim(rtData)[1] == dim(all)[1]


#  suppose we had different column names
colnames(tinfo)
colnames(tinfo)[1] ='gliitem'
all = merge(rtData,tinfo, all.x=T)
head(all)
dim(rtData)[1]
dim(all)[1]

# no, no, no, no 
# cloumns names are important or ...

all = merge(rtData,tinfo, by.x='item', by.y='gliitem')
dim(rtData)[1]
dim(all)[1]
summary(all)

table(all$type, all$string)

# well "scimmina"  is not a word,  where is the error? 
# in the descrition file? in the experiment? in the encoding?
# if it only an encoding error in the descrition file 
# we can correct it here

rm(list=ls())
rtData = read.table('rtData.txt', header=T)
tinfo = read.table('astudy/items.txt', header=T)
tinfo$item = paste('w', tinfo$item, sep='')
all = merge(rtData,tinfo)

idx = which(levels(all$string)=='scimmina')
levels(all$string)[idx] = 'scimmia'

# subjectinfo file

sinfo = read.table('astudy/subjectInfo.csv', header=T)
sinfo = read.table('astudy/subjectInfo.csv', header=T, sep=',')
head(sinfo)
sinfo = read.csv('astudy/subjectInfo.csv', header=T, sep=',')
sinfo = read.csv('astudy/subjectInfo.csv', header=T, sep=',', fileEncoding = 'utf8')
sinfo


# subject code neccesarry for correct merge
# is wrongly encoded

sinfo$subject.ID
num = as.numeric(gsub('^[::sog::]*','',sinfo$subject.ID))
sinfo$subject = sprintf('S%03d', num)

# check
table(sinfo$subject, sinfo$subject.ID)

# notes are wrong, also another subject did not 
# end the task and maybe not useful
# select the useful column to merge

head(sinfo)
sinfo2 = subset(sinfo, select=c(-subject.ID, -note))
head(sinfo2)


?subset

#  task1 is not very meaningfule, suppose it is
# mean RT to a simple reaction time

colnames(sinfo2)[2] = 'mean_simpleRT'


#  do the merge

all2 = merge(all, sinfo2)
dim(all)
dim(all2)

all2 = merge(all, sinfo2, all.x=T)

# merge messes the order (we are lucky we have trial)

all2 = all2[order(all2$subject, all2$trial),]
head(all2)
write.csv(all2, file ='rtDataInfo.csv', row.names=F, quote=F)


# sinfo missing for subject 12, ok

#
# exercise 1: put all togheter and save file
#


# exercise 2: add other info linked to the words, 
# such as number of characters and frequency of usage
# from the corpora in http://crr.ugent.be/subtlex-it/


# exercise 3: add a column that encodes how many
# times that item was seen by a subject (items are 
# repeated 10 times)
