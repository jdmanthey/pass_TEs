# pull out PDFs of long seqs for manual inspection of highly repetitive internal structure 
# indicative of satellite DNA

options(scipen=999)
library(Biostrings)

# read in sequences
seqs <- readDNAStringSet("_others_seqs_step3.fasta")

# keep only long seqs
seqs <- seqs[nchar(seqs) >= 5000]

# pdf list
pdf_list <- list.files("_other")

# loop to copy pdf for each
for(a in 1:length(names(seqs))) {
	a_rep <- paste0(names(seqs)[a], ".pdf")
	a_rep <- gsub("/", "__", a_rep)
	if(a_rep %in% pdf_list) {
		a_file_original <- paste0("_other/", a_rep)
		a_file_new <- paste0("_other_long/", a_rep)
		invisible(file.copy(a_file_original, a_file_new))
	} else {
		a_rep <- paste0(sapply(strsplit(a_rep, "#"), "[[", 1), "#")
		a_rep2 <- pdf_list[grepl(a_rep, pdf_list)]
		if(length(a_rep2) == 1) {
			a_file_original <- paste0("_other/", a_rep2)
			a_file_new <- paste0("_other_long/", a_rep2)
			invisible(file.copy(a_file_original, a_file_new))
		} else if(length(a_rep2) == 0) {
			a_rep <- paste0(substr(a_rep, 1, nchar(a_rep) - 1), "_")
			a_rep2 <- pdf_list[grepl(a_rep, pdf_list)]
			if(length(a_rep2) == 1) {
				a_file_original <- paste0("_other/", a_rep2)
				a_file_new <- paste0("_other_long/", a_rep2)
				invisible(file.copy(a_file_original, a_file_new))
			} else {
				print(a)
			}
		} else {
			print(a)
		}
	}
	
}



