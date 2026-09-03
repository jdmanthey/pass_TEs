library(Biostrings)

sequences <- readDNAStringSet("combined_90.fasta")

blast <- read.table("combined_90.fasta.map", comment.char="")

# remove unknowns from BLAST results
blast <- blast[sapply(strsplit(paste0(blast[,4], "#1"), "#"), "[[", 2) != "UNK/UNK",]
blast <- blast[sapply(strsplit(paste0(blast[,4], "#1"), "#"), "[[", 2) != "Uncharacterized",]


no_matches <- c()
matches <- c()
matches_names <- c()
# loop for every putative TE
for(a in 1:length(names(sequences))) {
	if(a %% 1000 == 0) {print(a)}
	a_name <- names(sequences)[a]
	a_length <- width((sequences[names(sequences) == a_name,]))
	a_blast <- blast[blast[,1] == a_name,]
	a_blast_length <- sum(a_blast[,3] - a_blast[,2]) + nrow(a_blast)
	if(a_blast_length == 0) {
		no_matches <- c(no_matches, a_name)
	} else if((a_blast_length / a_length) >= 0.8) { 
		if(nrow(a_blast) == 1 & a_blast[1,8] >= 0.8) { # direct match and rename # if 80/80 and one match
			new_name <- paste0(strsplit(a_blast[1,1], "#")[[1]][1], "#", strsplit(a_blast[1,4], "#")[[1]][2], "/", 
					strsplit(a_blast[1,4], "#")[[1]][1])
			matches <- c(matches, a_name)
			matches_names <- c(matches_names, new_name)
		} else if(nrow(a_blast) > 1) {
			if(length(unique(a_blast[,4])) == 1) { # check if all the matches are the same element
				if(max(a_blast[,8]) >= 0.8) { # identity > 80%
					new_name <- paste0(strsplit(a_blast[1,1], "#")[[1]][1], "#", strsplit(a_blast[1,4], "#")[[1]][2], "/", 
						strsplit(a_blast[1,4], "#")[[1]][1])
					matches <- c(matches, a_name)
					matches_names <- c(matches_names, new_name)
				} else if(max(a_blast[,8]) >= 0.7) { # identity > 70%
					new_name <- paste0(strsplit(a_blast[1,1], "#")[[1]][1], "#", strsplit(a_blast[1,4], "#")[[1]][2], "/Unknown")
					matches <- c(matches, a_name)
					matches_names <- c(matches_names, new_name)
				} else { # low identity
					no_matches <- c(no_matches, a_name)
				}
			} else if(length(unique(sapply(strsplit(paste0(a_blast[,4], "#1"), "#"), "[[", 2))) == 1) { # if matches are same element type
				if(max(a_blast[,8]) >= 0.8) { # identity > 80%
					new_name <- paste0(strsplit(a_blast[1,1], "#")[[1]][1], "#", strsplit(a_blast[1,4], "#")[[1]][2], "/", 
						strsplit(a_blast[1,4], "#")[[1]][1])
					matches <- c(matches, a_name)
					matches_names <- c(matches_names, new_name)
				} else if(max(a_blast[,8]) >= 0.7) { # identity > 70%
					new_name <- paste0(strsplit(a_blast[1,1], "#")[[1]][1], "#", strsplit(a_blast[1,4], "#")[[1]][2], "/Unknown")
					matches <- c(matches, a_name)
					matches_names <- c(matches_names, new_name)
				} else { # low identity
					no_matches <- c(no_matches, a_name)
				}
			} else { # else a repeat array
				# check if any single aspects are greater than 80% of length
				a_check <- a_blast[(a_blast[,3] - a_blast[,2] + 1) / a_length >= 0.8, ]
				if(nrow(a_check) > 0) {
					if(max(a_blast[,8]) >= 0.8) { # identity > 80%
						new_name <- paste0(strsplit(a_check[1,1], "#")[[1]][1], "#", strsplit(a_check[1,4], "#")[[1]][2], "/", 
							strsplit(a_check[1,4], "#")[[1]][1])
						matches <- c(matches, a_name)
						matches_names <- c(matches_names, new_name)
					} else if(max(a_check[,8]) >= 0.7) { # identity > 70%
						new_name <- paste0(strsplit(a_check[1,1], "#")[[1]][1], "#", strsplit(a_check[1,4], "#")[[1]][2], "/Unknown")
						matches <- c(matches, a_name)
						matches_names <- c(matches_names, new_name)
					} else {
						new_name <- paste0(strsplit(a_blast[1,1], "#")[[1]][1], "#", "RepeatArray/RepeatArray")
						matches <- c(matches, a_name)
						matches_names <- c(matches_names, new_name)
					}
				} else {
					new_name <- paste0(strsplit(a_blast[1,1], "#")[[1]][1], "#", "RepeatArray/RepeatArray")
					matches <- c(matches, a_name)
					matches_names <- c(matches_names, new_name)
				}	
			}
		}		
	}  else if((a_blast_length / a_length) >= 0.5) {
		if(nrow(a_blast) == 1 & a_blast[1,8] >= 0.8) { # direct match and rename # if 50/80 and one match
			new_name <- paste0(strsplit(a_blast[1,1], "#")[[1]][1], "#", strsplit(a_blast[1,4], "#")[[1]][2], "/Unknown")
			matches <- c(matches, a_name)
			matches_names <- c(matches_names, new_name)
		} else if(nrow(a_blast) > 1) {
			if(length(unique(a_blast[,4])) == 1) { # check if all the matches are the same element
				if(max(a_blast[,8]) >= 0.7) { # identity > 70%
					new_name <- paste0(strsplit(a_blast[1,1], "#")[[1]][1], "#", strsplit(a_blast[1,4], "#")[[1]][2], "/Unknown")
					matches <- c(matches, a_name)
					matches_names <- c(matches_names, new_name)
				} else { # low identity
					no_matches <- c(no_matches, a_name)
				}
			} else if(length(unique(sapply(strsplit(paste0(a_blast[,4], "#1"), "#"), "[[", 2))) == 1) { # if matches are same element type
				if(max(a_blast[,8]) >= 0.8) { # identity > 80%
					new_name <- paste0(strsplit(a_blast[1,1], "#")[[1]][1], "#", strsplit(a_blast[1,4], "#")[[1]][2], "/Unknown")
					matches <- c(matches, a_name)
					matches_names <- c(matches_names, new_name)
				} else if(max(a_blast[,8]) >= 0.7) { # identity > 70%
					new_name <- paste0(strsplit(a_blast[1,1], "#")[[1]][1], "#", strsplit(a_blast[1,4], "#")[[1]][2], "/Unknown")
					matches <- c(matches, a_name)
					matches_names <- c(matches_names, new_name)
				} else { # low identity
					no_matches <- c(no_matches, a_name)
				}
			} else { # else a repeat array
				new_name <- paste0(strsplit(a_blast[1,1], "#")[[1]][1], "#", "RepeatArray/RepeatArray")
				matches <- c(matches, a_name)
				matches_names <- c(matches_names, new_name)
			}
		}		
	} else { # no good matches
		no_matches <- c(no_matches, a_name)
	}
}


# take out no matches and write output
no_match_seqs <- sequences[names(sequences) %in% no_matches]
writeXStringSet(no_match_seqs, "combined_90_no_matches.fasta")

# rename matched sequences and write output
match_seqs <- sequences[names(sequences) %in% matches]
for(a in 1:length(matches_names)) {
	names(match_seqs)[names(match_seqs) == matches[a]] <- matches_names[a]
}
writeXStringSet(match_seqs, "combined_90_matches.fasta")




