import var
import pandas
import os

def main():
    df = pandas.read_csv("app.csv", index_col = 'name')
    print(df)

if __name__ == '__main__':
    main()
