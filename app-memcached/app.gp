#!/usr/bin/gnuplot
reset
set output "../fig/app-memcached.eps"
set terminal postscript "Helvetica" eps enhance dl 2 color size 3.2,2.5
set pointsize 1

set tmargin 1
set bmargin -3
########set lmargin 15

load '../line-style.plt'

unset key
#set key inside top right Right enhanced autotitles columnhead nobox horizontal
#set key samplen 0.5 spacing 1 width 0.5 height 0.2 font ",25"

#set xlabel "(c) Memcached" font ",30" offset 0, -2
set xlabel " " font ",30" offset 0, -3.2
set label "(c) Memcached" at  -0.2,-0.40 front rotate by 0 font ",30"

#set ylabel "Performance Overhead" offset -6,-1 font ",28"
#set xlabel font ",20" # offset 0,-1

#set yrange[0:6.5]
set yrange[0:1.4]
set ytics font ",27" 0,0.2,1.6
set xtics font ",26" rotate by 0 offset 0,-0.5
#set xtics  norangelimit 

set style histogram cluster gap 1.5 title textcolor lt -1
set style histogram errorbars lw 4
set style data histograms
set style fill solid border -1

set ytics ('0%%' 0.0, '20%%' 0.2, '40%%' 0.4, '60%%' 0.6, '80%%' 0.8, '100%%' 1.0, '120%%' 1.2, '140%%' 1.4, '160%%' 1.6, '180%%' 1.8, '200%%' 2.0)
set label "vCPU(s)" at  2.3,-0.15 front rotate by 0 font ",23"

set boxwidth 1

set grid ytics lw 2

plot newhistogram "",\
     'app.res'   u 2:3:xtic(1)  ti col lc rgb '#ffbe7a' lw 4, \
     'app.res'   u 4:5:xtic(1)  ti col lc rgb '#707070' lw 4,

# #F7FBFF #9ECAE1
# yellow ffbe7a grey 707070 from DV-micro
# grey & black 515151 000000 from KVM/ARM
# grey 515151 707070 from Zeph
# blue 4c77b3 orange e07f1b green 64a034 red b52828 purple 8968bb from dorylus

