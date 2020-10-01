# awkmeter

Awkmeter is a simple text-based, scrolling bargraph generator based on Awk. 
Works best with text based commands that output an unending stream of text like
ping, netstat, vmstat, etc.

Auto-scales the bar heights based on terminfo (tput cols, tput rows). 
Can use either linux-flavored tput caps or BSD-flavored, see tput lines in scroll.awk

Identifies Min, Max, and Average values over the plotted area.

Examples included for ping (pingraph) and BSD-flavored netstat (graph).

Also working on a round speedometer type plot, as seen in speedo.awk
