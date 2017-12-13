#  simulate simple RT experiment with 10 items repeated 10 times 

for (i in 1:18) {
	asubject = data.frame(item = rep(1:10,10), rt = 640 + runif(1)*20 + runif(100)*80)
	asubject = asubject[order(sample(1:100)),]
	write.table(asubject, sep='\t', row.names=F, file=sprintf('S%03d.txt',i))
}
