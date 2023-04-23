#!/usr/bin/python3
import sys
import os

benchmarks = [
        ("512MB", False),
        ("1024MB", False),
        ("1536MB", False),
        ("2048MB", False),
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

def get_boost(bench_name, lower_is_better):
    laputa_avg = get_avg(bench_name, "laputa")
    kvm_avg = get_avg(bench_name, "kvm")
    if lower_is_better:
        return (kvm_avg - laputa_avg) / kvm_avg
    else:
        return (laputa_avg - kvm_avg) / kvm_avg

def output():
    with open("./data-app.dat", 'w') as fout:
        fout.write("Benchmark\t\tImprovement\n")
        for bench in benchmarks:
            boost = get_boost(bench[0], bench[1])
            print("{}\t\t{:.4f}".format(bench[0], boost))
            fout.write("{}\t\t{:.4f}\n".format(bench[0].replace("_", "\\\\\_"), boost))

output()
os.system("gnuplot ./draw-app.gp")
