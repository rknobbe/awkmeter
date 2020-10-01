#!/usr/bin/awk -f
# Scrolling Bar Graph
# by Roger Knobbe <rknobbe@nai.com>
# specify f=3 on the command line to parse field 3 of the input
# specify p="foo.*bar" on the command line indicate field 3 lives in lines that
#    match the pattern "foo.*bar"
# specify h="baz.*bimbo" on the command line to indicate the pattern 
#    that matches header strings in the input
# specify q=1 on the command line to supress header
# specify units=8 on the command line to display (say) bits per seconds 
#    instead of bytes per second

func min(x,y) {
    if (x < y)
	return x;
    return y;
}

BEGIN {
	log10 = log(10)
    #HEIGHT=23
    #WIDTH=70
    #"tput li" | getline rows
    #"tput co" | getline cols
    "tput lines" | getline rows
    "tput cols" | getline cols
    HEIGHT = int((7*rows/8)/10) * 10
    WIDTH=int(cols/2)
    max=0
    field=f
    system("clear")
#    print "screen is " HEIGHT "x" WIDTH
    "tput home" | getline cls
# these are for linux
    "tput el" | getline eol
    "tput bold" | getline so
    "tput rmso" | getline rmso
    "tput civis"| getline civis
    "tput ed" | getline cd

# these are for freebsd
#    "tput ce" | getline eol
#    "tput so" | getline so
#    "tput se" |getline rmso
#    "tput vi" | getline civis
#    "tput cd" | getline cd

    numeric=0
    if ("" == p)
	p = "."
    if ("" == h)
	h = "."
    if (1 == q)
	noheader = 1
    if (0 == units)
	units = 1
}

($0 ~ p) && ($field ~ /^[0-9 .]+$/) {
    numeric=1
    printf("%s%s", cls,civis )
    newval = units * $field
    if (( max < newval )) {
	max=newval
	maxline=$0
	}

    vals[WIDTH]=newval
    lines[WIDTH]=$0

    if (( max == 0 )) {
	scale=1
    } else {
	pretty_max = exp(log10 * (1+int((log(max)/log10))))

	scale_width = sprintf(":%%%d.%df", 1+log(pretty_max)/log10, 
				 (pretty_max < HEIGHT) ? 2 : 0);
	sample_width = sprintf("<-%%%d.%df", 1+log(pretty_max)/log10,
				 (pretty_max < HEIGHT) ? 2 : 0);
	sample_pad =   sprintf("  %%%d.%ds",  1+log(pretty_max)/log10 , (pretty_max < HEIGHT) ? 2 : 0);
	scale=HEIGHT/pretty_max
    }

    newmax=0
    least=max
    tot=0
    i=0

    while (( i < WIDTH ))
    {
# scroll left and scale
	vals[i]=vals[i+1]
	lines[i]=lines[i+1]
	tot += vals[i]
	dsp[i]= scale * vals[i]
	if (( vals[i] > newmax )) {
	    newmax=vals[i]
	    maxline=lines[i]
	    maxi=i
	}
	if (( vals[i] < least )) {
	    least = vals[i]
	}
#	print "i=", i, "vals[i]=", vals[i], "dsp[i]=", dsp[i]
	i=i+1
    }
    average=tot/WIDTH
    dsp_average = int(scale * average)
    dsp_max = int(scale * newmax)
    dsp_min = int(scale * least)
    dsp_current = int(scale * newval)

    y=HEIGHT
    while (( y>=0 ))
    {
        print eol
	x=0
	while (( x < WIDTH ))
	{
	    if (( dsp[x] >= y )) {
		#if ((y <= 0) && (x == maxi)){
		if ((x == maxi)){
			printf "^"
		} else  {
			printf "#"
		}	
	    } else if (y == dsp_average) {
		printf "."
	    } else {
		printf " "
	    }
	    x=x+1
	}
	printf(scale_width, y/scale)
	if (y == dsp_current) 	
	    	printf(sample_width, newval);
	    else
		printf(sample_pad, " ")
	if (y == dsp_max) 	printf(" /%g\\", newmax);
	if (y == dsp_average) 	printf(" [%g]", average);
	if (y == dsp_min) 	printf(" \\%g/", least);
	y=y-1
    }

    print eol

    $field= so $field rmso
    if (!noheader) {
	    print title,eol
	#   print $0,eol
	    #print "field", field, "value=" newval, "average=" average,eol
	printf("%s <- Max %s\n", maxline,eol)

    }
    print cd
    max=newmax
}

$0 ~ h {
    	if (numeric)
	{
	    title=""
	    numeric=0
	}
	title = title  eol  "\n" $0
}

