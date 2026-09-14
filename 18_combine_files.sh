# fasta
cat _CR1_ERV_seq.fasta > _all_new_seqs.fasta
cat _others_seqs_step5.fasta >> _all_new_seqs.fasta

# repbase fasta
cat vertebrate_repbase_31.08.fasta > vertebrate_repbase_31.08_added2.fasta
cat _all_new_seqs.fasta >> vertebrate_repbase_31.08_added2.fasta

# seq names
cat _CR1_ERV_seq_names.txt > _all_new_seqs_names.txt
cat _others_seq_names.txt >> _all_new_seqs_names.txt 
