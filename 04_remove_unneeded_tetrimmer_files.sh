# perform in TE trimmer output folder
for i in $( ls ); do
	echo $i
	rm -r $i/Classification_and_deduplication
	rm -r $i/Multiple_sequence_alignment
	rm -r $i/Single_fasta_files
	rm -r $i/TEtrimmer_for_proof_curation/TE_skipped
	rm -r $i/TEtrimmer_for_proof_curation/TE_low_copy
	rm -r $i/TEtrimmer_for_proof_curation/Clustered_proof_curation
	rm $i/TEtrimmer_for_proof_curation/Annotations_check_recommended/*fa
	rm $i/TEtrimmer_for_proof_curation/Annotations_check_required/*fa
	rm $i/TEtrimmer_for_proof_curation/Annotations_good/*fa
	rm $i/TEtrimmer_for_proof_curation/Annotations_perfect/*fa
done

