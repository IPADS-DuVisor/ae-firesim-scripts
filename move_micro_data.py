import var
import pandas as pd
from colorama import Fore, Style

g_var = var.micro_var()

def main():
    print(Fore.GREEN + "----- Breakdown Data (Fig7) -----" + Style.RESET_ALL)
    df = pd.read_csv(g_var.raw_data, index_col = 'name')
    h = {} # primitive -> dataframe
    for key, row in df.iterrows():
        cycles = int(row['cycle'])
        p = str(key).split("-")
        role, primitive, part = p[0], p[1], p[2]
        if "pmp" in primitive:
            continue
        if primitive not in h:
            tmp = {"system": []}
            for micro_part in g_var.micro_bench[primitive]:
                tmp[micro_part] = []
            h[primitive] = pd.DataFrame(tmp)
        if primitive in ["vipi", "vplic"]:
            if role == "kvm":
                role = "kvm-opt"
            elif role == "vanillakvm":
                role = "kvm"
        h[primitive].loc[role, part] = \
            cycles / 100000 if primitive in ["hypercall", "s2pf", "mmio"] else cycles
        h[primitive].loc[role, "system"] = role.upper()
    for primitive, df in h.items():
        df.fillna(0, inplace=True)
        if primitive == "vipi":
            df = df.sort_values("vIPI Insert", ascending=False)
        elif primitive == "vplic":
            df = df.sort_values("vEXT Insert", ascending=False)
        print(Fore.CYAN + primitive + Style.RESET_ALL)
        print(df)
        df.to_csv("micro-%s/micro-%s.res" % (primitive, primitive), sep=' ',index=False, na_rep = 0)

if __name__ == '__main__':
    main()
