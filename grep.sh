grep -wv "Fluentbit connection error" executor-svc-7f48c5c996-fqq94.txt | grep -v "Error:"  | grep -v "Logs for container" | grep -v "Log message dropped (buffer):" | grep -v "due to client-side throttling" > nimabi.json\n
# Kanister

grep -v "Error:" kanister-svc-54f979bf79-kcq28.txt | grep -v "Logs for container" | grep -v "Log message dropped" | grep -v "would violate PodSecurity" | jq  > kanister.json

# k10 debug log 

#key word "# K10: Profile/# K10: Policies " how to separate docs by keyword.