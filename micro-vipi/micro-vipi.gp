#!/usr/bin/gnuplot
reset
set output "../fig/micro-vipi.eps"
set terminal postscript "Helvetica,14" eps enhance dl 2 color size 2.3,1.8

#set bmargin 3
#set lmargin 1

set pointsize 1
set size 1,1

load '../line-style.plt'

##
unset key
set key inside top right Right invert enhanced autotitles columnhead nobox
set key samplen 0.5 spacing 1 width 0.5 height 0.2 font ",17"
#set key at 0.3,12.2
#set key vertical maxrows 2
##

#set ylabel "Breakdown of vIPI Handling" font ",15" offset -1,0
set xlabel font ",15" offset 0,-0.6

set yrange [0:6000]
set ytics 1000 font ",20"
#set ytics ('10000' 4, '1000' 3, '100' 2, '10' 1, '5000' 3.69897, '500' 2.69897, '50' 1.69897)
#set ytics ('10000' 4, '1000' 3, '100' 2, '10' 1) font ",20"

set xtics font ",14" rotate by 0 offset 0,0
set xlabel "(d) Virtual IPI" font ",20"

set grid ytics lw 2

set style data histograms 
set style histogram rowstacked gap 1.2 
set style fill pattern border -1 
set boxwidth 0.3

#set style line 2 lc rgb "#0000ee" lt 3 lw 4 pt 5 ps 1.5 pi -1  ## solid box
#set style line 3 lc rgb "#c00000" lt 3 lw 4 pt 5 ps 1.5 pi -1  ## solid box
#set style line 4 lc rgb "#6600cc" lt 3 lw 4 pt 5 ps 1.5 pi -1  ## solid box
#set style line 5 lc rgb "#000000" lt 3 lw 4 pt 5 ps 1.5 pi -1  ## solid box

# set label "4692" at  -0.35,5170 front rotate by 0 font ",20"
# set label "147"  at  0.72,485 front rotate by 0 font ",20"
# set label "147"  at  1.72,485 front rotate by 0 font ",20"

#set label "4931" at  -0.4,3.95 front rotate by 0 font ",20"
#set label "147" at  0.7,2.5 front rotate by 0 font ",20"
#set label "147" at  1.7,2.5 front rotate by 0 font ",20"
#set label "log_1_0" at  -1.8,0 front rotate by 0 font ",20"

# log_10(4931) -  log_10(1073)
plot "micro-vipi.res" using 2:xtic(1)         \
         t "Exit"    fs pattern 3 ls 1 lc rgb '#999999' lw 2, \
         "micro-vipi.res" using 3         \
        t "vIPI Insert" fs pattern 3 ls 1 lc rgb '#FFBE7A' lw 2,
