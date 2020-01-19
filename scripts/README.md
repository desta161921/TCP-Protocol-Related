## Helper

### The default algorithm employed by the system with command 


	desta@server:~ $cat /proc/sys/net/ipv4/tcp_congestion_control

	desta@client:~ $ sysctl net.ipv4.tcp_congestion_control
	net.ipv4.tcp_congestion_control = vegas

Remark: Note that if some of the default TCP congestion control algorithms (cubic and/or Reno are not listed when we do **_sysctl net.ipv4.tcp_available_congestion_control_**, since most linux distributions include them as loadable kernel modules, we can try the following:



	/sbin/modprobe tcp_reno
	/sbin/modprobe tcp_cubic

### To change the default algorithm to cubic. 


	desta@server:~ $ sudo sysctl -w net.ipv4.tcp_congestion_control=cubic  ### remember that this is not reboot resistant.

Create a file (**_/etc/sysctl.d/tcp-allowed-algorithm.conf_**) - to make permanent changes after reboot

	net.ipv4.tcp_congestion_control=cubic

### TCP Congestion control algorithms supported by the running machine (linux) --- modules implementing TCP

	desta@server:~ $ cat /boot/config-4.4.0-42-generic | grep CONFIG_TCP_CONG
	CONFIG_TCP_CONG_ADVANCED=y
	CONFIG_TCP_CONG_BIC=m
	CONFIG_TCP_CONG_CUBIC=y
	CONFIG_TCP_CONG_WESTWOOD=m
	CONFIG_TCP_CONG_HTCP=m
	CONFIG_TCP_CONG_HSTCP=m
	CONFIG_TCP_CONG_HYBLA=m
	CONFIG_TCP_CONG_VEGAS=m
	CONFIG_TCP_CONG_SCALABLE=m
	CONFIG_TCP_CONG_LP=m
	CONFIG_TCP_CONG_VENO=m
	CONFIG_TCP_CONG_YEAH=m
	CONFIG_TCP_CONG_ILLINOIS=m
	CONFIG_TCP_CONG_DCTCP=m
	CONFIG_TCP_CONG_CDG=m


	desta@server:~ $ ls /lib/modules/4.4.0-42-generic/kernel/net/ipv4 | grep "tcp*"
	tcp_bic.ko
	tcp_cdg.ko
	tcp_dctcp.ko
	tcp_diag.ko
	tcp_highspeed.ko
	tcp_htcp.ko
	tcp_hybla.ko
	tcp_illinois.ko
	tcp_lp.ko
	tcp_probe.ko
	tcp_scalable.ko
	tcp_vegas.ko
	tcp_veno.ko
	tcp_westwood.ko
	tcp_yeah.ko




### Steps to reproduce:

	1. sudo modprobe tcp_westwood
	2. sudo modprobe tcp_bic
	3. sudo modprobe tcp_htcp
	4. sudo modprobe tcp_hybla
	5. sudo modprobe tcp_vegas
	6. sudo modprobe tcp_scalable
	7. sudo modprobe tcp_lp
	8. sudo modprobe tcp_veno
	9. sudo modprobe tcp_yeah
	10. sudo modprobe tcp_illinois




	desta@server:~ $ sudo modprobe tcp_westwood
	desta@server:~ $ echo $?
	0


Modules implementing the TCP congestion control algorithms:

	desta@server:~ $ grep CONFIG_TCP_CONG /boot/config-3.8.1-201.fc18.x86_64 
	CONFIG_TCP_CONG_ADVANCED=y
	CONFIG_TCP_CONG_BIC=m
	CONFIG_TCP_CONG_CUBIC=y
	CONFIG_TCP_CONG_WESTWOOD=m
	CONFIG_TCP_CONG_HTCP=m
	CONFIG_TCP_CONG_HSTCP=m
	CONFIG_TCP_CONG_HYBLA=m
	CONFIG_TCP_CONG_VEGAS=m
	CONFIG_TCP_CONG_SCALABLE=m
	CONFIG_TCP_CONG_LP=m
	CONFIG_TCP_CONG_VENO=m
	CONFIG_TCP_CONG_YEAH=m
	CONFIG_TCP_CONG_ILLINOIS=m

So any of these should work

	desta@server:~ $ for m in tcp_bic tcp_westwood tcp_htcp tcp_hybla tcp_vegas tcp_scalable tcp_lp tcp_veno tcp_yeah tcp_illinois; do sudo modprobe $m; done
	modprobe: FATAL: Module tcp_bic not found.
	modprobe: FATAL: Module tcp_westwood not found.
	modprobe: FATAL: Module tcp_htcp not found.
	modprobe: FATAL: Module tcp_hybla not found.
	modprobe: FATAL: Module tcp_vegas not found.
	modprobe: FATAL: Module tcp_scalable not found.
	modprobe: FATAL: Module tcp_lp not found.
	modprobe: FATAL: Module tcp_veno not found.
	modprobe: FATAL: Module tcp_yeah not found.
	modprobe: FATAL: Module tcp_illinois not found.

List of TCP congestion control modules:

	desta@server:~ $ ls /lib/modules/3.8.1-201.fc18.x86_64/kernel/net/ipv4/tcp_*
	/lib/modules/3.8.1-201.fc18.x86_64/kernel/net/ipv4/tcp_diag.ko


Another Linux Distribution

	desta@server:~ $ grep CONFIG_TCP_CONG /boot/config-3.5.0-25-generic 

	CONFIG_TCP_CONG_ADVANCED=y
	CONFIG_TCP_CONG_BIC=m
	CONFIG_TCP_CONG_CUBIC=y
	CONFIG_TCP_CONG_WESTWOOD=m
	CONFIG_TCP_CONG_HTCP=m
	CONFIG_TCP_CONG_HSTCP=m
	CONFIG_TCP_CONG_HYBLA=m
	CONFIG_TCP_CONG_VEGAS=m
	CONFIG_TCP_CONG_SCALABLE=m
	CONFIG_TCP_CONG_LP=m
	CONFIG_TCP_CONG_VENO=m
	CONFIG_TCP_CONG_YEAH=m
	CONFIG_TCP_CONG_ILLINOIS=m

	desta@server:~ $ for m in tcp_bic tcp_westwood tcp_htcp tcp_hybla tcp_vegas tcp_scalable tcp_lp tcp_veno tcp_yeah tcp_illinois; do sudo modprobe $m; done

	desta@server:~ $ lsmod | grep tcp_

	tcp_illinois           12838  0 
	tcp_yeah               12563  0 
	tcp_veno               12630  0 
	tcp_lp                 12519  0 
	tcp_scalable           12513  0 
	tcp_vegas              13559  1 tcp_yeah
	tcp_hybla              12628  0 
	tcp_htcp               12863  0 
	tcp_westwood           12656  0
	tcp_bic                13251  0

	desta@server:~ $ ls /lib/modules/3.5.0-25-generic/kernel/net/ipv4/tcp_*

	/lib/modules/3.5.0-25-generic/kernel/net/ipv4/tcp_bic.ko
	/lib/modules/3.5.0-25-generic/kernel/net/ipv4/tcp_diag.ko
	/lib/modules/3.5.0-25-generic/kernel/net/ipv4/tcp_highspeed.ko
	/lib/modules/3.5.0-25-generic/kernel/net/ipv4/tcp_htcp.ko
	/lib/modules/3.5.0-25-generic/kernel/net/ipv4/tcp_hybla.ko
	/lib/modules/3.5.0-25-generic/kernel/net/ipv4/tcp_illinois.ko
	/lib/modules/3.5.0-25-generic/kernel/net/ipv4/tcp_lp.ko
	/lib/modules/3.5.0-25-generic/kernel/net/ipv4/tcp_probe.ko
	/lib/modules/3.5.0-25-generic/kernel/net/ipv4/tcp_scalable.ko
	/lib/modules/3.5.0-25-generic/kernel/net/ipv4/tcp_vegas.ko
	/lib/modules/3.5.0-25-generic/kernel/net/ipv4/tcp_veno.ko
	/lib/modules/3.5.0-25-generic/kernel/net/ipv4/tcp_westwood.ko
	/lib/modules/3.5.0-25-generic/kernel/net/ipv4/tcp_yeah.ko

### Replace space by comma

	desta@server:~ $ sed -i 's/\s/,/g' *

### Delete some columns

	desta@server:~ $ cut -d, -f2-6,8-11 --complement cubic_sender.csv > cubic_sender_final.csv

### tcp-dump

	desta@server:~ $ sudo tcpdump -i enp0s8 -s 512 -B 32768 -U -p tcp port 5201 -w capture_traffic.pcap 

### To grp congestion control from iperf3

	desta@server:~ $ sudo tcpdump -nli enp0s8  '(port 5201) and (length > 74)' -s 0 -w - | strings
	desta@server:~ $ sudo tcpdump -nli enp0s8  '(tcp port 5201) and (length > 74)' -s 1024 -w monitor_traffic.pcap | strings

### Printing relative time of each frame with the ACK_RTT as columns, e.g.

	desta@server:~ $ tshark -r "cubic42.pcap" -Tfields -e frame.time_relative -e tcp.analysis.ack_rtt
	desta@server:~ $ tshark -r ../data/desta_estimate.pcapng -Y 'ip.addr==10.0.12.12' -T fields -e tcp.analysis.ack_rtt >> ../data/desta-rtt.txt #calculate sample RTT from the command line 


### Show only the columns with values - RTT

	desta@server:~ $ grep -E '^[^\s]+\s+[^\s]+$' smaple_rtt.csv


### Google Cloud compute
	desta@server:~ $ gcloud compute ssh tcp-experiment-desta --zone us-east1-b

### TCP probe

The <a href="https://elixir.bootlin.com/linux/v4.14/source/net/ipv4/tcp_probe.c">TCP Probe </a> kernel module from Linux kernel 3.0.0-17 contains the following fields:

	[ 1] Timestamp
	[ 2] Source address:port
	[ 3] Destination address:port
	[ 4] Packet length
	[ 5] snd_nxt
	[ 6] snd_una
	[ 7] snd_cwnd
	[ 8] ssthresh
	[ 9] snd_wnd
	[10] srtt
	[11] tcp_ca_state



