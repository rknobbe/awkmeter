# plot numbers from 0..100 on a semi-circle graph
#
#  (-1,1)                   (0,1)                (1,1)
#   
#
#
# 
#    
#  (-1,0)                   (0,0)                (1,0)

# value 0 plots as a line from (-1,0) to (0,0)
# value 50 plots as a line from (0,0) to (0,1)
# value 100 plots as a line from (0,0) to (1,0)

# for each value v : { 0 <= v <= 100}
#  endpoint is (-cos(v),sin(v))

func max(x,y) {
    if (x > y)
	return x;
    return y;
}
func abs(v) {
    if (v >= 0)
	return v;
    return -v;
}

BEGIN {
    "uname -s" | getline os
    if (os == "Linux") {
	"tput lines " |  getline lines
	"tput cols"   |  getline cols
	"tput home"   | getline home
	"tput el"     | getline eraseline
	"tput ed"	  | getline eraserest
    } else { # *bsd
	"tput li " |  getline lines
	"tput co"   |  getline cols
	"tput home"   | getline home
	"tput ce"     | getline eraseline
	"tput cd"	  | getline eraserest
    }
    y_grid = 1/(lines-2)
    x_grid = 2/(cols-2)
    if (m > 0) {
	val_scale = m
    } else  {
	val_scale = 1
    }

    pi = 3.14159 
    dots= 1
    needle=1

    field = f	# change the field to $16 on the command line with -v f=16

}
	
/[0-9]/ {
    v = 100 * $f / val_scale

    if ((v >= 0) && (v <= 100)) {
	val = (v/100)  * pi;
	sinval = sin(val);
	cosval = (-cos(val));

	printf ("%s%d%s", home, $f, eraseline)
	for (y = 1; y > 0; y -= y_grid) {
	    printf("%s", eraseline);
	    scale=(sinval/y)
	    if (scale > 1) {
		for (x = -1; x <= max(cosval,0); x += x_grid) {
		    ch = " ";
		    if (dots && (abs(y-sinval) < y_grid)  && (abs(x-cosval) < x_grid)) {
			ch = "=";
		    } else if (needle) {
			y_ = y*scale
			x_ = x*scale
			if ( (abs(y_-sinval) < y_grid)  && (abs(x_-cosval) < x_grid)) {
			    ch = ".";
			}
		    }
		    printf ch;
		}
	    }
	    printf "\n";
	}

	y=0;
# at the bottom of speedo, plot base or 0 at middle
	for (x= -1; x < 1; x+= x_grid) {
	    if ((abs(y-sinval) < y_grid) && (abs(x-cosval) < x_grid)) {
		ch = "=";
	    } else {
		ch = "-";
		if (abs(x-0) < x_grid) {
		    ch = "0";
		}
	    }
	    printf ch;
	}

	printf ("%s\n", eraseline);
	printf ("%s", eraserest);
    } else {
	print $f " out of range"
    }
}
