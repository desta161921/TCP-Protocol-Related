#!/bin/bash

PORT=5201
SERVER_ADDRESS=128.39.74.10
TIME=1000 #in  seconds
INTERVAL=1
INTERFACE=enp0s3



if [ $# -eq 0 ]
   then
    echo "Usage instruction: sudo bash bashScriptName.sh {1.0|1.1|1.2|1.3|1.4|1.5|1.6|2.1|2.2|......|6.6}"
    echo " "
   exit
fi

########################

if [[ $1 = "1.0" ]]; 
  then
	sudo modprobe -r tcp_probe
	sudo modprobe tcp_probe $PORT full=1
	sudo chmod 444 /proc/net/tcpprobe
	sudo sysctl -w net.ipv4.route.flush=1
	cat /proc/net/tcpprobe > ../../data/cubic/cubic1_0.csv &
	TCPCAP=$!

	iperf3 -A 0 -c $SERVER_ADDRESS -p $PORT -t $TIME -i $INTERVAL -f m -Z --logfile ../../data/cubic/cubic10_log.out --forceflush 
	#iperf -c $SERVER_ADDRESS -p $PORT -t $TIME -i $INTERVAL -f m
	sudo kill $TCPCAP

######start of GNU Plot
	gnuplot -persist <<EOF
	set style data lines
	set terminal postscript eps enhanced color "Times" 20
	set output "../../outputs/cubic/cubic_cwnd1_0.eps"

	set title "TCP CUBIC:Bandwidth=NA, Delay=NA, Jitter=NA, Loss=NA"

	set style line 99 linetype 1 linecolor rgb "#999999" lw 2
	#set border 1 back ls 11
	set key right top
	set key box linestyle 50
	set key width -2
	set xrange [:$TIME]

	set key spacing 1.2
	#set nokey

	set grid xtics ytics mytics
	#set size 2
	#set size ratio 0.4

	#show timestamp
	set xlabel "Time [Seconds]"
	set ylabel "cwnd [Segments]"

	set style line 1 lc rgb "#ff0000" lt 1 pi 0 pt 4 lw 4 ps 0

	# Congestion control send window

	plot "../../data/cubic/cubic1_0.csv" using 1:7 title "cwnd", \\
     	 "../../data/cubic/cubic1_0.csv" using 1:(\$8>=2147483647 ? 0 : \$8) title "ssthresh"
EOF
##### End of GNU Plot
  exit

fi
####################S

if [[ $1 = "1.1" ]]; 
  then
  	
	sudo modprobe -r tcp_probe
	sudo modprobe tcp_probe $PORT bufsize=32768 full=1
	sudo chmod 444 /proc/net/tcpprobe
	sudo sysctl -w net.ipv4.route.flush=1
	cat /proc/net/tcpprobe > ../../data/cubic/cubic1_1.csv &
	TCPCAP=$!

	iperf3 -A 0 -c $SERVER_ADDRESS -b 10m -p $PORT -t $TIME -i $INTERVAL -f m -Z --logfile ../../data/cubic/cubic11_log.out --forceflush 
	sudo tc qdisc add dev $INTERFACE root netem delay 1ms 0.001ms loss 0.01%
	sudo kill $TCPCAP

######start of GNU Plot
	gnuplot -persist <<EOF
	set style data lines
	set terminal postscript eps enhanced color "Times" 20
	set output "../../outputs/cubic/cubic_cwnd1_1.eps"

	set title "TCP CUBIC:Bandwidth=10mbit, Delay=1ms, Jitter=0.001ms, Loss=0.01%"

	set style line 99 linetype 1 linecolor rgb "#999999" lw 2
	#set border 1 back ls 11
	set key right top
	set key box linestyle 50
	set key width -2
	set xrange [:$TIME]

	set key spacing 1.2
	#set nokey

	set grid xtics ytics mytics
	#set size 2
	#set size ratio 0.4

	#show timestamp
	set xlabel "Time [Seconds]"
	set ylabel "cwnd [Segments]"

	set style line 1 lc rgb "#ff0000" lt 1 pi 0 pt 4 lw 4 ps 0

	# Congestion control send window

	plot "../../data/cubic/cubic1_1.csv" using 1:7 title "cwnd", \\
     	 "../../data/cubic/cubic1_1.csv" using 1:(\$8>=2147483647 ? 0 : \$8) title "ssthresh"
EOF
sudo tc qdisc del dev $INTERFACE root
##### End of GNU Plot
  exit

fi

########################

if [[ $1 = "1.2" ]]; 
  then
  	
	sudo modprobe -r tcp_probe
	sudo modprobe tcp_probe $PORT bufsize=32768 full=1
	sudo chmod 444 /proc/net/tcpprobe
	sudo sysctl -w net.ipv4.route.flush=1
	cat /proc/net/tcpprobe > ../../data/cubic/cubic1_2.csv &
	TCPCAP=$!

	iperf3 -A 0 -c $SERVER_ADDRESS -b 10m -p $PORT -t $TIME -i $INTERVAL -f m -Z --logfile ../../data/cubic/cubic12_log.out --forceflush
	sudo tc qdisc add dev $INTERFACE root netem delay 2ms 0.1ms loss 0.05%
	sudo kill $TCPCAP

######start of GNU Plot
	gnuplot -persist <<EOF
	set style data lines
	set terminal postscript eps enhanced color "Times" 20
	set output "../../outputs/cubic/cubic_cwnd1_2.eps"

	set title "TCP CUBIC:Bandwidth=10mbit, Delay=2ms, Jitter=0.01ms, Loss=0.05%"

	set style line 99 linetype 1 linecolor rgb "#999999" lw 2
	#set border 1 back ls 11
	set key right top
	set key box linestyle 50
	set key width -2
	set xrange [:$TIME]

	set key spacing 1.2
	#set nokey

	set grid xtics ytics mytics
	#set size 2
	#set size ratio 0.4

	#show timestamp
	set xlabel "Time [Seconds]"
	set ylabel "cwnd [Segments]"

	set style line 1 lc rgb "#ff0000" lt 1 pi 0 pt 4 lw 4 ps 0

	# Congestion control send window

	plot "../../data/cubic/cubic1_2.csv" using 1:7 title "cwnd", \\
     	 "../../data/cubic/cubic1_2.csv" using 1:(\$8>=2147483647 ? 0 : \$8) title "ssthresh"
EOF
sudo tc qdisc del dev $INTERFACE root
##### End of GNU Plot
  exit

fi

########################

if [[ $1 = "1.3" ]]; 
  then
  	
	sudo modprobe -r tcp_probe
	sudo modprobe tcp_probe $PORT bufsize=32768 full=1
	sudo chmod 444 /proc/net/tcpprobe
	sudo sysctl -w net.ipv4.route.flush=1
	cat /proc/net/tcpprobe > ../../data/cubic/cubic1_3.csv &
	TCPCAP=$!

	iperf3 -A 0 -c $SERVER_ADDRESS -b 10m -p $PORT -t $TIME -i $INTERVAL -f m -Z --logfile ../../data/cubic/cubic13_log.out --forceflush
	sudo tc qdisc add dev $INTERFACE root netem delay 3ms 0.2ms loss 0.1%
	sudo kill $TCPCAP

######start of GNU Plot
	gnuplot -persist <<EOF
	set style data lines
	set terminal postscript eps enhanced color "Times" 20
	set output "../../outputs/cubic/cubic_cwnd1_3.eps"

	set title "TCP CUBIC:Bandwidth=10mbit, Delay=3ms, Jitter=0.02ms, Loss=0.1%"

	set style line 99 linetype 1 linecolor rgb "#999999" lw 2
	#set border 1 back ls 11
	set key right top
	set key box linestyle 50
	set key width -2
	set xrange [:$TIME]

	set key spacing 1.2
	#set nokey

	set grid xtics ytics mytics
	#set size 2
	#set size ratio 0.4

	#show timestamp
	set xlabel "Time [Seconds]"
	set ylabel "cwnd [Segments]"

	set style line 1 lc rgb "#ff0000" lt 1 pi 0 pt 4 lw 4 ps 0

	# Congestion control send window

	plot "../../data/cubic/cubic1_3.csv" using 1:7 title "cwnd", \\
     	 "../../data/cubic/cubic1_3.csv" using 1:(\$8>=2147483647 ? 0 : \$8) title "ssthresh"
EOF
sudo tc qdisc del dev $INTERFACE root
##### End of GNU Plot
  exit

fi

########################

if [[ $1 = "1.4" ]]; 
  then
  	
	sudo modprobe -r tcp_probe
	sudo modprobe tcp_probe $PORT bufsize=32768 full=1
	sudo chmod 444 /proc/net/tcpprobe
	sudo sysctl -w net.ipv4.route.flush=1
	cat /proc/net/tcpprobe > ../../data/cubic/cubic1_4.csv &
	TCPCAP=$!

	iperf3 -A 0 -c $SERVER_ADDRESS -b 10m -p $PORT -t $TIME -i $INTERVAL -f m -Z --logfile ../../data/cubic/cubic14_log.out --forceflush
	sudo tc qdisc add dev $INTERFACE root netem delay 5ms 0.5ms loss 1%
	sudo kill $TCPCAP

######start of GNU Plot
	gnuplot -persist <<EOF
	set style data lines
	set terminal postscript eps enhanced color "Times" 20
	set output "../../outputs/cubic/cubic_cwnd1_4.eps"

	set title "TCP CUBIC:Bandwidth=10mbit, Delay=5ms, Jitter=0.5ms, Loss=1%"

	set style line 99 linetype 1 linecolor rgb "#999999" lw 2
	#set border 1 back ls 11
	set key right top
	set key box linestyle 50
	set key width -2
	set xrange [:$TIME]

	set key spacing 1.2
	#set nokey

	set grid xtics ytics mytics
	#set size 2
	#set size ratio 0.4

	#show timestamp
	set xlabel "Time [Seconds]"
	set ylabel "cwnd [Segments]"

	set style line 1 lc rgb "#ff0000" lt 1 pi 0 pt 4 lw 4 ps 0

	# Congestion control send window

	plot "../../data/cubic/cubic1_4.csv" using 1:7 title "cwnd", \\
     	 "../../data/cubic/cubic1_4.csv" using 1:(\$8>=2147483647 ? 0 : \$8) title "ssthresh"
EOF
sudo tc qdisc del dev $INTERFACE root
##### End of GNU Plot
  exit

fi

########################

if [[ $1 = "1.5" ]]; 
  then
  	
	sudo modprobe -r tcp_probe
	sudo modprobe tcp_probe $PORT bufsize=32768 full=1
	sudo chmod 444 /proc/net/tcpprobe
	sudo sysctl -w net.ipv4.route.flush=1
	cat /proc/net/tcpprobe > ../../data/cubic/cubic1_5.csv &
	TCPCAP=$!

	iperf3 -A 0 -c $SERVER_ADDRESS -b 10m -p $PORT -t $TIME -i $INTERVAL -f m -Z --logfile ../../data/cubic/cubic15_log.out --forceflush
	sudo tc qdisc add dev $INTERFACE root netem delay 7ms 1ms loss 1.5%
	sudo kill $TCPCAP

######start of GNU Plot
	gnuplot -persist <<EOF
	set style data lines
	set terminal postscript eps enhanced color "Times" 20
	set output "../../outputs/cubic/cubic_cwnd1_5.eps"

	set title "TCP CUBIC:Bandwidth=10mbit, Delay=7ms, Jitter=1ms, Loss=1.5%"

	set style line 99 linetype 1 linecolor rgb "#999999" lw 2
	#set border 1 back ls 11
	set key right top
	set key box linestyle 50
	set key width -2
	set xrange [:$TIME]

	set key spacing 1.2
	#set nokey

	set grid xtics ytics mytics
	#set size 2
	#set size ratio 0.4

	#show timestamp
	set xlabel "Time [Seconds]"
	set ylabel "cwnd [Segments]"

	set style line 1 lc rgb "#ff0000" lt 1 pi 0 pt 4 lw 4 ps 0

	# Congestion control send window

	plot "../../data/cubic/cubic1_5.csv" using 1:7 title "cwnd", \\
     	 "../../data/cubic/cubic1_5.csv" using 1:(\$8>=2147483647 ? 0 : \$8) title "ssthresh"
EOF
sudo tc qdisc del dev $INTERFACE root
##### End of GNU Plot
  exit

fi

########################

if [[ $1 = "1.6" ]]; 
  then
  	
	sudo modprobe -r tcp_probe
	sudo modprobe tcp_probe $PORT bufsize=32768 full=1
	sudo chmod 444 /proc/net/tcpprobe
	sudo sysctl -w net.ipv4.route.flush=1
	cat /proc/net/tcpprobe > ../../data/cubic/cubic1_6.csv &
	TCPCAP=$!

	iperf3 -A 0 -c $SERVER_ADDRESS -b 10m -p $PORT -t $TIME -i $INTERVAL -f m -Z --logfile ../../data/cubic/cubic16_log.out --forceflush
	sudo tc qdisc add dev $INTERFACE root netem delay 10ms 2ms loss 2%
	sudo kill $TCPCAP

######start of GNU Plot
	gnuplot -persist <<EOF
	set style data lines
	set terminal postscript eps enhanced color "Times" 20
	set output "../../outputs/cubic/cubic_cwnd1_6.eps"

	set title "TCP CUBIC:Bandwidth=10mbit, Delay=10ms, Jitter=2ms, Loss=2%"

	set style line 99 linetype 1 linecolor rgb "#999999" lw 2
	#set border 1 back ls 11
	set key right top
	set key box linestyle 50
	set key width -2
	set xrange [:$TIME]

	set key spacing 1.2
	#set nokey

	set grid xtics ytics mytics
	#set size 2
	#set size ratio 0.4

	#show timestamp
	set xlabel "Time [Seconds]"
	set ylabel "cwnd [Segments]"

	set style line 1 lc rgb "#ff0000" lt 1 pi 0 pt 4 lw 4 ps 0

	# Congestion control send window

	plot "../../data/cubic/cubic1_6.csv" using 1:7 title "cwnd", \\
     	 "../../data/cubic/cubic1_6.csv" using 1:(\$8>=2147483647 ? 0 : \$8) title "ssthresh"
EOF
sudo tc qdisc del dev $INTERFACE root
##### End of GNU Plot
  exit

fi

#########################

if [[ $1 = "2.1" ]]; 
  then
  	
	sudo modprobe -r tcp_probe
	sudo modprobe tcp_probe $PORT bufsize=32768 full=1
	sudo chmod 444 /proc/net/tcpprobe
	sudo sysctl -w net.ipv4.route.flush=1
	cat /proc/net/tcpprobe > ../../data/cubic/cubic2_1.csv &
	TCPCAP=$!

	iperf3 -A 0 -c $SERVER_ADDRESS -b 100m -p $PORT -t $TIME -i $INTERVAL -f m -Z --logfile ../../data/cubic/cubic21_log.out --forceflush
	sudo tc qdisc add dev $INTERFACE root netem delay 1ms 0.001ms loss 0.01%
	sudo kill $TCPCAP

######stat of GNU Plot
	gnuplot -persist <<EOF
	set style data lines
	set terminal postscript eps enhanced color "Times" 20
	set output "../../outputs/cubic/cubic_cwnd2_1.eps"

	set title "TCP CUBIC:Bandwidth=100mbit, Delay=1ms, Jitter=0.001ms, Loss=0.01%"

	set style line 99 linetype 1 linecolor rgb "#999999" lw 2
	#set border 1 back ls 11
	set key right top
	set key box linestyle 50
	set key width -2
	set xrange [:$TIME]

	set key spacing 1.2
	#set nokey

	set grid xtics ytics mytics
	#set size 2
	#set size ratio 0.4

	#show timestamp
	set xlabel "Time [Seconds]"
	set ylabel "cwnd [Segments]"

	set style line 1 lc rgb "#ff0000" lt 1 pi 0 pt 4 lw 4 ps 0

	# Congestion control send window

	plot "../../data/cubic/cubic2_1.csv" using 1:7 title "cwnd", \\
     	 "../../data/cubic/cubic2_1.csv" using 1:(\$8>=2147483647 ? 0 : \$8) title "ssthresh"
EOF
sudo tc qdisc del dev $INTERFACE root
##### End of GNU Plot
  exit

fi

#########################

if [[ $1 = "2.2" ]]; 
  then
  	
	sudo modprobe -r tcp_probe
	sudo modprobe tcp_probe $PORT bufsize=32768 full=1
	sudo chmod 444 /proc/net/tcpprobe
	sudo sysctl -w net.ipv4.route.flush=1
	cat /proc/net/tcpprobe > ../../data/cubic/cubic2_2.csv &
	TCPCAP=$!

	iperf3 -A 0 -c $SERVER_ADDRESS -b 100m -p $PORT -t $TIME -i $INTERVAL -f m -Z --logfile ../../data/cubic/cubic22_log.out --forceflush
	sudo tc qdisc add dev $INTERFACE root netem delay 2ms 0.1ms loss 0.05%
	sudo kill $TCPCAP

######stat of GNU Plot
	gnuplot -persist <<EOF
	set style data lines
	set terminal postscript eps enhanced color "Times" 20
	set output "../../outputs/cubic/cubic_cwnd2_2.eps"

	set title "TCP CUBIC:Bandwidth=100mbit, Delay=2ms, Jitter=0.1ms, Loss=0.05%"

	set style line 99 linetype 1 linecolor rgb "#999999" lw 2
	#set border 1 back ls 11
	set key right top
	set key box linestyle 50
	set key width -2
	set xrange [:$TIME]
	

	set key spacing 1.2
	#set nokey

	set grid xtics ytics mytics
	#set size 2
	#set size ratio 0.4

	#show timestamp
	set xlabel "Time [Seconds]"
	set ylabel "cwnd [Segments]"

	set style line 1 lc rgb "#ff0000" lt 1 pi 0 pt 4 lw 4 ps 0

	# Congestion control send window

	plot "../../data/cubic/cubic2_2.csv" using 1:7 title "cwnd", \\
     	 "../../data/cubic/cubic2_2.csv" using 1:(\$8>=2147483647 ? 0 : \$8) title "ssthresh"
EOF
sudo tc qdisc del dev $INTERFACE root
##### End of GNU Plot
  exit

fi

#########################

if [[ $1 = "2.3" ]]; 
  then
  	
	sudo modprobe -r tcp_probe
	sudo modprobe tcp_probe $PORT bufsize=32768 full=1
	sudo chmod 444 /proc/net/tcpprobe
	sudo sysctl -w net.ipv4.route.flush=1
	cat /proc/net/tcpprobe > ../../data/cubic/cubic2_3.csv &
	TCPCAP=$!

	iperf3 -A 0 -c $SERVER_ADDRESS -b 100m -p $PORT -t $TIME -i $INTERVAL -f m -Z --logfile ../../data/cubic/cubic23_log.out --forceflush
	sudo tc qdisc add dev $INTERFACE root netem delay 3ms 0.2ms loss 0.1%
	sudo kill $TCPCAP

######stat of GNU Plot
	gnuplot -persist <<EOF
	set style data lines
	set terminal postscript eps enhanced color "Times" 20
	set output "../../outputs/cubic/cubic_cwnd2_3.eps"

	set title "TCP CUBIC:Bandwidth=100mbit, Delay=3ms, Jitter=0.2ms, Loss=0.1%"

	set style line 99 linetype 1 linecolor rgb "#999999" lw 2
	#set border 1 back ls 11
	set key right top
	set key box linestyle 50
	set key width -2
	set xrange [:$TIME]

	set key spacing 1.2
	#set nokey

	set grid xtics ytics mytics
	#set size 2
	#set size ratio 0.4

	#show timestamp
	set xlabel "Time [Seconds]"
	set ylabel "cwnd [Segments]"

	set style line 1 lc rgb "#ff0000" lt 1 pi 0 pt 4 lw 4 ps 0

	# Congestion control send window

	plot "../../data/cubic/cubic2_3.csv" using 1:7 title "cwnd", \\
     	 "../../data/cubic/cubic2_3.csv" using 1:(\$8>=2147483647 ? 0 : \$8) title "ssthresh"
EOF
sudo tc qdisc del dev $INTERFACE root
##### End of GNU Plot
  exit

fi

#########################

if [[ $1 = "2.4" ]]; 
  then
  	
	sudo modprobe -r tcp_probe
	sudo modprobe tcp_probe $PORT bufsize=32768 full=1
	sudo chmod 444 /proc/net/tcpprobe
	sudo sysctl -w net.ipv4.route.flush=1
	cat /proc/net/tcpprobe > ../../data/cubic/cubic2_4.csv &
	TCPCAP=$!

	iperf3 -A 0 -c $SERVER_ADDRESS -b 100m -p $PORT -t $TIME -i $INTERVAL -f m -Z --logfile ../../data/cubic/cubic24_log.out --forceflush
	sudo tc qdisc add dev $INTERFACE root netem delay 5ms 0.5ms loss 1%
	sudo kill $TCPCAP

######stat of GNU Plot
	gnuplot -persist <<EOF
	set style data lines
	set terminal postscript eps enhanced color "Times" 20
	set output "../../outputs/cubic/cubic_cwnd2_4.eps"

	set title "TCP CUBIC:Bandwidth=100mbit, Delay=5ms, Jitter=0.5ms, Loss=1%"

	set style line 99 linetype 1 linecolor rgb "#999999" lw 2
	#set border 1 back ls 11
	set key right top
	set key box linestyle 50
	set key width -2
	set xrange [:$TIME]

	set key spacing 1.2
	#set nokey

	set grid xtics ytics mytics
	#set size 2
	#set size ratio 0.4

	#show timestamp
	set xlabel "Time [Seconds]"
	set ylabel "cwnd [Segments]"

	set style line 1 lc rgb "#ff0000" lt 1 pi 0 pt 4 lw 4 ps 0

	# Congestion control send window

	plot "../../data/cubic/cubic2_4.csv" using 1:7 title "cwnd", \\
     	 "../../data/cubic/cubic2_4.csv" using 1:(\$8>=2147483647 ? 0 : \$8) title "ssthresh"
EOF
sudo tc qdisc del dev $INTERFACE root
##### End of GNU Plot
  exit

fi

#########################

if [[ $1 = "2.5" ]]; 
  then
  	
	sudo modprobe -r tcp_probe
	sudo modprobe tcp_probe $PORT bufsize=32768 full=1
	sudo chmod 444 /proc/net/tcpprobe
	sudo sysctl -w net.ipv4.route.flush=1
	cat /proc/net/tcpprobe > ../../data/cubic/cubic2_5.csv &
	TCPCAP=$!

	iperf3 -A 0 -c $SERVER_ADDRESS -b 100m -p $PORT -t $TIME -i $INTERVAL -f m -Z --logfile ../../data/cubic/cubic25_log.out --forceflush
	sudo tc qdisc add dev $INTERFACE root netem delay 7ms 1ms loss 1.5%
	sudo kill $TCPCAP

######stat of GNU Plot
	gnuplot -persist <<EOF
	set style data lines
	set terminal postscript eps enhanced color "Times" 20
	set output "../../outputs/cubic/cubic_cwnd2_5.eps"

	set title "TCP CUBIC:Bandwidth=100mbit, Delay=7ms, Jitter=1ms, Loss=1.5%"

	set style line 99 linetype 1 linecolor rgb "#999999" lw 2
	#set border 1 back ls 11
	set key right top
	set key box linestyle 50
	set key width -2
	set xrange [:$TIME]

	set key spacing 1.2
	#set nokey

	set grid xtics ytics mytics
	#set size 2
	#set size ratio 0.4

	#show timestamp
	set xlabel "Time [Seconds]"
	set ylabel "cwnd [Segments]"

	set style line 1 lc rgb "#ff0000" lt 1 pi 0 pt 4 lw 4 ps 0

	# Congestion control send window

	plot "../../data/cubic/cubic2_5.csv" using 1:7 title "cwnd", \\
     	 "../../data/cubic/cubic2_5.csv" using 1:(\$8>=2147483647 ? 0 : \$8) title "ssthresh"
EOF
sudo tc qdisc del dev $INTERFACE root
##### End of GNU Plot
  exit

fi

#########################

if [[ $1 = "2.6" ]]; 
  then
  	
	sudo modprobe -r tcp_probe
	sudo modprobe tcp_probe $PORT bufsize=32768 full=1
	sudo chmod 444 /proc/net/tcpprobe
	sudo sysctl -w net.ipv4.route.flush=1
	cat /proc/net/tcpprobe > ../../data/cubic/cubic2_6.csv &
	TCPCAP=$!

	iperf3 -c $SERVER_ADDRESS -b 100m -p $PORT -t $TIME -i $INTERVAL -f m m -C, --congestion cubic --logfile ../../data/cubic/cubic26_log.out --forceflush
	sudo tc qdisc add dev $INTERFACE root netem delay 10ms 2ms loss 2%
	sudo kill $TCPCAP

######stat of GNU Plot
	gnuplot -persist <<EOF
	set style data lines
	set terminal postscript eps enhanced color "Times" 20
	set output "../../outputs/cubic/cubic_cwnd2_6.eps"

	set title "TCP CUBIC:Bandwidth=100mbit, Delay=10ms, Jitter=2ms, Loss=2%"

	set style line 99 linetype 1 linecolor rgb "#999999" lw 2
	#set border 1 back ls 11
	set key right top
	set key box linestyle 50
	set key width -2
	set xrange [:$TIME]

	set key spacing 1.2
	#set nokey

	set grid xtics ytics mytics
	#set size 2
	#set size ratio 0.4

	#show timestamp
	set xlabel "Time [Seconds]"
	set ylabel "cwnd [Segments]"

	set style line 1 lc rgb "#ff0000" lt 1 pi 0 pt 4 lw 4 ps 0

	# Congestion control send window

	plot "../../data/cubic/cubic2_6.csv" using 1:7 title "cwnd", \\
     	# "../../data/cubic/cubic2_6.csv" using 1:(\$8>=2147483647 ? 0 : \$8) title "ssthresh"
EOF
sudo tc qdisc del dev $INTERFACE root
##### End of GNU Plot
  exit

fi


#########################

if [[ $1 = "3.1" ]]; 
  then

	sudo modprobe -r tcp_probe
	sudo modprobe tcp_probe $PORT bufsize=32768 full=1
	sudo chmod 444 /proc/net/tcpprobe
	sudo sysctl -w net.ipv4.route.flush=1
	cat /proc/net/tcpprobe > ../../data/cubic/cubic3_1.csv &
	TCPCAP=$!
	
	iperf3 -c $SERVER_ADDRESS -b 300m -p $PORT  -t $TIME -i $INTERVAL -f m -C, --congestion cubic  --logfile ../../data/cubic/cubic31_log.out --forceflush
	sudo tc qdisc add dev $INTERFACE root netem delay 1ms 0.001ms loss 0.01%
	
	sudo kill $TCPCAP

# ######stat of GNU Plot
	gnuplot -persist <<EOF
	set style data lines
	set terminal postscript eps enhanced color "Times" 20
	set output "../../outputs/cubic/cubic_cwnd3_1.eps"

	set title "TCP CUBIC:Bandwidth=300mbit, Delay=1ms, Jitter=0.001ms, Loss=0.01%"
	#set title "TCP CUBIC:Bandwidth=300mbit, Delay=0ms, Jitter=0ms, Loss=0%"

	set style line 99 linetype 1 linecolor rgb "#999999" lw 2
	#set border 1 back ls 11
	set key right top
	set key box linestyle 50
	set key width -2
	set xrange [:$TIME]

	set key spacing 1.2
	#set nokey

	set grid xtics ytics mytics
	#set size 2
	#set size ratio 0.4

	#show timestamp
	set xlabel "Time [Seconds]"
	set ylabel "cwnd [Segments]"

	set style line 1 lc rgb "#ff0000" lt 1 pi 0 pt 4 lw 4 ps 0

	# Congestion control send window

	plot "../../data/cubic/cubic3_1.csv" using 1:7 title "cwnd", \\
     	 #"../../data/cubic/cubic3_1.csv" using 1:(\$8>=2147483647 ? 0 : \$8) title "ssthresh"
EOF
sudo tc qdisc del dev $INTERFACE root
##### End of GNU Plot
  exit

fi

#########################

if [[ $1 = "3.2" ]]; 
  then
  	
	sudo modprobe -r tcp_probe
	sudo modprobe tcp_probe $PORT bufsize=32768 full=1
	sudo chmod 444 /proc/net/tcpprobe
	sudo sysctl -w net.ipv4.route.flush=1
	cat /proc/net/tcpprobe > ../../data/cubic/cubic3_2.csv &
	TCPCAP=$!

	iperf3 -A 0 -c $SERVER_ADDRESS -b 300m -p $PORT -t $TIME -i $INTERVAL -f m -C, --congestion cubic --logfile ../../data/cubic/cubic32_log.out --forceflush
	sudo tc qdisc add dev $INTERFACE root netem delay 2ms 0.1ms loss 0.05%
	
	sudo kill $TCPCAP
	
######stat of GNU Plot
	gnuplot -persist <<EOF
	set style data lines
	set terminal postscript eps enhanced color "Times" 20
	set output "../../outputs/cubic/cubic_cwnd3_2.eps"

	set title "TCP CUBIC:Bandwidth=300mbit, Delay=2ms, Jitter=0.1ms, Loss=0.05%"

	set style line 99 linetype 1 linecolor rgb "#999999" lw 2
	#set border 1 back ls 11
	set key right top
	set key box linestyle 50
	set key width -2
	set xrange [:$TIME]

	set key spacing 1.2
	#set nokey

	set grid xtics ytics mytics
	#set size 2
	#set size ratio 0.4

	#show timestamp
	set xlabel "Time [Seconds]"
	set ylabel "cwnd [Segments]"

	set style line 1 lc rgb "#ff0000" lt 1 pi 0 pt 4 lw 4 ps 0

	# Congestion control send window

	plot "../../data/cubic/cubic3_2.csv" using 1:7 title "cwnd", \\
     	 #"../../data/cubic/cubic3_2.csv" using 1:(\$8>=2147483647 ? 0 : \$8) title "ssthresh"
EOF
sudo tc qdisc del dev $INTERFACE root
##### End of GNU Plot
  exit

fi

#########################

if [[ $1 = "3.3" ]]; 
  then
	sudo modprobe -r tcp_probe
	sudo modprobe tcp_probe $PORT bufsize=32768 full=1
	sudo chmod 444 /proc/net/tcpprobe
	sudo sysctl -w net.ipv4.route.flush=1
	cat /proc/net/tcpprobe > ../../data/cubic/cubic3_3.csv &
	TCPCAP=$!

	iperf3 -c $SERVER_ADDRESS -b 300m -p $PORT -t $TIME -i $INTERVAL -f m -C, --congestion cubic --logfile ../../data/cubic/cubic33_log.out --forceflush
	sudo tc qdisc add dev $INTERFACE root netem delay 3ms 0.2ms loss 0.1%
	sudo kill $TCPCAP

######stat of GNU Plot
	gnuplot -persist <<EOF
	set style data lines
	set terminal postscript eps enhanced color "Times" 20
	set output "../../outputs/cubic/cubic_cwnd3_3.eps"

	set title "TCP CUBIC:Bandwidth=300mbit, Delay=3ms, Jitter=0.2ms, Loss=0.1%"

	set style line 99 linetype 1 linecolor rgb "#999999" lw 2
	#set border 1 back ls 11
	set key right top
	set key box linestyle 50
	set key width -2
	set xrange [:$TIME]

	set key spacing 1.2
	#set nokey

	set grid xtics ytics mytics
	#set size 2
	#set size ratio 0.4

	#show timestamp
	set xlabel "Time [Seconds]"
	set ylabel "cwnd [Segments]"

	set style line 1 lc rgb "#ff0000" lt 1 pi 0 pt 4 lw 4 ps 0

	# Congestion control send window

	plot "../../data/cubic/cubic3_3.csv" using 1:7 title "cwnd", \\
     	# "../../data/cubic/cubic3_3.csv" using 1:(\$8>=2147483647 ? 0 : \$8) title "ssthresh"
EOF
sudo tc qdisc del dev $INTERFACE root
##### End of GNU Plot
  exit

fi

#########################

if [[ $1 = "3.4" ]]; 
  then
	sudo modprobe -r tcp_probe
	sudo modprobe tcp_probe $PORT bufsize=32768 full=1
	sudo chmod 444 /proc/net/tcpprobe
	sudo sysctl -w net.ipv4.route.flush=1
	cat /proc/net/tcpprobe > ../../data/cubic/cubic3_4.csv &
	TCPCAP=$!

	iperf3 -c $SERVER_ADDRESS -b 300m -p $PORT -t $TIME -i $INTERVAL -f m -C, --congestion cubic --logfile ../../data/cubic/cubic34_log.out --forceflush
	sudo tc qdisc add dev $INTERFACE root netem delay 5ms 0.5ms loss 1%
	sudo kill $TCPCAP

######stat of GNU Plot
	gnuplot -persist <<EOF
	set style data lines
	set terminal postscript eps enhanced color "Times" 20
	set output "../../outputs/cubic/cubic_cwnd3_4.eps"

	set title "TCP CUBIC:Bandwidth=300mbit, Delay=5ms, Jitter=0.5ms, Loss=1%"

	set style line 99 linetype 1 linecolor rgb "#999999" lw 2
	#set border 1 back ls 11
	set key right top
	set key box linestyle 50
	set key width -2
	set xrange [:$TIME]

	set key spacing 1.2
	#set nokey

	set grid xtics ytics mytics
	#set size 2
	#set size ratio 0.4

	#show timestamp
	set xlabel "Time [Seconds]"
	set ylabel "cwnd [Segments]"

	set style line 1 lc rgb "#ff0000" lt 1 pi 0 pt 4 lw 4 ps 0

	# Congestion control send window

	plot "../../data/cubic/cubic3_4.csv" using 1:7 title "cwnd", \\
     	 #"../../data/cubic/cubic3_4.csv" using 1:(\$8>=2147483647 ? 0 : \$8) title "ssthresh"
EOF
sudo tc qdisc del dev $INTERFACE root
##### End of GNU Plot
  exit

fi

#########################

if [[ $1 = "3.5" ]]; 
  then
  	
	sudo modprobe -r tcp_probe
	sudo modprobe tcp_probe $PORT bufsize=32768 full=1
	sudo chmod 444 /proc/net/tcpprobe
	sudo sysctl -w net.ipv4.route.flush=1
	cat /proc/net/tcpprobe > ../../data/cubic/cubic3_5.csv &
	TCPCAP=$!

	iperf3 -A 0 -c $SERVER_ADDRESS -b 300m -p $PORT -t $TIME -i $INTERVAL -f m -C, --congestion cubic --logfile ../../data/cubic/cubic35_log.out --forceflush
	sudo tc qdisc add dev $INTERFACE root netem delay 7ms 1ms loss 1.5%
	sudo kill $TCPCAP

######stat of GNU Plot
	gnuplot -persist <<EOF
	set style data lines
	set terminal postscript eps enhanced color "Times" 20
	set output "../../outputs/cubic/cubic_cwnd3_5.eps"

	set title "TCP CUBIC:Bandwidth=300mbit, Delay=7ms, Jitter=1ms, Loss=1.5%"

	set style line 99 linetype 1 linecolor rgb "#999999" lw 2
	#set border 1 back ls 11
	set key right top
	set key box linestyle 50
	set key width -2
	set xrange [:$TIME]

	set key spacing 1.2
	#set nokey

	set grid xtics ytics mytics
	#set size 2
	#set size ratio 0.4

	#show timestamp
	set xlabel "Time [Seconds]"
	set ylabel "cwnd [Segments]"

	set style line 1 lc rgb "#ff0000" lt 1 pi 0 pt 4 lw 4 ps 0

	# Congestion control send window

	plot "../../data/cubic/cubic3_5.csv" using 1:7 title "cwnd", \\
     	# "../../data/cubic/cubic3_5.csv" using 1:(\$8>=2147483647 ? 0 : \$8) title "ssthresh"
EOF
sudo tc qdisc del dev $INTERFACE root
##### End of GNU Plot
  exit

fi

#########################

if [[ $1 = "3.6" ]]; 
  then
  	
	sudo modprobe -r tcp_probe
	sudo modprobe tcp_probe $PORT bufsize=32768 full=1
	sudo chmod 444 /proc/net/tcpprobe
	sudo sysctl -w net.ipv4.route.flush=1
	cat /proc/net/tcpprobe > ../../data/cubic/cubic3_6.csv &
	TCPCAP=$!

	iperf3 -c $SERVER_ADDRESS -b 300m -p $PORT -t $TIME -i $INTERVAL -f m -C, --congestion cubic --logfile ../../data/cubic/cubic36_log.out --forceflush
	sudo tc qdisc add dev $INTERFACE root netem delay 10ms 2ms loss 2%
	sudo kill $TCPCAP

######stat of GNU Plot
	gnuplot -persist <<EOF
	set style data lines
	set terminal postscript eps enhanced color "Times" 20
	set output "../../outputs/cubic/cubic_cwnd3_6.eps"

	set title "TCP CUBIC:Bandwidth=300mbit, Delay=10ms, Jitter=2ms, Loss=2%"

	set style line 99 linetype 1 linecolor rgb "#999999" lw 2
	#set border 1 back ls 11
	set key right top
	set key box linestyle 50
	set key width -2
	set xrange [:$TIME]

	set key spacing 1.2
	#set nokey

	set grid xtics ytics mytics
	#set size 2
	#set size ratio 0.4

	#show timestamp
	set xlabel "Time [Seconds]"
	set ylabel "cwnd [Segments]"

	set style line 1 lc rgb "#ff0000" lt 1 pi 0 pt 4 lw 4 ps 0

	# Congestion control send window

	plot "../../data/cubic/cubic3_6.csv" using 1:7 title "cwnd"
     	 #"../../data/cubic/cubic3_6.csv" using 1:(\$8>=2147483647 ? 0 : \$8) title "ssthresh"
EOF
sudo tc qdisc del dev $INTERFACE root
##### End of GNU Plot
  exit

fi

#########################

if [[ $1 = "4.1" ]]; 
  then
  	
	sudo modprobe -r tcp_probe
	sudo modprobe tcp_probe $PORT bufsize=32768 full=1
	sudo chmod 444 /proc/net/tcpprobe
	sudo sysctl -w net.ipv4.route.flush=1
	cat /proc/net/tcpprobe > ../../data/cubic/cubic4_1.csv &
	TCPCAP=$!

	iperf3 -c $SERVER_ADDRESS -b 500m -p $PORT -t $TIME -i $INTERVAL -f m -C, --congestion cubic --logfile ../../data/cubic/cubic41_log.out --forceflush
	sudo tc qdisc add dev $INTERFACE root netem delay 1ms 0.001ms loss 0.01%
	sudo kill $TCPCAP

######stat of GNU Plot
	gnuplot -persist <<EOF
	set style data lines
	set terminal postscript eps enhanced color "Times" 20
	set output "../../outputs/cubic/cubic_cwnd4_1.eps"

	set title "TCP CUBIC:Bandwidth=500mbit, Delay=1ms, Jitter=0.001ms, Loss=0.01%"

	set style line 99 linetype 1 linecolor rgb "#999999" lw 2
	#set border 1 back ls 11
	set key right top
	set key box linestyle 50
	set key width -2
	set xrange [:$TIME]

	set key spacing 1.2
	#set nokey

	set grid xtics ytics mytics
	#set size 2
	#set size ratio 0.4

	#show timestamp
	set xlabel "Time [Seconds]"
	set ylabel "cwnd [Segments]"

	set style line 1 lc rgb "#ff0000" lt 1 pi 0 pt 4 lw 4 ps 0

	# Congestion control send window

	plot "../../data/cubic/cubic4_1.csv" using 1:7 title "cwnd", \\
     	# "../../data/cubic/cubic4_1.csv" using 1:(\$8>=2147483647 ? 0 : \$8) title "ssthresh"
EOF
sudo tc qdisc del dev $INTERFACE root
##### End of GNU Plot
  exit

fi

#########################

if [[ $1 = "4.2" ]]; 
  then
  	
	sudo modprobe -r tcp_probe
	sudo modprobe tcp_probe $PORT bufsize=32768 full=1
	sudo chmod 444 /proc/net/tcpprobe
	sudo sysctl -w net.ipv4.route.flush=1
	cat /proc/net/tcpprobe > ../../data/cubic/cubic4_2.csv &
	TCPCAP=$!

	iperf3 -c $SERVER_ADDRESS -b 500m -p $PORT -t $TIME -i $INTERVAL -f m -Z --logfile ../../data/cubic/cubic42_log.out --forceflush
	sudo tc qdisc add dev $INTERFACE root netem delay 2ms 0.1ms loss 0.05%
	sudo kill $TCPCAP

######stat of GNU Plot
	gnuplot -persist <<EOF
	set style data lines
	set terminal postscript eps enhanced color "Times" 20
	set output "../../outputs/cubic/cubic_cwnd4_2.eps"

	set title "TCP CUBIC:Bandwidth=500mbit, Delay=2ms, Jitter=0.1ms, Loss=0.05%"

	set style line 99 linetype 1 linecolor rgb "#999999" lw 2
	#set border 1 back ls 11
	set key right top
	set key box linestyle 50
	set key width -2
	set xrange [:$TIME]

	set key spacing 1.2
	#set nokey

	set grid xtics ytics mytics
	#set size 2
	#set size ratio 0.4

	#show timestamp
	set xlabel "Time [Seconds]"
	set ylabel "cwnd [Segments]"

	set style line 1 lc rgb "#ff0000" lt 1 pi 0 pt 4 lw 4 ps 0

	# Congestion control send window

	plot "../../data/cubic/cubic4_2.csv" using 1:7 title "cwnd", \\
     	# "../../data/cubic/cubic4_2.csv" using 1:(\$8>=2147483647 ? 0 : \$8) title "ssthresh"
EOF
sudo tc qdisc del dev $INTERFACE root
##### End of GNU Plot
  exit

fi

#########################

if [[ $1 = "4.3" ]]; 
  then
  	
	sudo modprobe -r tcp_probe
	sudo modprobe tcp_probe $PORT bufsize=32768 full=1
	sudo chmod 444 /proc/net/tcpprobe
	sudo sysctl -w net.ipv4.route.flush=1
	cat /proc/net/tcpprobe > ../../data/cubic/cubic4_3.csv &
	TCPCAP=$!

	iperf3 -A 0 -c $SERVER_ADDRESS -b 500m -p $PORT -t $TIME -i $INTERVAL -f m -Z --logfile ../../data/cubic/cubic43_log.out --forceflush
	sudo tc qdisc add dev $INTERFACE root netem delay 3ms 0.2ms loss 0.1%
	sudo kill $TCPCAP

######stat of GNU Plot
	gnuplot -persist <<EOF
	set style data lines
	set terminal postscript eps enhanced color "Times" 20
	set output "../../outputs/cubic/cubic_cwnd4_3.eps"

	set title "TCP CUBIC:Bandwidth=500mbit, Delay=3ms, Jitter=0.2ms, Loss=0.1%"

	set style line 99 linetype 1 linecolor rgb "#999999" lw 2
	#set border 1 back ls 11
	set key right top
	set key box linestyle 50
	set key width -2
	set xrange [:$TIME]

	set key spacing 1.2
	#set nokey

	set grid xtics ytics mytics
	#set size 2
	#set size ratio 0.4

	#show timestamp
	set xlabel "Time [Seconds]"
	set ylabel "cwnd [Segments]"

	set style line 1 lc rgb "#ff0000" lt 1 pi 0 pt 4 lw 4 ps 0

	# Congestion control send window

	plot "../../data/cubic/cubic4_3.csv" using 1:7 title "cwnd", \\
     	 "../../data/cubic/cubic4_3.csv" using 1:(\$8>=2147483647 ? 0 : \$8) title "ssthresh"
EOF
sudo tc qdisc del dev $INTERFACE root
##### End of GNU Plot
  exit

fi

#########################

if [[ $1 = "4.4" ]]; 
  then
  	
	sudo modprobe -r tcp_probe
	sudo modprobe tcp_probe $PORT bufsize=32768 full=1
	sudo chmod 444 /proc/net/tcpprobe
	sudo sysctl -w net.ipv4.route.flush=1
	cat /proc/net/tcpprobe > ../../data/cubic/cubic4_4.csv &
	TCPCAP=$!

	iperf3 -A 0 -c $SERVER_ADDRESS -b 500m -p $PORT -t $TIME -i $INTERVAL -f m -Z --logfile ../../data/cubic/cubic44_log.out --forceflush
	sudo tc qdisc add dev $INTERFACE root netem delay 5ms 0.5ms loss 1%
	sudo kill $TCPCAP

######stat of GNU Plot
	gnuplot -persist <<EOF
	set style data lines
	set terminal postscript eps enhanced color "Times" 20
	set output "../../outputs/cubic/cubic_cwnd4_4.eps"

	set title "TCP CUBIC:Bandwidth=500mbit, Delay=5ms, Jitter=0.5ms, Loss=1%"

	set style line 99 linetype 1 linecolor rgb "#999999" lw 2
	#set border 1 back ls 11
	set key right top
	set key box linestyle 50
	set key width -2
	set xrange [:$TIME]

	set key spacing 1.2
	#set nokey

	set grid xtics ytics mytics
	#set size 2
	#set size ratio 0.4

	#show timestamp
	set xlabel "Time [Seconds]"
	set ylabel "cwnd [Segments]"

	set style line 1 lc rgb "#ff0000" lt 1 pi 0 pt 4 lw 4 ps 0

	# Congestion control send window

	plot "../../data/cubic/cubic4_4.csv" using 1:7 title "cwnd", \\
     	 "../../data/cubic/cubic4_4.csv" using 1:(\$8>=2147483647 ? 0 : \$8) title "ssthresh"
EOF
sudo tc qdisc del dev $INTERFACE root
##### End of GNU Plot
  exit

fi

#########################

if [[ $1 = "4.5" ]]; 
  then
  	
	sudo modprobe -r tcp_probe
	sudo modprobe tcp_probe $PORT bufsize=32768 full=1
	sudo chmod 444 /proc/net/tcpprobe
	sudo sysctl -w net.ipv4.route.flush=1
	cat /proc/net/tcpprobe > ../../data/cubic/cubic4_5.csv &
	TCPCAP=$!

	iperf3 -A 0 -c $SERVER_ADDRESS -b 500m -p $PORT -t $TIME -i $INTERVAL -f m -Z --logfile ../../data/cubic/cubic45_log.out --forceflush
	sudo tc qdisc add dev $INTERFACE root netem delay 7ms 1ms loss 1.5%
	sudo kill $TCPCAP

######stat of GNU Plot
	gnuplot -persist <<EOF
	set style data lines
	set terminal postscript eps enhanced color "Times" 20
	set output "../../outputs/cubic/cubic_cwnd4_5.eps"

	set title "TCP CUBIC:Bandwidth=500mbit, Delay=7ms, Jitter=1ms, Loss=1.5%"

	set style line 99 linetype 1 linecolor rgb "#999999" lw 2
	#set border 1 back ls 11
	set key right top
	set key box linestyle 50
	set key width -2
	set xrange [:$TIME]

	set key spacing 1.2
	#set nokey

	set grid xtics ytics mytics
	#set size 2
	#set size ratio 0.4

	#show timestamp
	set xlabel "Time [Seconds]"
	set ylabel "cwnd [Segments]"

	set style line 1 lc rgb "#ff0000" lt 1 pi 0 pt 4 lw 4 ps 0

	# Congestion control send window

	plot "../../data/cubic/cubic4_5.csv" using 1:7 title "cwnd", \\
     	 "../../data/cubic/cubic4_5.csv" using 1:(\$8>=2147483647 ? 0 : \$8) title "ssthresh"
EOF
sudo tc qdisc del dev $INTERFACE root
##### End of GNU Plot
  exit

fi

#########################

if [[ $1 = "4.6" ]]; 
  then
  	
	sudo modprobe -r tcp_probe
	sudo modprobe tcp_probe $PORT full=1
	sudo chmod 444 /proc/net/tcpprobe
	#sudo sysctl -w net.ipv4.route.flush=1
	cat /proc/net/tcpprobe > ../../data/cubic/cubic4_6.csv &
	TCPCAP=$!

	iperf3 -c $SERVER_ADDRESS -b 500m -p $PORT -t $TIME -i $INTERVAL -f m -C, --congestion cubic --logfile ../../data/cubic/cubic46_log.out --forceflush
	sudo tc qdisc add dev $INTERFACE root netem delay 10ms 2ms loss 2%
	sudo kill $TCPCAP

######stat of GNU Plot
	gnuplot -persist <<EOF
	set style data lines
	set terminal postscript eps enhanced color "Times" 20
	set output "../../outputs/cubic/cubic_cwnd4_6.eps"

	set title "TCP CUBIC:Bandwidth=500mbit, Delay=10ms, Jitter=2ms, Loss=2%"

	set style line 99 linetype 1 linecolor rgb "#999999" lw 2
	#set border 1 back ls 11
	set key right top
	set key box linestyle 50
	set key width -2
	set xrange [:$TIME]

	set key spacing 1.2
	#set nokey

	set grid xtics ytics mytics
	#set size 2
	#set size ratio 0.4

	#show timestamp
	set xlabel "Time [Seconds]"
	set ylabel "cwnd [Segments]"

	set style line 1 lc rgb "#ff0000" lt 1 pi 0 pt 4 lw 4 ps 0

	# Congestion control send window

	plot "../../data/cubic/cubic4_6.csv" using 1:7 title "cwnd", \\
     	# "../../data/cubic/cubic4_6.csv" using 1:(\$8>=2147483647 ? 0 : \$8) title "ssthresh"
EOF
sudo tc qdisc del dev $INTERFACE root
##### End of GNU Plot
  exit

fi

#########################

if [[ $1 = "5.1" ]]; 
  then
  	
	sudo modprobe -r tcp_probe
	sudo modprobe tcp_probe $PORT bufsize=32768 full=1
	sudo chmod 444 /proc/net/tcpprobe
	sudo sysctl -w net.ipv4.route.flush=1
	cat /proc/net/tcpprobe > ../../data/cubic/cubic5_1.csv &
	TCPCAP=$!

	iperf3 -A 0 -c $SERVER_ADDRESS -b 700m -p $PORT -t $TIME -i $INTERVAL -f m -Z --logfile ../../data/cubic/cubic51_log.out --forceflush
	sudo tc qdisc add dev $INTERFACE root netem delay 1ms 0.001ms loss 0.01%
	sudo kill $TCPCAP

######stat of GNU Plot
	gnuplot -persist <<EOF
	set style data lines
	set terminal postscript eps enhanced color "Times" 20
	set output "../../outputs/cubic/cubic_cwnd5_1.eps"

	set title "TCP CUBIC:Bandwidth=700mbit, Delay=1ms, Jitter=0.001ms, Loss=0.01%"

	set style line 99 linetype 1 linecolor rgb "#999999" lw 2
	#set border 1 back ls 11
	set key right top
	set key box linestyle 50
	set key width -2
	set xrange [:$TIME]

	set key spacing 1.2
	#set nokey

	set grid xtics ytics mytics
	#set size 2
	#set size ratio 0.4

	#show timestamp
	set xlabel "Time [Seconds]"
	set ylabel "cwnd [Segments]"

	set style line 1 lc rgb "#ff0000" lt 1 pi 0 pt 4 lw 4 ps 0

	# Congestion control send window

	plot "../../data/cubic/cubic5_1.csv" using 1:7 title "cwnd", \\
     	 "../../data/cubic/cubic5_1.csv" using 1:(\$8>=2147483647 ? 0 : \$8) title "ssthresh"
EOF
sudo tc qdisc del dev $INTERFACE root
##### End of GNU Plot
  exit

fi

#########################

if [[ $1 = "5.2" ]]; 
  then
  	
	sudo modprobe -r tcp_probe
	sudo modprobe tcp_probe $PORT bufsize=32768 full=1
	sudo chmod 444 /proc/net/tcpprobe
	sudo sysctl -w net.ipv4.route.flush=1
	cat /proc/net/tcpprobe > ../../data/cubic/cubic5_2.csv &
	TCPCAP=$!

	iperf3 -A 0 -c $SERVER_ADDRESS -b 700m -p $PORT -t $TIME -i $INTERVAL -f m -Z --logfile ../../data/cubic/cubic52_log.out --forceflush
	sudo tc qdisc add dev $INTERFACE root netem delay 2ms 0.1ms loss 0.05%
	sudo kill $TCPCAP

######stat of GNU Plot
	gnuplot -persist <<EOF
	set style data lines
	set terminal postscript eps enhanced color "Times" 20
	set output "../../outputs/cubic/cubic_cwnd5_2.eps"

	set title "TCP CUBIC:Bandwidth=700mbit, Delay=2ms, Jitter=0.1ms, Loss=0.05%"

	set style line 99 linetype 1 linecolor rgb "#999999" lw 2
	#set border 1 back ls 11
	set key right top
	set key box linestyle 50
	set key width -2
	set xrange [:$TIME]

	set key spacing 1.2
	#set nokey

	set grid xtics ytics mytics
	#set size 2
	#set size ratio 0.4

	#show timestamp
	set xlabel "Time [Seconds]"
	set ylabel "cwnd [Segments]"

	set style line 1 lc rgb "#ff0000" lt 1 pi 0 pt 4 lw 4 ps 0

	# Congestion control send window

	plot "../../data/cubic/cubic5_2.csv" using 1:7 title "cwnd", \\
     	 "../../data/cubic/cubic5_2.csv" using 1:(\$8>=2147483647 ? 0 : \$8) title "ssthresh"
EOF
sudo tc qdisc del dev $INTERFACE root
##### End of GNU Plot
  exit

fi

#########################

if [[ $1 = "5.3" ]]; 
  then
  	
	sudo modprobe -r tcp_probe
	sudo modprobe tcp_probe $PORT bufsize=32768 full=1
	sudo chmod 444 /proc/net/tcpprobe
	sudo sysctl -w net.ipv4.route.flush=1
	cat /proc/net/tcpprobe > ../../data/cubic/cubic5_3.csv &
	TCPCAP=$!

	iperf3 -A 0 -c $SERVER_ADDRESS -b 700m -p $PORT -t $TIME -i $INTERVAL -f m -Z --logfile ../../data/cubic/cubic53_log.out --forceflush
	sudo tc qdisc add dev $INTERFACE root netem delay 3ms 0.2ms loss 0.1%
	sudo kill $TCPCAP

######stat of GNU Plot
	gnuplot -persist <<EOF
	set style data lines
	set terminal postscript eps enhanced color "Times" 20
	set output "../../outputs/cubic/cubic_cwnd5_3.eps"

	set title "TCP CUBIC:Bandwidth=700mbit, Delay=3ms, Jitter=0.2ms, Loss=0.1%"

	set style line 99 linetype 1 linecolor rgb "#999999" lw 2
	#set border 1 back ls 11
	set key right top
	set key box linestyle 50
	set key width -2
	set xrange [:$TIME]

	set key spacing 1.2
	#set nokey

	set grid xtics ytics mytics
	#set size 2
	#set size ratio 0.4

	#show timestamp
	set xlabel "Time [Seconds]"
	set ylabel "cwnd [Segments]"

	set style line 1 lc rgb "#ff0000" lt 1 pi 0 pt 4 lw 4 ps 0

	# Congestion control send window

	plot "../../data/cubic/cubic5_3.csv" using 1:7 title "cwnd", \\
     	 "../../data/cubic/cubic5_3.csv" using 1:(\$8>=2147483647 ? 0 : \$8) title "ssthresh"
EOF
sudo tc qdisc del dev $INTERFACE root
##### End of GNU Plot
  exit

fi

#########################

if [[ $1 = "5.4" ]]; 
  then
  	
	sudo modprobe -r tcp_probe
	sudo modprobe tcp_probe $PORT bufsize=32768 full=1
	sudo chmod 444 /proc/net/tcpprobe
	sudo sysctl -w net.ipv4.route.flush=1
	cat /proc/net/tcpprobe > ../../data/cubic/cubic5_4.csv &
	TCPCAP=$!

	iperf3 -A 0 -c $SERVER_ADDRESS -b 700m -p $PORT -t $TIME -i $INTERVAL -f m -Z --logfile ../../data/cubic/cubic54_log.out --forceflush
	sudo tc qdisc add dev $INTERFACE root netem delay 5ms 0.5ms loss 1%
	sudo kill $TCPCAP

######stat of GNU Plot
	gnuplot -persist <<EOF
	set style data lines
	set terminal postscript eps enhanced color "Times" 20
	set output "../../outputs/cubic/cubic_cwnd5_4.eps"

	set title "TCP CUBIC:Bandwidth=700mbit, Delay=5ms, Jitter=0.5ms, Loss=1%"

	set style line 99 linetype 1 linecolor rgb "#999999" lw 2
	#set border 1 back ls 11
	set key right top
	set key box linestyle 50
	set key width -2
	set xrange [:$TIME]

	set key spacing 1.2
	#set nokey

	set grid xtics ytics mytics
	#set size 2
	#set size ratio 0.4

	#show timestamp
	set xlabel "Time [Seconds]"
	set ylabel "cwnd [Segments]"

	set style line 1 lc rgb "#ff0000" lt 1 pi 0 pt 4 lw 4 ps 0

	# Congestion control send window

	plot "../../data/cubic/cubic5_4.csv" using 1:7 title "cwnd", \\
     	 "../../data/cubic/cubic5_4.csv" using 1:(\$8>=2147483647 ? 0 : \$8) title "ssthresh"
EOF
sudo tc qdisc del dev $INTERFACE root
##### End of GNU Plot
  exit

fi

#########################

if [[ $1 = "5.5" ]]; 
  then
  	
	sudo modprobe -r tcp_probe
	sudo modprobe tcp_probe $PORT bufsize=32768 full=1
	sudo chmod 444 /proc/net/tcpprobe
	sudo sysctl -w net.ipv4.route.flush=1
	cat /proc/net/tcpprobe > ../../data/cubic/cubic5_5.csv &
	TCPCAP=$!

	iperf3 -A 0 -c $SERVER_ADDRESS -b 700m -p $PORT -t $TIME -i $INTERVAL -f m -Z --logfile ../../data/cubic/cubic55_log.out --forceflush
	sudo tc qdisc add dev $INTERFACE root netem delay 7ms 1ms loss 1.5%
	sudo kill $TCPCAP

######stat of GNU Plot
	gnuplot -persist <<EOF
	set style data lines
	set terminal postscript eps enhanced color "Times" 20
	set output "../../outputs/cubic/cubic_cwnd5_5.eps"

	set title "TCP CUBIC:Bandwidth=700mbit, Delay=7ms, Jitter=1ms, Loss=1.5%"

	set style line 99 linetype 1 linecolor rgb "#999999" lw 2
	#set border 1 back ls 11
	set key right top
	set key box linestyle 50
	set key width -2
	set xrange [:$TIME]

	set key spacing 1.2
	#set nokey

	set grid xtics ytics mytics
	#set size 2
	#set size ratio 0.4

	#show timestamp
	set xlabel "Time [Seconds]"
	set ylabel "cwnd [Segments]"

	set style line 1 lc rgb "#ff0000" lt 1 pi 0 pt 4 lw 4 ps 0

	# Congestion control send window

	plot "../../data/cubic/cubic5_5.csv" using 1:7 title "cwnd", \\
     	 "../../data/cubic/cubic5_5.csv" using 1:(\$8>=2147483647 ? 0 : \$8) title "ssthresh"
EOF
sudo tc qdisc del dev $INTERFACE root
##### End of GNU Plot
  exit

fi

#########################

if [[ $1 = "5.6" ]]; 
  then
  	
	sudo modprobe -r tcp_probe
	sudo modprobe tcp_probe $PORT bufsize=32768 full=1
	sudo chmod 444 /proc/net/tcpprobe
	sudo sysctl -w net.ipv4.route.flush=1
	cat /proc/net/tcpprobe > ../../data/cubic/cubic5_6.csv &
	TCPCAP=$!

	iperf3 -A 0 -c $SERVER_ADDRESS -b 700m -p $PORT -t $TIME -i $INTERVAL -f m -Z --logfile ../../data/cubic/cubic56_log.out --forceflush
	sudo tc qdisc add dev $INTERFACE root netem delay 10ms 2ms loss 2%
	sudo kill $TCPCAP

######stat of GNU Plot
	gnuplot -persist <<EOF
	set style data lines
	set terminal postscript eps enhanced color "Times" 20
	set output "../../outputs/cubic/cubic_cwnd5_6.eps"

	set title "TCP CUBIC:Bandwidth=700mbit, Delay=10ms, Jitter=2ms, Loss=2%"

	set style line 99 linetype 1 linecolor rgb "#999999" lw 2
	#set border 1 back ls 11
	set key right top
	set key box linestyle 50
	set key width -2
	set xrange [:$TIME]

	set key spacing 1.2
	#set nokey

	set grid xtics ytics mytics
	#set size 2
	#set size ratio 0.4

	#show timestamp
	set xlabel "Time [Seconds]"
	set ylabel "cwnd [Segments]"

	set style line 1 lc rgb "#ff0000" lt 1 pi 0 pt 4 lw 4 ps 0

	# Congestion control send window

	plot "../../data/cubic/cubic5_6.csv" using 1:7 title "cwnd", \\
     	 "../../data/cubic/cubic5_6.csv" using 1:(\$8>=2147483647 ? 0 : \$8) title "ssthresh"
EOF
sudo tc qdisc del dev $INTERFACE root
##### End of GNU Plot
  exit

fi


#########################

if [[ $1 = "6.1" ]]; 
  then
  	
	sudo modprobe -r tcp_probe
	sudo modprobe tcp_probe $PORT bufsize=32768 full=1
	sudo chmod 444 /proc/net/tcpprobe
	sudo sysctl -w net.ipv4.route.flush=1
	cat /proc/net/tcpprobe > ../../data/cubic/cubic6_1.csv &
	TCPCAP=$!

	iperf3 -A 0 -c $SERVER_ADDRESS -b 1000m -p $PORT -t $TIME -i $INTERVAL -f m -Z --logfile ../../data/cubic/cubic61_log.out --forceflush
	sudo tc qdisc add dev $INTERFACE root netem delay 1ms 0.001ms loss 0.01%
	sudo kill $TCPCAP

######stat of GNU Plot
	gnuplot -persist <<EOF
	set style data lines
	set terminal postscript eps enhanced color "Times" 20
	set output "../../outputs/cubic/cubic_cwnd6_1.eps"

	set title "TCP CUBIC:Bandwidth=1000mbit, Delay=1ms, Jitter=0.001ms, Loss=0.01%"

	set style line 99 linetype 1 linecolor rgb "#999999" lw 2
	#set border 1 back ls 11
	set key right top
	set key box linestyle 50
	set key width -2
	set xrange [:$TIME]

	set key spacing 1.2
	#set nokey

	set grid xtics ytics mytics
	#set size 2
	#set size ratio 0.4

	#show timestamp
	set xlabel "Time [Seconds]"
	set ylabel "cwnd [Segments]"

	set style line 1 lc rgb "#ff0000" lt 1 pi 0 pt 4 lw 4 ps 0

	# Congestion control send window

	plot "../../data/cubic/cubic6_1.csv" using 1:7 title "cwnd", \\
     	 "../../data/cubic/cubic6_1.csv" using 1:(\$8>=2147483647 ? 0 : \$8) title "ssthresh"
EOF
sudo tc qdisc del dev $INTERFACE root
##### End of GNU Plot
  exit

fi

#########################

if [[ $1 = "6.2" ]]; 
  then
  	
	sudo modprobe -r tcp_probe
	sudo modprobe tcp_probe $PORT bufsize=32768 full=1
	sudo chmod 444 /proc/net/tcpprobe
	sudo sysctl -w net.ipv4.route.flush=1
	cat /proc/net/tcpprobe > ../../data/cubic/cubic6_2.csv &
	TCPCAP=$!

	iperf3 -A 0 -c $SERVER_ADDRESS -b 1000m -p $PORT -t $TIME -i $INTERVAL -f m -Z --logfile ../../data/cubic/cubic62_log.out --forceflush
	sudo tc qdisc add dev $INTERFACE root netem delay 2ms 0.1ms loss 0.05%
	sudo kill $TCPCAP

######stat of GNU Plot
	gnuplot -persist <<EOF
	set style data lines
	set terminal postscript eps enhanced color "Times" 20
	set output "../../outputs/cubic/cubic_cwnd6_2.eps"

	set title "TCP CUBIC:Bandwidth=1000mbit, Delay=2ms, Jitter=0.1ms, Loss=0.05%"

	set style line 99 linetype 1 linecolor rgb "#999999" lw 2
	#set border 1 back ls 11
	set key right top
	set key box linestyle 50
	set key width -2
	set xrange [:$TIME]

	set key spacing 1.2
	#set nokey

	set grid xtics ytics mytics
	#set size 2
	#set size ratio 0.4

	#show timestamp
	set xlabel "Time [Seconds]"
	set ylabel "cwnd [Segments]"

	set style line 1 lc rgb "#ff0000" lt 1 pi 0 pt 4 lw 4 ps 0

	# Congestion control send window

	plot "../../data/cubic/cubic6_2.csv" using 1:7 title "cwnd", \\
     	 "../../data/cubic/cubic6_2.csv" using 1:(\$8>=2147483647 ? 0 : \$8) title "ssthresh"
EOF
sudo tc qdisc del dev $INTERFACE root
##### End of GNU Plot
  exit

fi

#########################

if [[ $1 = "6.3" ]]; 
  then
  	
	sudo modprobe -r tcp_probe
	sudo modprobe tcp_probe $PORT bufsize=32768 full=1
	sudo chmod 444 /proc/net/tcpprobe
	sudo sysctl -w net.ipv4.route.flush=1
	cat /proc/net/tcpprobe > ../../data/cubic/cubic6_3.csv &
	TCPCAP=$!

	iperf3 -A 0 -c $SERVER_ADDRESS -b 1000m -p $PORT -t $TIME -i $INTERVAL -f m -Z --logfile ../../data/cubic/cubic63_log.out --forceflush
	sudo tc qdisc add dev $INTERFACE root netem delay 3ms 0.2ms loss 0.1%
	sudo kill $TCPCAP

######stat of GNU Plot
	gnuplot -persist <<EOF
	set style data lines
	set terminal postscript eps enhanced color "Times" 20
	set output "../../outputs/cubic/cubic_cwnd6_3.eps"

	set title "TCP CUBIC:Bandwidth=1000mbit, Delay=3ms, Jitter=0.2ms, Loss=0.1%"

	set style line 99 linetype 1 linecolor rgb "#999999" lw 2
	#set border 1 back ls 11
	set key right top
	set key box linestyle 50
	set key width -2
	set xrange [:$TIME]

	set key spacing 1.2
	#set nokey

	set grid xtics ytics mytics
	#set size 2
	#set size ratio 0.4

	#show timestamp
	set xlabel "Time [Seconds]"
	set ylabel "cwnd [Segments]"

	set style line 1 lc rgb "#ff0000" lt 1 pi 0 pt 4 lw 4 ps 0

	# Congestion control send window

	plot "../../data/cubic/cubic6_3.csv" using 1:7 title "cwnd", \\
     	 "../../data/cubic/cubic6_3.csv" using 1:(\$8>=2147483647 ? 0 : \$8) title "ssthresh"
EOF
sudo tc qdisc del dev $INTERFACE root
##### End of GNU Plot
  exit

fi

#########################

if [[ $1 = "6.4" ]]; 
  then
  	
	sudo modprobe -r tcp_probe
	sudo modprobe tcp_probe $PORT full=1
	sudo chmod 444 /proc/net/tcpprobe
	#sudo sysctl -w net.ipv4.route.flush=1
	cat /proc/net/tcpprobe > ../../data/cubic/cubic6_4.csv &
	TCPCAP=$!

	iperf3 -A 0 -c $SERVER_ADDRESS -b 1000m -p $PORT -t $TIME -i $INTERVAL -f m -Z --logfile ../../data/cubic/cubic64_log.out --forceflush
	sudo tc qdisc add dev $INTERFACE root netem delay 5ms 0.5ms loss 1%
	sudo kill $TCPCAP

######stat of GNU Plot
	gnuplot -persist <<EOF
	set style data lines
	set terminal postscript eps enhanced color "Times" 20
	set output "../../outputs/cubic/cubic_cwnd6_4.eps"

	set title "TCP CUBIC:Bandwidth=1000mbit, Delay=5ms, Jitter=0.5ms, Loss=1%"

	set style line 99 linetype 1 linecolor rgb "#999999" lw 2
	#set border 1 back ls 11
	set key right top
	set key box linestyle 50
	set key width -2
	set xrange [:$TIME]

	set key spacing 1.2
	#set nokey

	set grid xtics ytics mytics
	#set size 2
	#set size ratio 0.4

	#show timestamp
	set xlabel "Time [Seconds]"
	set ylabel "cwnd [Segments]"

	set style line 1 lc rgb "#ff0000" lt 1 pi 0 pt 4 lw 4 ps 0

	# Congestion control send window

	plot "../../data/cubic/cubic6_4.csv" using 1:7 title "cwnd", \\
     	 "../../data/cubic/cubic6_4.csv" using 1:(\$8>=2147483647 ? 0 : \$8) title "ssthresh"
EOF
sudo tc qdisc del dev $INTERFACE root
##### End of GNU Plot
  exit

fi

#########################

if [[ $1 = "6.5" ]]; 
  then
  	
	sudo modprobe -r tcp_probe
	sudo modprobe tcp_probe $PORT full=1
	sudo chmod 444 /proc/net/tcpprobe
	#sudo sysctl -w net.ipv4.route.flush=1
	cat /proc/net/tcpprobe > ../../data/cubic/cubic6_5.csv &
	TCPCAP=$!

	iperf3 -A 0 -c $SERVER_ADDRESS -b 1000m -p $PORT -t $TIME -i $INTERVAL -f m --logfile ../../data/cubic/cubic65_log.out --forceflush
	sudo tc qdisc add dev $INTERFACE root netem delay 7ms 1ms loss 1.5%
	sudo kill $TCPCAP

######stat of GNU Plot
	gnuplot -persist <<EOF
	set style data lines
	set terminal postscript eps enhanced color "Times" 20
	set output "../../outputs/cubic/cubic_cwnd6_5.eps"

	set title "TCP CUBIC:Bandwidth=1000mbit, Delay=7ms, Jitter=1ms, Loss=1.5%"

	set style line 99 linetype 1 linecolor rgb "#999999" lw 2
	#set border 1 back ls 11
	set key right top
	set key box linestyle 50
	set key width -2
	set xrange [:$TIME]

	set key spacing 1.2
	#set nokey

	set grid xtics ytics mytics
	#set size 2
	#set size ratio 0.4

	#show timestamp
	set xlabel "Time [Seconds]"
	set ylabel "cwnd [Segments]"

	set style line 1 lc rgb "#ff0000" lt 1 pi 0 pt 4 lw 4 ps 0

	# Congestion control send window

	plot "../../data/cubic/cubic6_5.csv" using 1:7 title "cwnd", \\
     	 "../../data/cubic/cubic6_5.csv" using 1:(\$8>=2147483647 ? 0 : \$8) title "ssthresh"
EOF
sudo tc qdisc del dev $INTERFACE root
##### End of GNU Plot
  exit

fi

#########################

if [[ $1 = "6.6" ]]; 
  then
  	
	sudo modprobe -r tcp_probe
	sudo modprobe tcp_probe $PORT full=1
	sudo chmod 444 /proc/net/tcpprobe
	#sudo sysctl -w net.ipv4.route.flush=1
	cat /proc/net/tcpprobe > ../../data/cubic/cubic6_61.csv &
	TCPCAP=$!

	iperf3 -c $SERVER_ADDRESS -b 1000m -p $PORT -t $TIME -i $INTERVAL -f m --logfile ../../data/cubic/cubic66_log.out --forceflush
	sudo tc qdisc add dev $INTERFACE root netem delay 10ms 2ms loss 2%
	sudo kill $TCPCAP

######stat of GNU Plot
	gnuplot -persist <<EOF
	set style data lines
	set terminal postscript eps enhanced color "Times" 20
	set output "../../outputs/cubic/cubic_cwnd6_61.eps"

	set title "TCP CUBIC:Bandwidth=1000mbit, Delay=10ms, Jitter=2ms, Loss=2%"

	set style line 99 linetype 1 linecolor rgb "#999999" lw 2
	#set border 1 back ls 11
	set key right top
	set key box linestyle 50
	set key width -2
	set xrange [:$TIME]

	set key spacing 1.2
	#set nokey

	set grid xtics ytics mytics
	#set size 2
	#set size ratio 0.4

	#show timestamp
	set xlabel "Time [Seconds]"
	set ylabel "cwnd [Segments]"

	set style line 1 lc rgb "#ff0000" lt 1 pi 0 pt 4 lw 4 ps 0

	# Congestion control send window

	plot "../../data/cubic/cubic6_61.csv" using 1:7 title "cwnd", \\
     	# "../../data/cubic/cubic6_61.csv" using 1:(\$8>=2147483647 ? 0 : \$8) title "ssthresh"
EOF
sudo tc qdisc del dev $INTERFACE root
##### End of GNU Plot
  exit
fi
#### EOF #####