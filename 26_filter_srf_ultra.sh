for i in {1..106}; do
    echo $i
    repmask_name=$(cut -f2 raw_reference_list.txt | head -n $i | tail -n1).no_dups.out.bed
    base_name=$(cut -f3 raw_reference_list.txt | head -n $i | tail -n1)
    ultra_name=${base_name}.ultra.txt
    srf_name=srf-aln__${base_name}.bed
    
    bedtools subtract -a $srf_name -b $repmask_name > ${base_name}.filtered.srf.bed
    
    head -n 1 $ultra_name > ${base_name}.filtered.ultra
    
    tail -n +2 $ultra_name > ${base_name}.temp
    
    bedtools subtract -a ${base_name}.temp -b $repmask_name > ${base_name}.temp.ultra
 
    bedtools subtract -a ${base_name}.temp.ultra -b ${base_name}.filtered.srf.bed >> ${base_name}.filtered.ultra
   
    rm ${base_name}.temp.ultra 
    
    rm ${base_name}.temp
    
done

