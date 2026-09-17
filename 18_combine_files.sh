# fasta
cat _CR1_ERV_seq.fasta > _all_new_seqs.fasta
cat _others_seqs_step5.fasta >> _all_new_seqs.fasta

# seq names
cat _CR1_ERV_seq_names.txt > _all_new_seqs_names.txt
cat _others_seq_names.txt >> _all_new_seqs_names.txt 


# in R:

library(Biostrings)

seqs <- readDNAStringSet("_all_new_seqs.fasta")

repbase <- readDNAStringSet("vertebrate_repbase_31.08.fasta")

subclasses <- unique(sapply(strsplit(names(repbase), "\t"), "[[", 2))

# update the subclasses file to have the classes and subclasses when known
classes <- read.table("subclasses2.txt", header=F, sep="\t")

# modify the repbase file names
for(a in 1:length(repbase)) {
	a_rep1 <- strsplit(names(repbase)[a], "\t")[[1]][1]
	a_rep2 <- strsplit(names(repbase)[a], "\t")[[1]][2]
	a_rep2 <- classes[match(a_rep2, classes[,1]), 2]
	a_rep <- paste0(a_rep1, "#", a_rep2)
	names(repbase)[a] <- a_rep
	
}

repbase <- c(repbase, seqs)

writeXStringSet(repbase, "vertebrate_repbase_31.08_added2.fasta")
