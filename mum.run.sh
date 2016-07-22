#create the arrays to use for the loops
gn=(`ls | grep .fa`)
sn=(`ls | grep .fa | sed 's/.fa//g'`)
ls *.fa > gn.list

#create 'genome' files in correct format for bedtools for each genome that will be used i.e tab delimited contig name and length

length=${#gn[@]}
for ((i=0;i<$length;i++)); do
grep ">" ${gn[i]} | sed 's/len=//g'| sed 's/>//g' | awk -v OFS='\t' '{print$1,$2}' > ${sn[i]}.genome
done

#align all genomes agains each other with nucmer

while read j; do 
for ((i=0;i<$length;i++)); do
nucmer --maxmatch -p $j"_"${sn[i]} $j ${gn[i]};done;done<gn.list 


#get the coordinates of all matches and then merge overlapping intervals
df=(`ls *.delta | sort` )
sdf=(`ls *.delta | sed 's/.delta//g' | sort`)
dlength=${#df[@]}

for ((i=0;i<$dlength;i++)); do
show-coords -r ${df[i]} | \
tail -n +6 | awk -v OFS='\t' '{print$12,$1,$2,"-",$10}' | bedtools merge -i - > ${sdf[i]}.bed;done

#find the regions of the genome with no coverage for each comparison

bedtools complement -i - -g 






