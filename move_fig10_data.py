import var
import pandas
from colorama import Fore, Style

g_var = var.app_var()

def main():
    print(Fore.GREEN + "----- Scale Memory Data (Fig10-a) -----" + Style.RESET_ALL)
    df = pandas.read_csv(g_var.raw_data, index_col = 'name')
    for index, row in df.iterrows():
        name = str(index)
        if "fig10" in name and "fig10b" not in name:
            strs = name.split("-")
            role = "kvm" if strs[0] == "kvm" else "laputa"
            size = strs[3]
            filename = "scale-mem/%sMB.%s" % (size, role)
            print("%s-%s: %s" % (role, size, row["Memcached-avg"]))
            with open (filename, "w") as fout:
                fout.write("%s" % row["Memcached-avg"])


if __name__ == '__main__':
    main()
