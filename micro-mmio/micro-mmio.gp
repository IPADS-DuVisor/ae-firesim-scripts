#!/usr/bin/gnuplot
reset
set output "../fig/micro-mmio.eps"
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

#set ylabel "Breakdown of Mmio Handling" font ",15" offset -1,0
set xlabel font ",15" offset 0,-0.6

set yrange [0:8000]
set ytics 1000 font ",20"

set xtics font ",18" rotate by 0 offset 0,0
set xlabel "(c) MMIO" font ",18"

set grid ytics lw 2

set style data histograms 
set style histogram rowstacked gap 1.2 
set style fill pattern border -1 
set boxwidth 0.3

#set style line 2 lc rgb "#0000ee" lt 3 lw 4 pt 5 ps 1.5 pi -1  ## solid box
#set style line 3 lc rgb "#c00000" lt 3 lw 4 pt 5 ps 1.5 pi -1  ## solid box
#set style line 4 lc rgb "#6600cc" lt 3 lw 4 pt 5 ps 1.5 pi -1  ## solid box
#set style line 5 lc rgb "#000000" lt 3 lw 4 pt 5 ps 1.5 pi -1  ## solid box

# set label "4758" at  -0.27,5200 front rotate by 0 font ",20"
# set label "494" at  0.8,850 front rotate by 0 font ",20"

plot "micro-mmio.res" using 2:xtic(1)         \
         t "Entry/Exit"    fs pattern 3 ls 1 lc rgb '#999999' lw 2,\
     "micro-mmio.res" using 3         \
     t "Transfer" fs pattern 3 ls 1 lc rgb '#FFBE7A' lw 2,\
     "micro-mmio.res" using 4         \
     t "Decode"  fs pattern 3 ls 1 lc rgb '#8ECFC9' lw 2, \
     "micro-mmio.res" using 5         \
     t "Other"  fs pattern 3 ls 1 lc rgb '#4575B4' lw 2
