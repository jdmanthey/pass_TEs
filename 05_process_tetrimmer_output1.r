library(pdftools)
library(stringr)

# read in list of references
helper <- read.table("raw_reference_list.txt")

# directories completed by TEtrimmer
helper <- helper[helper[,3] %in% list.files(),]

# minimum number of full length copies to keep the repeat
min_num <- 3

tetrimmer_keep_list <- c()
earlgrey_keep_list <- c()
throw_away_list <- c()
# loop for each species
for(a in 1:nrow(helper)) {
	print(a)
	a_species <- helper[a,3]
	a_list <- c( 
	list.files(paste0(a_species, "/TEtrimmer_for_proof_curation/Annotations_perfect"), full.names=T),
	list.files(paste0(a_species, "/TEtrimmer_for_proof_curation/Annotations_good"), full.names=T),
	list.files(paste0(a_species, "/TEtrimmer_for_proof_curation/Annotations_check_recommended"), full.names=T),
	list.files(paste0(a_species, "/TEtrimmer_for_proof_curation/Annotations_check_required"), full.names=T))
	
	# loop for each output pdf
	for(b in 1:length(a_list)) {
		b_rep <- pdf_text(a_list[b])
		# select page TEtrimmer output coverage plot
		page_number <- grep("After TEtrimmer", b_rep)
		if(length(page_number) > 0) {
			b_temp <- b_rep[page_number[1]]
			# pull out info about full coverage
			b_temp <- strsplit(b_temp, "\n")[[1]][3]
			b_temp <- strsplit(b_temp, "full length: ")[[1]][2]
			b_temp <- as.numeric(strsplit(b_temp, " ")[[1]][1])
			if(is.na(b_temp) == FALSE) {
				# if enough full coverage copies, add to list
				if(b_temp >= min_num) {
					tetrimmer_keep_list <- c(tetrimmer_keep_list, a_list[b])
				} else { # otherwise check earl grey initial repeats
					# select page for earl grey output coverage plot
					page_number <- grep("Before TEtrimmer", b_rep)
					b_temp <- b_rep[page_number[1]]
					# pull out info about full coverage
					b_temp <- strsplit(b_temp, "\n")[[1]][3]
					b_temp <- strsplit(b_temp, "full length: ")[[1]][2]
					b_temp <- as.numeric(strsplit(b_temp, " ")[[1]][1])
					if(is.na(b_temp) == FALSE) {
						if(b_temp >= min_num) {
							earlgrey_keep_list <- c(earlgrey_keep_list, a_list[b])
						} else {
							throw_away_list <- c(throw_away_list, a_list[b])
						}
					} else {
						throw_away_list <- c(throw_away_list, a_list[b])
					}
				}
			} else {
				throw_away_list <- c(throw_away_list, a_list[b])
			}
		}
	}
}

# write names of outputs
write(tetrimmer_keep_list, file="1_tetrimmer_keep_list.txt", ncolumns=1)
write(earlgrey_keep_list, file="1_earlgrey_keep_list.txt", ncolumns=1)
write(throw_away_list, file="1_throw_away_list.txt", ncolumns=1)









