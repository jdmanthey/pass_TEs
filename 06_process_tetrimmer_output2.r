options(scipen=999)
library(Biostrings)

# read in list of references
helper <- read.table("raw_reference_list.txt")

# directories completed by TEtrimmer
helper <- helper[helper[,3] %in% list.files(),]

# sequences to keep from tetrimmer and earlgrey
tetrimmer <- read.table("1_tetrimmer_keep_list.txt", header=F, comment.char="")
earlgrey <- read.table("1_earlgrey_keep_list.txt", header=F, comment.char="")

# min and max lengths for high quality CR1 and ERV
CR1_min <- 2000
CR1_max <- 5000
ERV_min <- 4000
ERV_max <- 15000

# output sequence file 
outseq <- "_processed_seqs1.fasta"

# loop for each species
for(a in 1:nrow(helper)) {
	print(a)
	a_species <- helper[a,3]
	# pull out names and see if there are overlaps between the two
	a_tet <- tetrimmer[sapply(strsplit(tetrimmer[,1], "/"), "[[", 1) == a_species,]
	a_eg <- earlgrey[sapply(strsplit(earlgrey[,1], "/"), "[[", 1) == a_species,]
	a_tet_file_name <- sapply(strsplit(a_tet, "/"), "[[", 4)
	a_eg_file_name <- sapply(strsplit(a_eg, "/"), "[[", 4)
	a_tet_base_name <- sapply(strsplit(a_tet_file_name, "#"), "[[", 1)
	a_tet_base_name <- paste0(sapply(strsplit(a_tet_base_name, "_"), "[[", 1), "_", 
							  sapply(strsplit(a_tet_base_name, "_"), "[[", 2), "_",
							  sapply(strsplit(a_tet_base_name, "_"), "[[", 3), "_", 
							  sapply(strsplit(a_tet_base_name, "_"), "[[", 4))
	a_eg_base_name <- sapply(strsplit(a_eg_file_name, "#"), "[[", 1)
	a_eg_base_name <- paste0(sapply(strsplit(a_eg_base_name, "_"), "[[", 1), "_", 
							  sapply(strsplit(a_eg_base_name, "_"), "[[", 2), "_",
							  sapply(strsplit(a_eg_base_name, "_"), "[[", 3), "_", 
							  sapply(strsplit(a_eg_base_name, "_"), "[[", 4))
	# remove any eg that are in tet
	a_eg <- a_eg[a_eg_base_name %in% a_tet_base_name == FALSE]
	a_eg_file_name <- a_eg_file_name[a_eg_base_name %in% a_tet_base_name == FALSE]
	a_eg_base_name <- a_eg_base_name[a_eg_base_name %in% a_tet_base_name == FALSE]
	
	# read in sequence files
	tet_seq <- readDNAStringSet(paste0(a_species, "/TEtrimmer_consensus.fasta"))
	eg_seq <- readDNAStringSet(paste0("02_strainer_files/", a_species, "-families.fa.strained"))

	# rename sequence bases to match the seq names and the pdf files
	a_eg_seq_base <- paste0(sapply(strsplit(a_eg_base_name, "_"), "[[", 1), "-", 
							  sapply(strsplit(a_eg_base_name, "_"), "[[", 2), "_",
							  sapply(strsplit(a_eg_base_name, "_"), "[[", 3), "-", 
							  sapply(strsplit(a_eg_base_name, "_"), "[[", 4))
	a_tet_seq_name <- gsub("__", "/", a_tet_file_name)
	a_tet_seq_name <-substr(a_tet_seq_name, 1, nchar(a_tet_seq_name)-4)
	
	# loop for each sequence
	for(b in 1:length(a_tet_seq_name)) {
		b_pdf <- a_tet[b]
		b_filename <- paste0(a_species, "--", a_tet_file_name[b])
		b_seq <- tet_seq[a_tet_seq_name[b] == names(tet_seq)]
		names(b_seq) <- paste0(a_species, "--", names(b_seq))
		
		# write sequence output
		if(a == 1 & b == 1) {
			writeXStringSet(b_seq, outseq)
		} else {
			writeXStringSet(b_seq, outseq, append=T)
		}
		
		# determine if potential ERV or CR1 with appropriate length
		# then write pdf to one of three output folders
		if(grepl("LTR__ERV", b_filename)) {
			if(nchar(b_seq) >= ERV_min & nchar(b_seq) <= ERV_max) {
				invisible(file.copy(b_pdf, paste0("_ERV/", b_filename)))
			} else {
				invisible(file.copy(b_pdf, paste0("_other/", b_filename)))
			}
		} else if(grepl("LINE__CR1", b_filename)) {
			if(nchar(b_seq) >= CR1_min & nchar(b_seq) <= CR1_max) {
				invisible(file.copy(b_pdf, paste0("_CR1/", b_filename)))
			} else {
				invisible(file.copy(b_pdf, paste0("_other/", b_filename)))
			}
		} else {
			invisible(file.copy(b_pdf, paste0("_other/", b_filename)))
		}	
	}
	
	b_seq_names_base <- sapply(strsplit(names(eg_seq), "#"),"[[", 1)
	for(b in 1:length(a_eg_seq_base)) {
		b_pdf <- a_eg[b]
		b_filename <- paste0(a_species, "--", a_eg_file_name[b])
		b_seq <- eg_seq[a_eg_seq_base[b] == b_seq_names_base]
		names(b_seq) <- paste0(a_species, "--", names(b_seq))
		
		# write sequence output
		writeXStringSet(b_seq, outseq, append=T)
		
		
		# determine if potential ERV or CR1 with appropriate length
		# then write pdf to one of three output folders
		if(grepl("LTR__ERV", b_filename)) {
			if(nchar(b_seq) >= ERV_min & nchar(b_seq) <= ERV_max) {
				invisible(file.copy(b_pdf, paste0("_ERV/", b_filename)))
			} else {
				invisible(file.copy(b_pdf, paste0("_other/", b_filename)))
			}
		} else if(grepl("LINE__CR1", b_filename)) {
			if(nchar(b_seq) >= CR1_min & nchar(b_seq) <= CR1_max) {
				invisible(file.copy(b_pdf, paste0("_CR1/", b_filename)))
			} else {
				invisible(file.copy(b_pdf, paste0("_other/", b_filename)))
			}
		} else {
			invisible(file.copy(b_pdf, paste0("_other/", b_filename)))
		}	
	}
	
}










