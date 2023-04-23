#!/usr/bin/python3
import sys
import re
import os
import pandas
import numpy as np
import var

g_var = var.app_var(str(sys.argv[1]), int(sys.argv[2]))
fig9_mode = (len(sys.argv) == 5 and sys.argv[3] == "fig9")
fig10_mode = (len(sys.argv) == 5 and sys.argv[3] == "fig10")

def element(arr, index):
    return arr[index] if index < len(arr) else None

def float_element(arr, index):
    return float(arr[index]) if index < len(arr) else None

def push_back(l, val):
    if val is None:
        return
    l.append(val)

def update_row(df, file_in, app_bench_value):
    for app in g_var.apps:
        if app not in app_bench_value:
            app_bench_value[app] = []

    try:
        with open(file_in, 'r') as fin:
            for line in fin:
                arr = [x for x in re.sub('\s+', ' ', line).split(' ') if x]
                if (element(arr,0) == 'Totals'):
                    push_back(app_bench_value["Memcached"], float_element(arr, 1))
                elif (element(arr,8) == 'receiver'):
                    push_back(app_bench_value["iperf3"], float_element(arr, -3))
                elif (element(arr,0) == '131072'):
                    push_back(app_bench_value["Netperf"], float_element(arr, 4))
                elif (element(arr,0) == "Time:"):
                    push_back(app_bench_value['Hackbench'], float_element(arr, 1))
                elif (element(arr,0) == 'real'):
                    app_bench_value['Untar'].append(float(arr[1][2:-1]))
                elif (element(arr,5) == 'transferred'):
                    app_bench_value["FileIO"].append(float(arr[-1][1:-7]))
                elif (element(arr,0) == 'total' and element(arr,1) == 'time:'):
                    app_bench_value["Prime"].append(float(arr[-1][:-1]))
    except FileNotFoundError:
        print(f"Info: '{file_in}' not found")


    df_row = [-1] * len(g_var.columns)
    for app, vals in app_bench_value.items():
        if len(vals) == 0:
            continue
        avg_str, std_str = str(app) + "-avg", str(app) + "-std"
        avg, std = np.mean(vals), np.std(vals)
        df_row[g_var.col2idx[avg_str]] = avg
        df_row[g_var.col2idx[std_str]] = std
    row_idx = g_var.row_idx
    if fig9_mode or fig10_mode:
        row_idx = "%s-%s-%s-%s" % (sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])
    df.loc[row_idx] = df_row

def create_rawdata():
    os.system("touch %s" % g_var.raw_data)
    line = "name,"
    for i in g_var.columns:
        line += str(i) + ","
    line = line[:-1]
    with open(g_var.raw_data, 'w') as f:
        f.write(line)

def main():
    if not os.path.exists(g_var.raw_data):
        create_rawdata()

    df = pandas.read_csv(g_var.raw_data, index_col = 'name')
    app_bench_value = {}

    log_name = "log/%s" % g_var.log_file
    if fig9_mode or fig10_mode:
        log_name = "log/%s-%s-%s-%s.log" % \
            (sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])
    update_row(df, log_name, app_bench_value);
    # print(df)
    df.to_csv(g_var.raw_data)
    

if __name__ == '__main__':
    main()
