library(Biostrings)

matches <- readDNAStringSet("combined_90_matches.fasta")
no_matches <- readDNAStringSet("combined_90_no_matches.fasta")

helper <- read.table("raw_reference_list.txt")

#########################################
# subset for matches
#########################################

outdir <- "06_teaid_seqs_knowns"

# find superfamilies
superfamilies <- paste0(sapply(strsplit(sapply(strsplit(names(matches), "#"), "[[", 2), "/"), "[[", 1), "/", sapply(strsplit(sapply(strsplit(names(matches), "#"), "[[", 2), "/"), "[[", 2))
uniq_superfamilies <- unique(superfamilies)
# loop for each superfamily
for(a in 1:length(uniq_superfamilies)) {
	if(length(superfamilies[superfamilies == uniq_superfamilies[a]]) >= 5) {
		a_seq <- matches[superfamilies == uniq_superfamilies[a]]
		a_seq <- a_seq[sample(seq(from=1, to=length(a_seq)), 5)]
		# change the names
		outnames <- names(a_seq)
		outnames <- gsub("#", "__", outnames)
		outnames <- gsub("/", "--", outnames)
		outnames <- paste0(outdir, "/", sapply(strsplit(outnames, "__"), "[[", 2), "__", sapply(strsplit(outnames, "__"), "[[", 1), ".fasta")
		# write fasta files
		for(b in 1:length(a_seq)) {
			writeXStringSet(a_seq[b], outnames[b])
		}
	}
}


#########################################
# all for unmatched
#########################################

outdir <- "06_teaid_seqs_unknowns"

a_seq <- no_matches
# change the names
outnames <- names(a_seq)
outnames <- gsub("#", "__", outnames)
outnames <- gsub("/", "--", outnames)
outnames <- paste0(outdir, "/", outnames, ".fasta")
for(a in 1:length(no_matches)) {
	writeXStringSet(a_seq[a], outnames[a])
}



#########################################
# make a helper file to run TE-Aid on the unknowns
#########################################


x_files <- list.files("06_teaid_seqs_unknowns", full.names=T)
x_sp <- sapply(strsplit(sapply(strsplit(x_files, "/"), "[[", 2), "-"), "[[", 1)
references <- paste0(helper[match(x_sp, helper[,4]),1], "/", helper[match(x_sp, helper[,4]),2])
helper_out <- data.frame(query=as.character(x_files), reference=as.character(references))
write.table(helper_out, file="helper_unknowns.txt", sep="\t", quote=F, row.names=F, col.names=F)

#########################################
# make a helper file to run TE-Aid on the knowns
#########################################

x_files <- list.files("06_teaid_seqs_knowns", full.names=T)
x_sp <- sapply(strsplit(sapply(strsplit(x_files, "__"), "[[", 2), "-"), "[[", 1)
references <- paste0(helper[match(x_sp, helper[,4]),1], "/", helper[match(x_sp, helper[,4]),2])
helper_out <- data.frame(query=as.character(x_files), reference=as.character(references))
write.table(helper_out, file="helper_knowns.txt", sep="\t", quote=F, row.names=F, col.names=F)






