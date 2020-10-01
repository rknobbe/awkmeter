# awkmeter

Awkmeter is a simple text-based, scrolling bargraph generator based on Awk. 
Works best with text based commands that output an unending stream of text like
ping, BSD-flavor netstat, vmstat, etc.

Auto-scales the bar heights based on terminfo (tput cols, tput rows). 
Can use either linux-flavored tput caps or BSD-flavored, see tput lines in scroll.awk

Identifies Min, Max, and Average values over the plotted area.

From scroll.awk:

````
    specify f=3 on the command line to parse field 3 of the input
    specify p="foo.*bar" on the command line indicate field 3 lives in lines that
       match the pattern "foo.*bar"
    specify h="baz.*bimbo" on the command line to indicate the pattern 
       that matches header strings in the input
    specify q=1 on the command line to supress header
    specify units=8 on the command line to display (say) bits per seconds 
       instead of bytes per second
````

Examples included for ping (pingraph) and BSD-flavored netstat (graph).

![Alt text](pingraph.png?raw=true "pingraph running on linux")

![Alt text](idlegraph.PNG?raw=true "idlegraph running on linux")

Also working on a round speedometer type plot, as seen in speedo.awk

