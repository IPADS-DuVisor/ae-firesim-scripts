#!/usr/bin/gnuplot
reset
set output "../fig/vpmp.eps"
set terminal postscript "Helvetica" eps enhance dl 2 color size 4.5,2.6
set pointsize 1

set tmargin 1
set bmargin -3
set lmargin 10

load 'line-style.plt'

##
#unset key
#set key outside Right enhanced autotitles columnhead nobox font ",18"
#set key above
#set key at 0.3,1680

unset key
set key inside top right Right enhanced autotitles columnhead nobox
set key samplen 0.5 spacing 1 width 0.5 height 0.2 font ",30"

set xlabel "(b) Memory Bandwidth" font ",32" offset -1,-1

#unset key
#set key inside top right Right invert enhanced autotitles columnhead nobox
#set key samplen 0.5 spacing 1 width 0.5 height 0.2 font ",25"

#set key center tmargin
#set key vertical maxrows 2
#set key samplen 3 spacing 1  height 0.5
#unset key
##
#set xlabel " " font ",30" offset 0, -0.5

set ylabel "Memory Bandwidth (GB/s)" offset -1,-1 font ",28"
#set xlabel font ",20" # offset 0,-1

set yrange[0:18]    
#set xrange[0:180]    
set ytics font ",25" 0,2,18
set xtics font ",25" 0,9,18 rotate by -20 offset -1.5,0
#set xtics  norangelimit 

set style histogram cluster gap 1.5 title textcolor lt -1
set style data histograms
set style fill solid border -1

#set ytics ('0%%' 0.0, '20%%' 0.2, '40%%' 0.4, '60%%' 0.6, '80%%' 0.8, '100%%' 1.0, '120%%' 1.2, '140%%' 1.4, '160%%' 1.6)

set boxwidth 1

set grid ytics lw 2

plot newhistogram "",\
     'vpmp.res'   u 2:xtic(1)  ti col lc rgb '#ffbe7a' lw 4, \
     'vpmp.res'   u 3:xtic(1)  ti col lc rgb '#707070' lw 4,

# #F7FBFF #9ECAE1
# yellow ffbe7a grey 707070 from DV-micro
# grey & black 515151 000000 from KVM/ARM
# grey 515151 707070 from Zeph
# blue 4c77b3 orange e07f1b green 64a034 red b52828 purple 8968bb from dorylus

