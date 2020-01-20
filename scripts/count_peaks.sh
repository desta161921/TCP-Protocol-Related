#!/bin/bash

######start of GNU Plot

	gnuplot -persist <<EOF
	set terminal postscript eps enhanced color "Times" 20
	set output "cubic32.eps"

	set title "Count the number of non-slow start peaks"

	set key right top
	set key box linestyle 50
	set key width -2
	set xrange [:10]
	
	xcolumn=1
	ycolumn=7
	count = 0

	#show timestamp
	set xlabel "Time [Seconds]"
	set ylabel "cwnd [Segments]"

	set grid xtics ytics mytics


	plot "cubic.csv" using (column(xcolumn)):(column(ycolumn)) title "cwnd" w l, \
		 "cubic.csv" using 1:(\$8>=2147483647 ? 0 : \$8) title "ssthresh" w l,\\
	 	 "cubic.csv" using (column(0)==0 ? (last2y=column(ycolumn), \
	 	 last2x=column(xcolumn), 1/0) : column(0)==1 ? (lasty=column(ycolumn), \
	 	 lastx=column(xcolumn), 1/0) : lastx) \
	 	 : \
	  	 (column(0) < 2 ? 1/0 : (last2y <= lasty && \
	 	 column(ycolumn) < lasty) ? (count=count+1, value=lasty, last2y=lasty, last2x=lastx, \
	 	 lasty=column(ycolumn), lastx=column(xcolumn), value) : (last2y=lasty, \
	 	 last2x=lastx, lasty=column(ycolumn), lastx=column(xcolumn), 1/0)) pt 7 not ,\
	 	 1/0 w p lc 3 pt 7 t sprintf("Non-slow start peaks = %i", count)
	print "Number of non-slow start peaks: ", count
EOF

##### End of GNU Plot











