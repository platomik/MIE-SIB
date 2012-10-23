# MIE-SIB. Homework #1. 

### Theoretical overview

###### TCP/SYN Packet (TCP/SYN Flood)

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