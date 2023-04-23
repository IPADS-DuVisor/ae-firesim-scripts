#!/bin/sh

gnuplot app.gp

cd ../app-memcached
gnuplot app.gp

cd ../app-untar
gnuplot app.gp

cd ../app-netperf
gnuplot app.gp

cd ../app-iperf
gnuplot app.gp
