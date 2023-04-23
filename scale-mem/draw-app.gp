#!/usr/bin/gnuplot
reset
set output "../fig/scale-mem.eps"
set terminal postscript "Helvetica,15" eps enhance dl 2 color size 1.6,1.3
set pointsize 1

#set tmargin 7
set bmargin -3
#set lmargin 15

##
unset key
set key off 
#set key outside right Left reverse enhanced autotitles columnhead nobox
#set key above
#set key at 0.3,12.2
#set key vertical maxrows 2
#set key samplen 2 spacing 1.4 height 0.5
#unset key
##

set ylabel "Performance Improvement" font ",12"
set xlabel "(a) Memory Sizes" font ",15"

set yrange[0:0.05]
set ytics ("0" 0, "0.1%%" 0.01, "0.2%%" 0.02, "0.3%%" 0.03, "0.4%%" 0.04, "0.5%%" 0.05) offset 0,0
#set ytics 0.05 offset -1,0
#set format '%g %%'
#set offset -0.4,-0.4,0,0
#set xtics rotate by 30 offset -3.2,-1.8
set xtics font ",13" rotate by -30 offset 0,0
set grid ytics lw 2



set style histogram cluster gap 1 title textcolor lt -1 
set style data histograms
set style fill solid border -1
set boxwidth 0.8



plot newhistogram "",\
     './data-app.dat'   u 2:xtic(1)  ti col lc rgb '#FFBE7A' lw 2

