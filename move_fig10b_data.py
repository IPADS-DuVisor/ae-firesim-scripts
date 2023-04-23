import pandas as pd
from colorama import Fore, Style

def main():
    print(Fore.GREEN + "----- PMP Data (Fig10-b) -----" + Style.RESET_ALL)
    df = pd.read_csv("micro.csv", index_col = 'name')
    out_df = pd.DataFrame({"Title": []})
    for index, row in df.iterrows():
        name = str(index)
        if "fig10b" in name:
            p = name.split("-")
            bench = p[2]
            genre = "Duvisor" if p[1] == "pmp" else "DuVisor-noPMP"
            val = int(row["cycle"])
            out_df.loc[bench, genre] = val / 100
            out_df.loc[bench, "Title"] = bench
    out_df = out_df.fillna(-1)
    print(out_df)
    out_df.to_csv("vpmp/vpmp.res", sep=' ', index=False)


if __name__ == '__main__':
    main()
