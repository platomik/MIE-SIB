#!/bin/sh

# Random number generation
MainObject () {
    rgp=`./rg -I $nextInit1 -D Lognormal -O '%5.2f' -m 8.71 -s 1.14`
    randomMainObject=`echo $rgp | awk -F' :' '{print $1}'`
    nextInit1=`echo $rgp | awk -F' :' '{print $2}'`
}

ParsingTime () {
    rgp=`./rg -I $nextInit2 -D Gamma -O '%6.2f' -a 0.5 -b 3.77`
    randomParsingTime=`echo $rgp | awk -F' :' '{print $1}'`
    nextInit2=`echo $rgp | awk -F' :' '{print $2}'`
}

NumInLineObjects () {
    rgp=`./rg -I $nextInit3 -D Gamma -O '%6.2f' -a 0.6 -b 3.68`
    randomNumInLineObjects=`echo $rgp | awk -F' :' '{print $1}'`
    nextInit3=`echo $rgp | awk -F' :' '{print $2}'`
}

InlineObjSize () {
    rgp=`./rg -I $nextInit4 -D Lognormal -O '%6.2f' -m 7.56 -s 2.79`
    randomInlineObjSize=`echo $rgp | awk -F' :' '{print $1}'`
    nextInit4=`echo $rgp | awk -F' :' '{print $2}'`
}

ArrivalInLineObjects () {
    rgp=`./rg -I $nextInit5 -D Gamma -O '%6.2f' -a 0.16 -b 0.19`
    randomArrivalInLineObjects=`echo $rgp | awk -F' :' '{print $1}'`
    nextInit5=`echo $rgp | awk -F' :' '{print $2}'`
}

ViewingOFFtime () {
    rgp=`./rg -I $nextInit6 -D Weibull -O '%6.2f' -a 0.32 -b 0.18`
    randomViewingOFFtime=`echo $rgp | awk -F' :' '{print $1}'`
    nextInit6=`echo $rgp | awk -F' :' '{print $2}'`
}




# Initialization of rg
nextInit1=`./rg -S 0 | awk -F' :' '{print $2}'`
nextInit2=`./rg -S 0 | awk -F' :' '{print $2}'`
nextInit3=`./rg -S 0 | awk -F' :' '{print $2}'`
nextInit4=`./rg -S 0 | awk -F' :' '{print $2}'`
nextInit5=`./rg -S 0 | awk -F' :' '{print $2}'`
nextInit6=`./rg -S 0 | awk -F' :' '{print $2}'`

# Main loop
while (true); do

	MainObject
	ParsingTime
	NumInLineObjects
	
	############################################################
	# Send Main Object
	############################################################
    echo "Transfer Main Object $randomMainObject Bytes"
    tgParemeters=`cat <<-EOF
        on 3
        tcp 0.0.0.0.4133
        setup
        arrival constant 0 length constant $randomMainObject
        packet 1
EOF`

    echo "$tgParemeters" | ./tg -f | ./dcat

    #############################################################
	# Sleep parsing time
	#############################################################
    echo ""
    echo "Sleep parsing time: $randomParsingTime Seconds"
   ./microsleep $randomParsingTime

	#############################################################
	# Transfer some Inline objects with interarrival time
	#############################################################
	num=0

	while [ $num -lt $randomNumInLineObjects ] 
	do
		InlineObjSize
		ArrivalInLineObjects

	    tgParemeters=`cat <<-EOF
	        on 3
	        tcp 0.0.0.0.4133
	        setup
	        arrival constant 0 length constant $randomInlineObjSize
	        packet 1
EOF`

	    echo "$tgParemeters" | ./tg -f | ./dcat
	    
	    echo ""
	    echo "Sleep inline obj arrival time: $randomArrivalInLineObjects Seconds"
	   ./microsleep $randomArrivalInLineObjects

		num=`expr $num + 1`
	done
	
	#############################################################	
	#  Viewing off time
	#############################################################
	ViewingOFFtime

	echo ""
	echo "Let him read what he downloaded. Sleep viewing off time: $randomViewingOFFtime Seconds"
	./microsleep $randomArrivalInLineObjects
		
done