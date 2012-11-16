# MIE-SIB. Homework #1. 

### 1. Use tcpdump for analyzing sending time of packets. Calculate the time between packets and compare it with the settings of `tg` traffic generator.

1. Perform traffic sending/receiving using two scripts mentioned in the task description.

2. Run `tcpdump` for the traffic monitoring. Some paremeters should be specified. 
	
	-i lo - catch packets on local interface (server generates traffic for localhost and client detects traffic on localhost as well)
	
	-tt - convert time format to float numbers
	
	dst port 4133 - dump only packets from server to client
	
	-l do not use buffer 
	
Output of `tcpdump` is sending to the pattern scanning language `mawk` (awk analog). Where it is processed - interval between packets and average value of it are calculated

	tcpdump -tt -l -i lo dst port 4133 | mawk -Winteractive 'count {diff=$1-prev; 
		sum+=diff; print count". "$1"-"prev"="$1-prev" avg="sum/count}; {prev=$1; count++}'

3. Results are shown in Figure.

![Time intervals](https://github.com/platomik/MIE-SIB/raw/master/homework2/timeintervals.jpg)