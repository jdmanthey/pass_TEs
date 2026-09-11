library(Biostrings)

# remove threshold
rm_thresh <- 0.9
# classify threshold
class_thresh <- 0.8
# length threshold for removal
rm_length <- 0.9
# length threshold for classify
class_length <- 0.9

cr1_seqs <- readDNAStringSet("_CR1_seqs.fasta")
cr1_censor <- read.table("_CR1_seqs.fasta.map", comment.char="")
erv_seqs <- readDNAStringSet("_ERV_seqs.fasta")
erv_censor <- read.table("_ERV_seqs.fasta.map", comment.char="")

# censor header
c_head <- c("qseqid", "qstart", "qend", "repeat_name", "rstart", "rend", "dir", "similarity", "mmts_Ratio", "score", "query_align_percent", "rep_cov_percent")
colnames(cr1_censor) <- c_head
colnames(erv_censor) <- c_head

# loop for each TE
TEs_to_keep <- c()
TEs_to_remove <- c()
TE_class <- c()
for(a in 1:length(cr1_seqs)) {
	a_length <- nchar(cr1_seqs[a])
	a_matches <- cr1_censor[cr1_censor$qseqid == names(cr1_seqs)[a],]
	# keep only seqs above classify threshold
	a_matches <- a_matches[a_matches$similarity >= class_thresh,]
	# classify if above thresholds
	if(sum(a_matches$query_align_percent) >= class_length) {
		# more than one match or no?
		if(length(a_matches$repeat_name) == 1) {
			a_class <- a_matches$repeat_name
		} else {
			a_class <- paste0(a_matches$repeat_name, collapse="__")
		}
	} else {
		a_class <- "no_match"
	}
	# keep only seqs above remove threshold
	a_matches <- a_matches[a_matches$similarity >= rm_thresh,]
	# keep if above thresholds
	if(sum(a_matches$query_align_percent) >= rm_length) {
		if(nrow(a_matches) == 0) {
			TEs_to_keep <- c(TEs_to_keep, names(cr1_seqs)[a])
			TE_class <- c(TE_class, a_class)
		} else {
			TEs_to_remove <- c(TEs_to_remove, names(cr1_seqs)[a])
		}
	}	else {
		TEs_to_keep <- c(TEs_to_keep, names(cr1_seqs)[a])
		TE_class <- c(TE_class, a_class)
	}
} 
cr1_seqs2 <- cr1_seqs[names(cr1_seqs) %in% TEs_to_keep]
writeXStringSet(cr1_seqs2, "_CR1_seqs_step2.fasta")


for(a in 1:length(erv_seqs)) {
	a_length <- nchar(erv_seqs[a])
	a_matches <- erv_censor[erv_censor$qseqid == names(erv_seqs)[a],]
	# keep only seqs above classify threshold
	a_matches <- a_matches[a_matches$similarity >= class_thresh,]
	# classify if above thresholds
	if(sum(a_matches$query_align_percent) >= class_length) {
		# more than one match or no?
		if(length(a_matches$repeat_name) == 1) {
			a_class <- a_matches$repeat_name
		} else {
			a_class <- paste0(a_matches$repeat_name, collapse="__")
		}
	} else {
		a_class <- "no_match"
	}
	# keep only seqs above remove threshold
	a_matches <- a_matches[a_matches$similarity >= rm_thresh,]
	# keep if above thresholds
	if(sum(a_matches$query_align_percent) >= rm_length) {
		if(nrow(a_matches) == 0) {
			TEs_to_keep <- c(TEs_to_keep, names(erv_seqs)[a])
			TE_class <- c(TE_class, a_class)
		} else {
			TEs_to_remove <- c(TEs_to_remove, names(erv_seqs)[a])
		}
	}	else {
		TEs_to_keep <- c(TEs_to_keep, names(erv_seqs)[a])
		TE_class <- c(TE_class, a_class)
	}
} 
erv_seqs2 <- erv_seqs[names(erv_seqs) %in% TEs_to_keep]
writeXStringSet(erv_seqs2, "_ERV_seqs_step2.fasta")

