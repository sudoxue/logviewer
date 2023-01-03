debug_dir=.
#search_dir=/Users/michael.xue/mikelog/k10logs/services/
logfile_name=$(ls /Users/michael.xue/mikelog/k10logs/services/*.txt | cut -d "/" -f 7)
#for entry in "$search_dir"/*
for entry in $logfile_name
 do
   echo "$entry"
   echo "hello"
 done