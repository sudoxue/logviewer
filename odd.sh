arr=()
arr=($(awk '/^$/{p=p+1;next} {if(p>1)print NR-p;p=0;}' k10_debug_logs.txt))
even_arr=()
odd_arr=()
# for i in `seq 0 $((${#arr[@]} - 1))`; do
#     
for i in `seq 0 $((${#arr[@]} - 1))`; do
     if (( i % 2 == 0 )); then
        
        even_arr[i]="${arr[i]}"
        # echo ${even_arr[*]}  
    else
        odd_arr[i]="${arr[i]}"
        # echo ${odd_arr[*]} 
         
    fi
done

echo ${even_arr[*]} 
echo ${odd_arr[*]} 


declare -p even_arr

declare -p odd_arr

# I will get the highest index number
highest_index=0
for index in "${!arr[@]}"; do
  if [[ "$index" -gt "$highest_index" ]]; then
    highest_index="$index"
  fi
done
echo "The highest index number is: $highest_index"

boundary=$highest_index

i=0
# echo ${#even_arr[@]}
while [ $i -lt $highest_index ]
do  
# echo $startline
# echo $endline
echo "${even_arr[i]},${odd_arr[i+1]}""p"
sed -n "${even_arr[i]},${odd_arr[i+1]}""p" k10_debug_logs.txt > niubee-${i}.txt
 i=$((i+2))
done

j=1
# echo ${#even_arr[@]}
while [ $j -lt $highest_index ]
do  
# echo $startline
# echo $endline
echo "${odd_arr[j]},${even_arr[j+1]}""p"
sed -n "${odd_arr[j]},${even_arr[j+1]}""p" k10_debug_logs.txt > niubee-${j}.txt
 j=$((j+2))
done



