#!/bin/sh

# Random number generation

WholePageDelay () {
    rgp=`./rg -I $nextInit1 -D Weibull -O '%6.2f' -a 0.57 -b 7`
    randomWholePageDelay=`echo $rgp | awk -F' :' '{print $1}'`
    nextInit1=`echo $rgp | awk -F' :' '{print $2}'`
}

ViewingOFFtime () {
    rgp=`./rg -I $nextInit2 -D Weibull -O '%6.2f' -a 0.32 -b 0.18`
    randomViewingOFFtime=`echo $rgp | awk -F' :' '{print $1}'`
    nextInit2=`echo $rgp | awk -F' :' '{print $2}'`
}

RequestSize () {
    rgp=`./rg -I $nextInit3 -D Lognormal -O '%9.3f' -m 5.84 -s 0.09`
    randomRequestSize=`echo $rgp | awk -F' :' '{print $1}'`
    nextInit3=`echo $rgp | awk -F' :' '{print $2}'`
}

NonCachedRequest () {
    rgp=`./rg -I $nextInit4 -D Lognormal -O '%9.3f' -m 1.61 -s 1.84`
    randomNonCachedRequest=`echo $rgp | awk -F' :' '{print $1}'`
    nextInit4=`echo $rgp | awk -F' :' '{print $2}'`
}


# Initialization of rg
nextInit1=`./rg -S 0 | awk -F' :' '{print $2}'`
nextInit2=`./rg -S 0 | awk -F' :' '{print $2}'`
nextInit3=`./rg -S 0 | awk -F' :' '{print $2}'`
nextInit4=`./rg -S 0 | awk -F' :' '{print $2}'`

# Main loop
while (true); do
    # Random Data Transfer

	WholePageDelay
	ViewingOFFtime
	RequestSize
	NonCachedRequest
	delay=$(echo $randomViewingOFFtime + $randomWholePageDelay | bc)
	size=$(echo $randomRequestSize*1 | bc )
	req=$randomNonCachedRequest

    echo ""
    req=1
    echo "Transfer $size Bytes next $delay sec"
    tgParemeters=`cat <<-EOF
        on 3
        tcp 0.0.0.0.4133
        setup
        arrival constant 0 length constant $size
        packet $req data $size
EOF`

    echo "$tgParemeters" | ./tg -f | ./dcat
#    echo "$tgParemeters"

    echo ""
    echo "Sleep: $delay Seconds"
    date
    ./microsleep $delay
    date

done