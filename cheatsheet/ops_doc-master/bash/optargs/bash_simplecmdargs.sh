if [ $# -gt 1 ]
then 
echo "Please specify only one parameter"
exit 1
fi

for i in "$@"
do
    network_name="$network_name $i"
done