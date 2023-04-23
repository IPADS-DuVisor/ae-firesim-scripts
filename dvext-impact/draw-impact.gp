#!/usr/bin/gnuplot
reset
set output "../fig/fig-impact.eps"
set terminal postscript "Helvetica" eps enhance dl 2 color size 3,1.2
set pointsize 1

#set tmargin 7
#set bmargin 3
#set lmargin 15
set rmargin 3

load './line-style.plt'

unset key
#set key off 
set key outside center top reverse enhanced autotitles columnhead
set key nobox font ",14"
#set key above
#set key at 0.3,12.2
#set key vertical maxrows 2
set key horizontal maxcolumns 3 maxrows 1
set key samplen 2 spacing 1.4 height 0.5

set ylabel "Overhead" offset 0,0 font ",14"
set xlabel font ",16" offset 0,0


set yrange[-0.08:0.08]
set ytics 0.1 font ",12"
set ytics ('-10%%' -0.1, '-8%%' -0.08, '-6%%' -0.06, '-4%%' -0.04, '-2%%' -0.02, '0%%' 0.0, '2%%' 0.02, '4%%' 0.04, '6%%' 0.06, '8%%' 0.08, '10%%' 0.1)
#set format '%g %%'

set xtics font ",15" offset 0,-0.1
#set xtics norangelimit
#set offset -0.4,-0.4,0,0
set xtics rotate by -15 offset -2,0
set grid ytics lw 2



set style histogram cluster gap 2 title textcolor lt -1
set style histogram errorbars lw 2
set style data histograms
set style fill solid border -1
set boxwidth 0.85



plot newhistogram "",\
     './data-impact.dat'   u 2:3:xtic(1)  ti col ls 2 lw 2, \
     './data-impact.dat'   u 4:5:xtic(1)  ti col ls 3 lw 2, \
     './data-impact.dat'   u 6:7:xtic(1)  ti col ls 4 lw 2
#     './data-impact.dat'   u 2:xtic(1)  ti col lc rgb '#ffbe7a' lw 4, \
#     './data-impact.dat'   u 3:xtic(1)  ti col lc rgb '#707070' lw 4, \
#     './data-impact.dat'   u 4:xtic(1)  ti col lc rgb '#F50033' lw 4

