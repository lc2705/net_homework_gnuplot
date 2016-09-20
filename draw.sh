#!/bin/sh

sentfilelist=$(ls *sent*)
receivefilelist=$(ls *receive*) 
datadir=data
picdir=pic

if [ ! -d $datadir ]
then
	mkdir $datadir
fi

if [ ! -d $picdir ]
then 
	mkdir $picdir
fi

for file in $sentfilelist
do
	if [ "${file##*.}" = "txt" ]; then
		basename=$(basename $file ".${file##*.}")
		touch ${datadir}/${basename}_seq.dat
		touch ${datadir}/${basename}_inflight.dat
		awk '{if($1=="seq") print $4" "$2}' $file > ${datadir}/${basename}_seq.dat
		awk '{if($1=="inflight_size") print $4" "$2+0.001}' $file > ${datadir}/${basename}_inflight.dat

		pic=${picdir}/${basename}_seq.plot
		echo "[ Drawing Sent Pic $pic]"
		touch $pic
		echo "set term jpeg" > $pic
		echo "set output '${picdir}/${basename}_seq.jpg'" >> $pic
		echo "set xlabel 'time (s)'" >> $pic
		echo "set ylabel 'sequence number'" >> $pic
		echo "plot '${datadir}/${basename}_seq.dat'" >> $pic
		echo "reset" >> $pic
		gnuplot $pic

		pic=${picdir}/${basename}_inflight.plot
		echo "[ Drawing Sent Pic $pic]"
		touch $pic
		echo "set term jpeg" > $pic
		echo "set output '${picdir}/${basename}_inflight.jpg'" >> $pic
		echo "set xlabel 'time (s)'" >> $pic
		echo "set ylabel 'inflight size (Bytes)'" >> $pic
		echo "set logscale y" >> $pic
		echo "set yrange[100:100000]" >> $pic
#		echo "set logscale x" >> $pic
		echo "plot '${datadir}/${basename}_inflight.dat'" >> $pic
		echo "reset" >> $pic
		gnuplot $pic
	fi
done

for file in $receivefilelist
do
	if [ "${file##*.}" = "txt" ]
	then
		basename=$(basename $file ".${file##*.}")
		touch ${datadir}/${basename}_seq.dat
		awk '{if($1=="seq") print $4" "$2}' $file > ${datadir}/${basename}_seq.dat

		pic=${picdir}/${basename}_seq.plot
		echo "[ Drawing Sent Pic $pic]"
		touch $pic
		echo "set term jpeg" > $pic
		echo "set output '${picdir}/${basename}_seq.jpg'" >> $pic
		echo "set xlabel 'time (s)'" >> $pic
		echo "set ylabel 'sequence number'" >> $pic
		echo "plot '${datadir}/${basename}_seq.dat'" >> $pic
		echo "reset" >> $pic
		gnuplot $pic
	fi
done

rm -r data
rm pic/*.plot

