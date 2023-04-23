import var
import pandas
from colorama import Fore, Style

g_var = var.app_var()

def main():
    print(Fore.GREEN + "----- APP Data (Fig8) -----" + Style.RESET_ALL)
    df = pandas.read_csv(g_var.raw_data, index_col = 'name')
    for app in g_var.apps:
        n = len(g_var.cpu_list)
        app_df = pandas.DataFrame({
                'Title': g_var.cpu_list,
                'KVM-OPT': [0] * n,
                'KVM-STDERR': [0] * n,
                'DuVisor': [0] * n,
                'DuVisor-STDERR': [0] * n,
                })
        print("app:%s" % app)
        for cpu in g_var.cpu_list:
            avg_str, std_str = "%s-avg" % app, "%s-std" % app
            kvm = df.loc['kvm-%d' % cpu, avg_str]
            ulh = df.loc['ulh-%d' % cpu, avg_str]
            native = df.loc['native-%d' % cpu, avg_str]
            kvm_std = df.loc['kvm-%d' % cpu, std_str]
            ulh_std = df.loc['ulh-%d' % cpu, std_str]
            if native == -1 or kvm == -1:
                if app not in ["FileIO", "Untar"]:
                    print(Fore.YELLOW + "WARN. app:%s cpu:%d natve-score:%d kvm-score:%d" % \
                            (app, cpu, native, kvm) + Style.RESET_ALL)
                continue
            if native == 0:
                print(Fore.YELLOW + "WARN. app:%s cpu:%d native-score:0" % \
                        (app, cpu) + Style.RESET_ALL)
                native = 0.001
            idx = g_var.cpu_idx(cpu)
            kvm_score = max(1, (native - kvm) / native + 1)
            ulh_score = max(1, (native - ulh) / native + 1)
            print("cpu:%s kvm-score:%f duvisor-score:%f" % (cpu, kvm_score, ulh_score))
            app_df.loc[idx, 'KVM-OPT'] = kvm_score
            app_df.loc[idx, 'KVM-STDERR'] = kvm_std
            app_df.loc[idx, 'DuVisor'] = ulh_score
            app_df.loc[idx, 'DuVisor-STDERR'] = ulh_std
        app_df.to_csv('app-%s/app.res' % app.lower(), sep=' ',index=False)

if __name__ == '__main__':
    main()
