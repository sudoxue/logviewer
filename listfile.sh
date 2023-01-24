search_dir=~/k10-logs
# for entry in "$search_dir"/*
rm huli.txt
rm executorcleanup.json
rm executorcleanup2.json
rm Failed-executor.txt
rm Failed-restore.txt
rm Failedto.txt
rm exectutor.txt
rm lognames.txt

select item in "$search_dir"/*
do
  sub_dir=$item
  break
done
account="$(basename -- $item)"
echo $account
rm -r $account
mkdir -p $account/executor
mkdir -p $account/kanister

touch executor.txt
# echo $sub_dir

for services in "$sub_dir/k10logs/services"/*
   do
     file="$(basename -- $services)"
     echo $services >> lognames.txt
   done

##############################################
#     check executor filed activities        #
##############################################

# echo $services

executor_name=$(grep executor-svc- lognames.txt )
# echo $executor_name
for item in $executor_name
 do
    cat "$item"  >>  executor.txt
 done

#check for specifi error
if grep -q "Failed to upload exported volume snapshot" executor.txt; then
   echo "Error message: Failed to upload exported volume snapshot found" >> error.txt
else 
   echo "wo kao, nothing"
fi

grep -wv "Fluentbit connection error" executor.txt | grep -v "Error:"  | grep -v "Logs for container" | grep -v "Log message dropped (buffer):" | grep -v "due to client-side throttling" | grep -v "kasten.io/k10/kio/utils/swagger_utils.go" | grep -v "Pulling job from queue"> executorcleanup.json
grep '{' executorcleanup.json > executorcleanup2.json



jq --arg key "File" '. | select(keys[0] == "File")' executorcleanup2.json > ${account}/executor/k10-commands.json
jq --arg key "Command" '. | select(keys[0] == "Command")' executorcleanup2.json > ${account}/executor/kopia-commands.json 
jq --arg key "Container" '. | select(keys[0] == "Container")' executorcleanup2.json > ${account}/executor/kanister-commands.json 

grep "Failed to" executorcleanup2.json > Failed-executor.txt

##############################################
#         check restore activities.          #
##############################################

k10_restore_pod_name=$(grep k10-restore-k10restore- lognames.txt )
for item in $k10_restore_pod_name
   do
      cat "$item" >> k10_restore.txt
   done 
 

grep -wv "Fluentbit connection error" executor.txt | grep -v "Error:"  | grep -v "Logs for container" | grep -v "Log message dropped (buffer):" | grep -v "due to client-side throttling" > k10restorecleanup.json
grep '{' executorcleanup.json > k10_restore2.json
grep "Failed to" executorcleanup2.json > Failed-restore.txt

##############################################
#         check         kanister.            #
##############################################

 
kanister_pod_name=$(grep kanister-svc- lognames.txt )
for item in $kanister_pod_name
   do
      grep -wv "Fluentbit connection error" executor.txt | grep -v "Error:"  | grep -v "Logs for container" | grep -v "Log message dropped (buffer):" | grep -v "due to client-side throttling" > kanistercleanup.json
      grep '{' kanistercleanup.json > kanister2.json
      grep "Failed" kanister2.json > Failed-kanister.txt
   done 
 
if grep -q "Failed to prepare Kopia API server for collections read"; then
  echo "Kopia api server issue found in kanister log" Failed-kanister.txt >> error.txt
else
  echo "nothing"
fi 
# echo $account
jq --arg key "File" '. | select(keys[0] == "File")' kanistercleanup.json > ${account}/kanister/k10-commands.json
jq --arg key "Command" '. | select(keys[0] == "Command")' kanistercleanup.json ${account}/kanister/kopia-commands.json 
jq --arg key "Container" '. | select(keys[0] == "Container")' kanistercleanup.json > ${account}/kanister/kanister-commands.json 



