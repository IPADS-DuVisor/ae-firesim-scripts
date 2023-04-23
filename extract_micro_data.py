#!/usr/bin/python3
import sys
import re
import os
import pandas
import numpy as np
import var
from colorama import Fore, Style

g_var = var.micro_var()

def element(arr, index):
    return arr[index] if index < len(arr) else None

def proc_hypercall(role, primitive, fin):
    ok = False
    for line in fin:
        arr = [x for x in re.sub('\s+', ' ', line).split(' ') if x]
        diff = 2 if role == "duvisor" else 0
        if "SBI_TEST_TIMING_END" in line:
            ok = True
        if not ok and role == "kvm":
            continue
        if (element(arr, 2 - diff) == "0"):
            g_var.micro_primitive["%s-%s-Exit" % (role, primitive)] = int(arr[3 - diff])
        elif (element(arr, 2 - diff) == "1"):
            g_var.micro_primitive["%s-%s-Handling" % (role, primitive)] = int(arr[3 - diff])
        elif (element(arr, 2 - diff) == "2"):
            g_var.micro_primitive["%s-%s-Entry" % (role, primitive)] = int(arr[3 - diff])

def proc_s2pf(role, primitive, fin):
    ok = False
    for line in fin:
        arr = [x for x in re.sub('\s+', ' ', line).split(' ') if x]
        diff = 2 if role == "duvisor" else 0
        if "SBI_TEST_TIMING_END" in line:
            ok = True
        if not ok and role == "kvm":
            continue
        if (element(arr, 2 - diff) == "0"):
            g_var.micro_primitive["%s-%s-Entry/Exit" % (role, primitive)] = int(arr[3 - diff])
        elif (element(arr, 2 - diff) == "3"):
            g_var.micro_primitive["%s-%s-Metadata" % (role, primitive)] = int(arr[3 - diff])
        elif (element(arr, 2 - diff) == "5"):
            g_var.micro_primitive["%s-%s-GetPage" % (role, primitive)] = int(arr[3 - diff])
        elif (element(arr, 2 - diff) == "7"):
            g_var.micro_primitive["%s-%s-Mapping" % (role, primitive)] = int(arr[3 - diff])
        elif element(arr, 2 - diff) in ["6", "8", "9"]:
            val = 0
            key = "%s-%s-Other" % (role, primitive)
            if key in g_var.micro_primitive:
                val = g_var.micro_primitive[key]
            g_var.micro_primitive[key] = val + int(arr[3 - diff])

def proc_mmio(role, primitive, fin):
    ok = False
    for line in fin:
        arr = [x for x in re.sub('\s+', ' ', line).split(' ') if x]
        diff = 2 if role == "duvisor" else 0
        if "SBI_TEST_TIMING_END" in line:
            ok = True
        if not ok and role == "kvm":
            continue
        if (element(arr, 2 - diff) == "0"):
            g_var.micro_primitive["%s-%s-Entry/Exit" % (role, primitive)] = int(arr[3 - diff])
        elif (element(arr, 2 - diff) == "4"):
            g_var.micro_primitive["%s-%s-Decode" % (role, primitive)] = int(arr[3 - diff])
        elif (element(arr, 2 - diff) == "5"):
            g_var.micro_primitive["%s-%s-Transfer" % (role, primitive)] = int(arr[3 - diff])
        elif (element(arr, 2 - diff) == "7"):
            g_var.micro_primitive["%s-%s-Other" % (role, primitive)] = int(arr[3 - diff])

def proc_vipi(role, primitive, fin):
    for line in fin:
        arr = [x for x in re.sub('\s+', ' ', line).split(' ') if x]
        if (element(arr, 8) == "avg"):
            numbers = ''.join(re.findall(r"\d+", arr[9]))
            g_var.micro_primitive["%s-%s-vIPI Insert" % (role, primitive)] = int(numbers)
            if role == "kvm":
                g_var.micro_primitive["duvisor-%s-vIPI Insert" % primitive] = int(numbers)

def proc_vplic(role, primitive, fin):
    for line in fin:
        arr = [x for x in re.sub('\s+', ' ', line).split(' ') if x]
        if (element(arr, 8) == "avg"):
            numbers = ''.join(re.findall(r"\d+", arr[9]))
            g_var.micro_primitive["%s-%s-vEXT Insert" % (role, primitive)] = int(numbers)
            if role == "kvm":
                g_var.micro_primitive["duvisor-%s-vEXT Insert" % primitive] = int(numbers)


def update_row(df):
    for r in g_var.role:
        for primitive in g_var.micro_bench:
            if r == "vanillakvm" and primitive not in ["vplic", "vipi"]:
                continue
            if r == "duvisor" and primitive not in ["hypercall", "s2pf", "mmio"]:
                continue
            filename = "log/%s-breakdown-%s.log" % (r, primitive)
            # print(filename)
            try:
                with open(filename, 'r', errors='ignore') as fin:
                    if primitive == "hypercall":
                        proc_hypercall(r, primitive, fin)
                    elif primitive == "s2pf":
                        proc_s2pf(r, primitive, fin)
                    elif primitive == "mmio":
                        proc_mmio(r, primitive, fin)
                    elif primitive == "vipi":
                        proc_vipi(r, primitive, fin)
                    elif primitive == "vplic":
                        proc_vplic(r, primitive, fin)
            except FileNotFoundError:
                msg = "Warn: %s not found" % filename
                print(Fore.YELLOW + msg + Style.RESET_ALL)

    for primitive, cycles in g_var.micro_primitive.items():
        df.loc[primitive] = [cycles]

def create_rawdata():
    os.system("touch %s" % g_var.raw_data)
    line = "name,"
    for i in g_var.columns:
        line += str(i) + ","
    line = line[:-1]
    with open(g_var.raw_data, 'w') as f:
        f.write(line)

def update_lmbench(df):
    for role in ["pmp", "nopmp"]:
        for bench in ["cp", "wr", "rd", "rdwr", "frd", "fwr", "fcp", "bzero", "bcopy"]:
            filename = "log/ulh-1-fig10b-%s-%s.log" % (role, bench)
            try:
                with open(filename, 'r') as fin:
                    for line in fin:
                        if "100.0" in line:
                            p = line.split()
                            num = int(float(p[1]))
                            df.loc["fig10b-%s-%s" % (role, bench)] = [num]
            except FileNotFoundError:
                msg = "Warn: %s not found" % filename
                print(Fore.YELLOW + msg + Style.RESET_ALL)


def main():
    if not os.path.exists(g_var.raw_data):
        create_rawdata()

    df = pandas.read_csv(g_var.raw_data, index_col = 'name')

    update_row(df)
    update_lmbench(df)
    # print(df)
    df.to_csv(g_var.raw_data)
    

if __name__ == '__main__':
    main()
