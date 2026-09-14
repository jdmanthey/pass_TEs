options(scipen=999)
library(Biostrings)

# read in sequences
seqs <- readDNAStringSet("_others_seqs_step3.fasta")

# remove some formatting on seqs names
names(seqs)[grepl("Recon", names(seqs))] <- sapply(strsplit(names(seqs)[grepl("Recon", names(seqs))], "Recon"), "[[", 1)
names(seqs) <- gsub("\\(", "", names(seqs))

# pdf list
pdf_list <- list.files("_satellite")
pdf_list <- substr(pdf_list, 1, nchar(pdf_list) - 4)
pdf_list <- gsub("__", "/", pdf_list)

# loop for each pdf
for(a in 1:length(pdf_list)) {
	a_rep <- pdf_list[a]
	a_replace <- paste0(sapply(strsplit(a_rep, "#"), "[[", 1), "#Satellite")
	if(a_rep %in% names(seqs)) {
		names(seqs)[names(seqs) == a_rep] <- a_replace
	} else {
		a_rep2 <- sapply(strsplit(a_rep, "#"), "[[", 1)
		a_rep2 <- substr(a_rep2, 1, nchar(a_rep2) - 3)
		if(length(a_rep2) == 1) {
			names(seqs)[grepl(a_rep2, names(seqs))]
		} else {
			print(a)
		}
	}
}
writeXStringSet(seqs, "_others_seqs_step4.fasta")


