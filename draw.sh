#!/bin/bash

for i in netperf iperf3 memcached hackbench prime;
do
    pushd app-$i
    gnuplot app.gp
    popd
done

for i in hypercall s2pf mmio vplic vipi
do
    pushd micro-$i
    gnuplot micro-$i.gp
    popd
done

# fig9
pushd dvext-impact
gnuplot draw-impact.gp
popd

# fig10
pushd scale-mem
python app.py
popd

# fig10b
pushd vpmp
gnuplot vpmp.gp
popd
