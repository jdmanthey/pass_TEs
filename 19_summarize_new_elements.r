library(Biostrings)

seqs <- readDNAStringSet("_CR1_ERV_seq.fasta")
table(sapply(strsplit(names(seqs), "#"), "[[", 2))

seqs <- readDNAStringSet("_others_seqs_step5.fasta")
table(sapply(strsplit(names(seqs), "#"), "[[", 2))
