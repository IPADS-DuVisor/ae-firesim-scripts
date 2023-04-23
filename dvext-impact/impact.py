#!/usr/bin/python3
import sys
import os

benchmarks = [
        ("Netperf", False),
        ("iperf3", False),
        ("Memcached", False),
        ("Hackbench", True),
        ("Untar", True),
        ]

#def avg_tps(bench_name, suffixlower_is_better):

def get_avg(bench_name, suffix):
    avg = 0.0
    filename = bench_name + "." + suffix
    with open(filename, 'r') as fin:
        total = 0.0
        num = 0
        for line in fin:
            total += float(line)
            num += 1
        avg = total / num
    return avg

def get_overhead(bench_name, lower_is_better):
    laputa_avg = get_avg(bench_name, "dvext")
    kvm_avg = get_avg(bench_name, "vanilla")
    if lower_is_better:
        return (laputa_avg - kvm_avg) / kvm_avg
    else:
        return (kvm_avg - laputa_avg) / kvm_avg

def output():
    with open("./data-impact.dat", 'w') as fout:
        #fout.write("Benchmark\t\t1-vCPU\t\t2-vCPU\t\t4-vCPU\n")
        print("Benchmark\t\t1-vCPU\t\t2-vCPU\t\t4-vCPU")
        fout.write("Benchmark\t\t1-vCPU\t\t2-vCPU\t\t4-vCPU\n")
        for bench in benchmarks:
            o1 = get_overhead("./raw/" + bench[0] + "-1", bench[1])
            o2 = get_overhead("./raw/" + bench[0] + "-2", bench[1])
            o4 = get_overhead("./raw/" + bench[0] + "-4", bench[1])
            #fout.write("{}\t\t{:.4f}\n".format(bench[0].replace("_", "\\\\\_"), o1))
            print("{}\t\t{:.4f}\t\t{:.4f}\t\t{:.4f}".format(bench[0], o1, o2, o4))
            fout.write("{}\t\t{:.4f}\t\t{:.4f}\t\t{:.4f}\n".format(bench[0], o1, o2, o4))

output()
#os.system("gnuplot ./draw-lmbench.gp")
#os.system("cp ./fig-lmbench.eps ../hist-virt-lmbench.eps")
