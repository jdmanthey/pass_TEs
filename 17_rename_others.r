library(Biostrings)

seqs <- readDNAStringSet("_others_seqs_step4.fasta")
# modify seq names that have some extra info
names(seqs)[grepl("RepeatScout", names(seqs))]<- sapply(strsplit(names(seqs)[grepl("RepeatScout", names(seqs))], "RepeatScout"), "[[", 1)

# add "inc" (incomplete) to CR1 and ERV elements since they are not full length
names(seqs) <- gsub("LINE/CR1", "LINE/CR1-inc", names(seqs))
names(seqs) <- gsub("LTR/ERV1", "LTR/ERV1-inc", names(seqs))
names(seqs) <- gsub("LTR/ERVK", "LTR/ERVK-inc", names(seqs))
names(seqs) <- gsub("LTR/ERVL", "LTR/ERVL-inc", names(seqs))
names(seqs) <- gsub("LTR/ERV$", "LTR/ERV-inc", names(seqs))


individual_list <- read.table("raw_reference_list.txt")

# loop for each individual to rename
original_names <- c()
new_names <- c()
new_seqs <- c()
for(a in 1:nrow(individual_list)) {
	a_rep <- seqs[sapply(strsplit(names(seqs), "--"), "[[", 1) == individual_list[a,3]]
	if(length(a_rep) > 0) {
			original_names <- c(original_names, names(a_rep))
		for(b in 1:length(a_rep)) {
			b_base <- strsplit(names(a_rep)[b], "#")[[1]][2]
			if(grepl("/", b_base)) {
				b_base <- strsplit(b_base, "/")[[1]][2]
			}
			names(a_rep)[b] <- paste0(b_base, "-", b, "_", individual_list[a,4], "#", sapply(strsplit(names(a_rep)[b], "#"), "[[", 2))
		}
		new_names <- c(new_names, names(a_rep))
		if(a == 1) {
			new_seqs <- a_rep
		} else {
			new_seqs <- c(new_seqs, a_rep)
		}
	}
}

# remove the inc from the ends of names (just needed it embedded)
original_names <- gsub("-inc$", "", original_names)
new_names <- gsub("-inc$", "", new_names)
names(new_seqs) <- gsub("-inc$", "", names(new_seqs))

# write table of new and old names
output <- data.frame(original_names=as.character(original_names), new_names=as.character(new_names))
write.table(output, file="_others_seq_names.txt", row.names=F, col.names=T, quote=F, sep="\t")
writeXStringSet(new_seqs, "_others_seqs_step5.fasta")


