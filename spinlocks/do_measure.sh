#! /bin/bash

EXES="test_and_set test_test_and_set test_and_set_yield test_and_set_backoff swap test_swap swap_yield swap_backoff compare_and_swap test_compare_and_swap compare_and_swap_yield compare_and_swap_backoff ticket_lock array_lock mcs_spinlock clh_spinlock"
OUT=measures_spinlocks.log

echo "Saving out to $OUT"

if [ -x /usr/bin/time ]
then 
	TIME='/usr/bin/time -f "  times: real %E, user %U, sys %S"'
else
	TIME=time
fi

cat /proc/cpuinfo > $OUT
echo "-----------" >> $OUT

for p  in $EXES
do
	echo -n Testing $p 
	echo >> $OUT
	echo -- \[$p\] -- >> $OUT
	for i in `seq 4`
	do
		(eval $TIME ./$p) &>> $OUT
		echo -n " [$i]" 
		sleep 1
	done
	echo

	echo --- >> $OUT
done

 
