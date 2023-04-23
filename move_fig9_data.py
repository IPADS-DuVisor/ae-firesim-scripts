import var
import pandas
from colorama import Fore, Style

g_var = var.app_var()

def main():
    print(Fore.GREEN + "----- DV-EXT Impact Data(Fig9) -----" + Style.RESET_ALL)
    df = pandas.read_csv(g_var.raw_data, index_col = 'name')
    benchmarks = ["Netperf", "iperf3", "Memcached", "Hackbench", "Prime"]
    app2idx = {}
    for i in range(len(benchmarks)):
        app2idx[benchmarks[i]] = i
    n = len(benchmarks)
    app_df = pandas.DataFrame({
        'Benchmark': benchmarks,
        '1-vCPU': [0] * n,
        '1-err': [0] * n,
        '2-vCPU': [0] * n,
        '2-err': [0] * n,
        '4-vCPU': [0] * n,
        '4-err': [0] * n,
    })
    for app in benchmarks:
        for cpu in g_var.cpu_list:
            avg_str, std_str = "%s-avg" % app, "%s-std" % app
            vanilla_avg = df.loc['kvm-%d-fig9-vanilla' % cpu, avg_str]
            dv_avg = df.loc['kvm-%d-fig9-dv' % cpu, avg_str]
            dv_std = df.loc['kvm-%d-fig9-dv' % cpu, std_str]
            if vanilla_avg == -1:
                print("ERROR: #ID:0")
                continue
            if vanilla_avg == 0:
                print("ERROR. #ID:1")
                vanilla_avg = 0.001
            idx = app2idx[app]
            overhead = (vanilla_avg - dv_avg) / vanilla_avg
            print("app:%s cpu:%d overhead:%f" % (app, cpu, overhead))
            app_df.loc[idx, "%d-vCPU" % cpu] = overhead
            app_df.loc[idx, '%d-err' % cpu] = dv_std
    app_df.to_csv('dvext-impact/data-impact.dat', sep=' ',index=False)

if __name__ == '__main__':
    main()
