# MIE-SIB. Homework #1. 

### 1. Use tcpdump for analyzing sending time of packets. Calculate the time between packets and compare it with the settings of `tg` traffic generator.

 **1.** Perform traffic sending/receiving using two scripts mentioned in the task description.

 **2.** Run `tcpdump` for the traffic monitoring. Some paremeters should be specified. 
	
   **-i lo** - catch packets on local interface (server generates traffic for localhost and client detects traffic on localhost as well)
	
   **-tt** - convert time format to float numbers
	
   **dst port 4133** - dump only packets from server to client
	
   **-l** do not use buffer 
	
Output of `tcpdump` is sending to the pattern scanning language `mawk` (awk analog). Where it is processed - interval between packets and average value of it are calculated

	tcpdump -tt -l -i lo dst port 4133 | mawk -Winteractive 'count {diff=$1-prev; sum+=diff; 
		print count". diff="$1-prev" avg="sum/count}; {prev=$1; count++}'

**3.** Results are shown in Figure.

![Time intervals](https://github.com/platomik/MIE-SIB/raw/master/homework2/timeintervals.jpg)

350 packets were captured and analyzed. **Grey bars** are time interval between current and previos packet. **Red line** is a value from settings of traffic generator. *Blue curve* - average value of time intervals amoung measurement. 

As we can see the blue curve converges to the red line.

### 2. Use tcpdump for traffic dumping. Calculate the size of packets and compare it with the setting of `tg` traffic generator.

 **1.** Perform traffic sending/receiving using two scripts mentioned in the task description.

 **2.** Run `tcpdump` for the traffic monitoring. Some paremeters should be specified. 

   **-i lo** - catch packets on local interface (server generates traffic for localhost and client detects traffic on localhost as well)
	
   **dst port 4133** - dump only packets from server to client
	
   **-l** do not use buffer 
	
Output of `tcpdump` is sending to the pattern scanning language `mawk` (awk analog). Where it is processed - packet length and average value of it are calculated

	tcpdump -l -i lo dst port 4133 | mawk -Winteractive 'count {sum+=$21; 
		print count". length="$21" avg="sum/count}; {count++}'

**3.** Results are shown in Figure.

![Packet length](https://github.com/platomik/MIE-SIB/raw/master/homework2/packetlength.jpg)

500 packets were captured and analyzed. **Grey bars** are size of packets. **Red line** is a value from settings of traffic generator. *Blue curve* - average packets size values. 

### 3. Develop program for a web traffic generation.

From the article *Hyoung-Kee Choi, John O. Limb, A Behavioral Model of Web Traffic"* we have the parameters and their expected distributions used to model the Web traffic.

![Parameters](https://github.com/platomik/MIE-SIB/raw/master/homework2/parameters.jpg)

Some clarifications on table with parameters:

*Object size* - the size of objects (main and in-line) stored on the remote server.

*Request size* - the size of HTTP header sent when requesting URI

*Number of in-line objects* - the number of embedded objects in a page in which requests are made

*Viewing (off) time* - use thinking time

*Number of (non)-cached pages* - the number of consecutive pages that are (not) locally cached in the browser

*Parsing time* - the time for a browser to parse the HTML code

*In-line interarrival time* - interarrival time between starts of in-line objects.

*Whole page delay* - the time to download a page.

In order to use it with utilities `tg` and `rg` we have to make small transformation of it. 

For Gamma distribution we should use parameters α and β. It could be easily derived from mean and standard deviation.

Since, 

	Mean = α/β
	S.D. = sqrt(α/β)

we get

	α = (Mean)^2 / (S.D.)^2
	β = (Mean)  / (S.D.)^2

For Weibull Distribution we should use parameters α and β. 

	Median = β * (ln(2))^(1/α)
	Mean = β * ( Г(1+1/α)) 

And the final form for parametrs table is :

	Request size has `Lognormal distribution` with parameters μ=360.4 and σ2=11346.5
	Object size (main) has `Lognormal distribution` with parameters μ=10709.8 and σ2=626606030.4
	Object size (in-line) has `Lognormal distribution` with parameters μ=7757.74 and σ2=15918364224
	Parising time has `Gamma distribution` with parameters α=0.5 and β=3.77
	Number of in-line objects has `Gamma distribution` with parameters α=0.24 and β=0.04
	In-line inter-arrival time has `Gamma distribution` with parameters α=0.16 and β=0.19
	Whole page delay has `Weibull Distribution` with parameters α=0.57 and β=7
	Viewing (OFF) time has `Weibull Distribution` with parameters α=0.32 and β=0.18
	Number of non-cached Web-requests has `Lognormal distribution` with parameters μ=12.6 and σ2=466.56
	Number of cached Web-requests has `Geometric distribution` with paramter p=0.57

#### Simulation

Web traffic generation model consists of two parts - outgoing traffic (requests from clients to servers) and incoming traffic (answer from servers to clients).

###### Requesting URIs

We need to use the following paramers from the table:

**Request size** as length of packets, **Whole page delay** plus **Viewing (OFF) time** as interrequesting time and **Number of Pages** as number of concurrent requests at the moment.

Process can be represented schematically:

![Request](https://github.com/platomik/MIE-SIB/raw/master/homework2/req.jpg)
