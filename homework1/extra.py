#! /usr/bin/env python

import sys
import time
import math
from scapy.all import *

lmbd = math.fabs(float(sys.argv[1]))
print "Labmda =",lmbd

while True:
        send(IP(src=RandIP('10.0.0.0/8'), dst='172.16.16.16')/TCP(sport=RandShort(), dport=80))
        delay=random.expovariate(lmbd)
        print "Next packet in", delay, "seconds" 
        time.sleep(delay)
