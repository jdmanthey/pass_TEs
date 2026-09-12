library(Biostrings)

# remove threshold
rm_thresh <- 0.8
# length threshold for removal
rm_length <- 0.8


others_seqs <- readDNAStringSet("_others_seqs.fasta")
others_censor <- read.table("_others_seqs.fasta.map", comment.char="")

# censor header
c_head <- c("qseqid", "qstart", "qend", "repeat_name", "rstart", "rend", "dir", "similarity", "mmts_Ratio", "score", "query_align_percent", "rep_cov_percent")
colnames(others_censor) <- c_head

# loop for each TE
TEs_to_keep <- c()
TEs_to_remove <- c()
for(a in 1:length(others_seqs)) {
	a_length <- nchar(others_seqs[a])
	a_matches <- others_censor[others_censor$qseqid == names(others_seqs)[a],]

	# keep only seqs above remove threshold
	a_matches <- a_matches[a_matches$similarity >= rm_thresh,]
	# keep if above thresholds
	if(sum(a_matches$query_align_percent) >= rm_length) {
		if(nrow(a_matches) == 0) {
			TEs_to_keep <- c(TEs_to_keep, names(others_seqs)[a])
		} else {
			TEs_to_remove <- c(TEs_to_remove, names(others_seqs)[a])
		}
	}	else {
		TEs_to_keep <- c(TEs_to_keep, names(others_seqs)[a])
	}
} 
others_seqs2 <- others_seqs[names(others_seqs) %in% TEs_to_keep]
writeXStringSet(others_seqs2, "_others_seqs_step2.fasta")

table(sapply(strsplit(names(others_seqs2), "#"), "[[", 2))









