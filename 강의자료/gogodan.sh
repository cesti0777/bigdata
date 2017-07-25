#! /bin/sh
hap=0
i=1

while [ $i -le 9 ]
do
	j=1
	echo "================"$i"=================="
	while [ $j -le 9 ]
	do
		echo $i" * "$j" = "`expr $i \* $j`
		j=`expr $j + 1`
	done
	i=`expr $i + 1`
done
exit 0