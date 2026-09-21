options(scipen=999)

x_dirs <- list.files(pattern="", include.dirs=T)
x_dirs <- x_dirs[2:length(x_dirs)]

output_name <- "_assembly_info.txt"
for(a in 1:length(x_dirs)) {
	a_rep <- scan(paste0(x_dirs[a], "/sequence_report.jsonl"), what="character", sep=" ")
	a_rep <- gsub("\\{", "", a_rep)
	a_rep <- gsub("\\}", "", a_rep)

	col_names <- c("assembly", "scaffold", "chr", "length", "role")
	output <- matrix(NA, nrow=length(a_rep), ncol=5)
	colnames(output) <- col_names
	for(b in 1:length(a_rep)) {
		b_rep <- strsplit(a_rep[b], ",")[[1]]
		if(substr(x_dirs[a], 1, 3) == "GCA") {
			output[b,1] <- sapply(strsplit(b_rep[grepl("assemblyAccession", b_rep)], ":"), "[[", 2)
			output[b,2] <- sapply(strsplit(b_rep[grepl("genbankAccession", b_rep)], ":"), "[[", 2)
			output[b,3] <- sapply(strsplit(b_rep[grepl("chrName", b_rep)], ":"), "[[", 2)
			output[b,4] <- sapply(strsplit(b_rep[grepl("length", b_rep)], ":"), "[[", 2)
			output[b,5] <- sapply(strsplit(b_rep[grepl("role", b_rep)], ":"), "[[", 2)
		} else if(substr(x_dirs[a], 1, 3) == "GCF") {
			output[b,1] <- sapply(strsplit(b_rep[grepl("assemblyAccession", b_rep)], ":"), "[[", 2)
			output[b,2] <- sapply(strsplit(b_rep[grepl("refseqAccession", b_rep)], ":"), "[[", 2)
			output[b,3] <- sapply(strsplit(b_rep[grepl("chrName", b_rep)], ":"), "[[", 2)
			output[b,4] <- sapply(strsplit(b_rep[grepl("length", b_rep)], ":"), "[[", 2)
			output[b,5] <- sapply(strsplit(b_rep[grepl("role", b_rep)], ":"), "[[", 2)
		}
		
	}
	if(a == 1) {
		write.table(output, file=output_name, quote=F, row.names=F, col.names=T, sep="\t")
	} else {
		write.table(output, file=output_name, quote=F, row.names=F, col.names=F, sep="\t", append=T)
	}
	
}
