
while getopts n: flag
do
    case "${flag}" in
        n) namespace=${OPTARG};;
    esac
done

echo "Namespace: $namespace"

kubectl get pods -n $namespace | grep deployment | cut -d" " -f1 > tmp_pods_$namespace

while read i; do
service=`echo $i |  awk -F"-deployment" '{print $1}' `
echo $service: `kubectl describe pod -n $namespace $i | grep Image: | grep $service | awk -F"$service:" '{print $2}'`
done < tmp_pods_$namespace
