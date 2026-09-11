library(Biostrings)

cr1_seqs <- readDNAStringSet("_CR1_seqs_step3.fasta")
erv_seqs <- readDNAStringSet("_ERV_seqs_step3.fasta")

individual_list <- read.table("raw_reference_list.txt")

# different types of ERVs
erv_types <- sapply(strsplit(unique(sapply(strsplit(names(erv_seqs), "#"), "[[", 2)), "/"), "[[", 2)

# loop for each individual to rename
original_names <- c()
new_names <- c()
new_seqs <- c()
for(a in 1:nrow(individual_list)) {
	cr1_rep <- cr1_seqs[sapply(strsplit(names(cr1_seqs), "--"), "[[", 1) == individual_list[a,3]]
	if(length(cr1_rep) > 0) {
			original_names <- c(original_names, names(cr1_rep))
		for(b in 1:length(cr1_rep)) {
			names(cr1_rep)[b] <- paste0("CR1-", b, "_", individual_list[a,4], "#", sapply(strsplit(names(cr1_rep)[b], "#"), "[[", 2))
			
		}
		new_names <- c(new_names, names(cr1_rep))
		if(a == 1) {
			new_seqs <- cr1_rep
		} else {
			new_seqs <- c(new_seqs, cr1_rep)
		}
	}
	erv_rep <- erv_seqs[sapply(strsplit(names(erv_seqs), "--"), "[[", 1) == individual_list[a,3]]
	if(length(erv_rep) > 0) {
		for(b in 1:length(erv_types)) {
			erv_rep2 <- erv_rep[sapply(strsplit(sapply(strsplit(names(erv_rep), "#"), "[[", 2), "/"), "[[", 2) == erv_types[b]]
			if(length(erv_rep2) > 0) {
				original_names <- c(original_names, names(erv_rep2))
				for(d in 1:length(erv_rep2)) {
					names(erv_rep2)[d] <- paste0(erv_types[b], "-", d, "_", individual_list[a,4], "#", sapply(strsplit(names(erv_rep2)[d], "#"), "[[", 2))
				}
				new_names <- c(new_names, names(erv_rep2))
			
				new_seqs <- c(new_seqs, erv_rep2)
			}
		}
	}
}

# write table of new and old names
output <- data.frame(original_names=as.character(original_names), new_names=as.character(new_names))
write.table(output, file="_CR1_ERV_seq_names.txt", row.names=F, col.names=T, quote=F, sep="\t")
writeXStringSet(new_seqs, "_CR1_ERV_seq.fasta")


