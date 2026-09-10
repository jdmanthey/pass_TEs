options(scipen=999)
library(Biostrings)

# get list of good cr1, erv, and others from the folders
# containing the manually checked pdf files
cr1_list <- list.files("_CR1")
erv_list <- list.files("_ERV")
others_list <- list.files("_other")
cr1_list <- substr(cr1_list, 1, nchar(cr1_list) - 4)
erv_list <- substr(erv_list, 1, nchar(erv_list) - 4)
others_list <- substr(others_list, 1, nchar(others_list) - 4)

# modify names in lists
cr1_list <- gsub("__", "/", cr1_list)
erv_list <- gsub("__", "/", erv_list)
others_list <- gsub("__", "/", others_list)

# just base names of lists
cr1_list2 <- sapply(strsplit(cr1_list, "#"), "[[", 1)
erv_list2 <- sapply(strsplit(erv_list, "#"), "[[", 1)
others_list2 <- sapply(strsplit(others_list, "#"), "[[", 1)

# read in sequences
seqs <- readDNAStringSet("_processed_seqs1.fasta")

# modify names in seqs
names(seqs) <- gsub("family-", "family_", names(seqs))
names(seqs) <- gsub(" ", "", names(seqs))
names(seqs) <- gsub("rnd-", "rnd_", names(seqs))

# base names of seqs
seq_names <- sapply(strsplit(names(seqs), "#"), "[[", 1)

# modify some seq names some more
cr1_list3 <- cr1_list2[cr1_list2 %in% seq_names == FALSE]
erv_list3 <- erv_list2[erv_list2 %in% seq_names == FALSE]
others_list3 <- others_list2[others_list2 %in% seq_names == FALSE]
cr1_list2[cr1_list2 %in% cr1_list3] <- substr(cr1_list3, 1, nchar(cr1_list3) - 3)
erv_list2[erv_list2 %in% erv_list3] <- substr(erv_list3, 1, nchar(erv_list3) - 3)
others_list2[others_list2 %in% others_list3] <- substr(others_list3, 1, nchar(others_list3) - 3)



# CR1 output
seq_subset <- seqs[seq_names %in% cr1_list2]
# rename output names as needed
renaming <- names(seq_subset)[names(seq_subset) %in% cr1_list == FALSE]
renaming2 <- sapply(strsplit(renaming, "#"), "[[", 1)
for(a in 1:length(renaming)) {
	a_rep <- cr1_list[grepl(renaming2[a], cr1_list)]
	if(length(a_rep) == 1) {
		names(seq_subset)[names(seq_subset) %in% renaming[a]] <- a_rep
	} else {
		print(a)
	}
}
# check it worked
table(names(seq_subset) %in% cr1_list)
# write output
writeXStringSet(seq_subset, "_CR1_seqs.fasta")



# ERV output
seq_subset <- seqs[seq_names %in% erv_list2]
# rename output names as needed
renaming <- names(seq_subset)[names(seq_subset) %in% erv_list == FALSE]
renaming2 <- sapply(strsplit(renaming, "#"), "[[", 1)
for(a in 1:length(renaming)) {
	a_rep <- erv_list[grepl(renaming2[a], erv_list)]
	if(length(a_rep) == 1) {
		names(seq_subset)[names(seq_subset) %in% renaming[a]] <- a_rep
	} else {
		# take the original seq name if more than one
		a_rep <- a_rep[order(nchar(a_rep))]
		a_rep <- a_rep[1]
		names(seq_subset)[names(seq_subset) %in% renaming[a]] <- a_rep
	}
}
# check it worked
table(names(seq_subset) %in% erv_list)
# write output
writeXStringSet(seq_subset, "_ERV_seqs.fasta")


# others output
seq_subset <- seqs[seq_names %in% others_list2]
writeXStringSet(seq_subset, "_others_seqs.fasta")

