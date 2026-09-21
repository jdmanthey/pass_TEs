options(scipen=999)

x_files <- list.files(pattern="*.no_dups.out$")

for(a in 1:length(x_files)) {
	print(a)
	input_file <- x_files[a]
	
	# read repeatmasker output
	a_rep <- read.table(input_file, header=T, fill=T)
	
	# edit 1-based to 0-based
	a_rep$q_start <- a_rep$q_start - 1
	
	output <- data.frame(id=as.character(a_rep$query), start=as.numeric(a_rep$q_start), end=as.numeric(a_rep$q_end))
	
	output_file <- paste0(input_file, ".bed")
	write.table(output, file=output_file, quote=F, col.names=F, row.names=F, sep="/t")
}
	
	
	
	
	
