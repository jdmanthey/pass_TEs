library(Biostrings)

x_files <- list.files("eg1_output", full.names=T)
x_species <- sapply(strsplit(sapply(strsplit(x_files, "/"), "[[", 2), "-families"), "[[", 1)

helper <- read.table("raw_reference_list.txt")

outdir <- "eg1_out_combined"
outdir_unknown <- "eg1_out_unknown"
outdir_others <- "eg1_out_known"

sequences <- list()
for(a in 1:length(x_files)) {
	# read in sequences
	sequences[[a]] <- readDNAStringSet(x_files[a])
	
	# determine short acronym for this species
	a_name <- helper[helper[,3] == x_species[a], 4]
	
	# names x number of consensus sequences and rename
	names(sequences[[a]]) <- paste0(a_name, "-", seq(from=1, to=length(names(sequences[[a]]))), "#", sapply(strsplit(names(sequences[[a]]), "#"), "[[", 2))	
	
	# remove white spaces in names
	names(sequences[[a]]) <- gsub(" ", "", names(sequences[[a]]), fixed=T)
	
	# add family to those that are missing
	names(sequences[[a]])[grep("/", names(sequences[[a]]), invert=T)] <- paste0(names(sequences[[a]])[grep("/", names(sequences[[a]]), invert=T)], "/", sapply(strsplit(names(sequences[[a]])[grep("/", names(sequences[[a]]), invert=T)], "#"), "[[", 2))
}

# combine all the sequences
for(a in 1:length(x_files)) {
	if(a == 1) {	
		combined <- sequences[[a]]
	} else {
		combined <- c(combined, sequences[[a]])
	}
}

# find all the superfamilies
superfams <- sapply(strsplit(names(combined), "#"), "[[", 2)
superfams_unique <- unique(superfams)
superfams_names <- gsub("/", "_", superfams_unique)

# write a fasta for each superfamily
for(a in 1:length(superfams_unique)) {
	a_rep <- combined[superfams == superfams_unique[a],]
	a_name <- paste0(outdir, "/", superfams_names[a], ".fasta")
	writeXStringSet(a_rep, a_name)
}




