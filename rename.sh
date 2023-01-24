search_terms=("# K10: Getting K10 endpoints" 
"# K10: Getting K10 pods"
"aggregatedapis-svc-" 
"auth-svc-7" 
"catalog-svc-" 
"controllermanager-svc" 
"crypto-svc" 
"dashboardbff-svc" 
"executor-svc" 
"data-mover-svc" 
"frontend-svc-" 
"gateway-" 
"jobs-svc-"
"kanister-svc-"
"k10-grafana-"
"logging-svc-"
"metering-svc-"
"prometheus-server-"
"state-svc-"
"# K10: Profiles"
"# K10: Policies"
"kubectl get apiservices"
"Getting Kubernetes and K10 resource usage info")

for file in ./*.txt; do
  match=""
  for term in "${search_terms[@]}"; do
    if grep -q "$term" "$file"; then
      match="$term"
      break
    fi
  done
  if [[ -n "$match" ]]; then
    newname=$(echo $match | tr -s '[:space:]' '_' | sed -r 's/[^a-zA-Z0-9_]+//g')
    mv "$file" "./$newname-$(basename "$file")"
  fi
done

# echo ${SearchStr[*]}
# for i in ${!SearchStr[@]}
# do
#    echo ${SearchStr[i]}
# done


# if grep -Fxq "# Examine K10 status" niubee-0.txt
# then
# echo "Found"
# else 
# echo "not Found"
# fi
