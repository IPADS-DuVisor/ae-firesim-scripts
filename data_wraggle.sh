#!/bin/bash

## 1. App Figure (Fig8)
python extract_app_data.py kvm 1
python extract_app_data.py kvm 2
python extract_app_data.py kvm 4
python extract_app_data.py native 1
python extract_app_data.py native 2
python extract_app_data.py native 4
python extract_app_data.py ulh 1
python extract_app_data.py ulh 2
python extract_app_data.py ulh 4

python move_app_data.py

## 2. Breakdown Figure
python extract_micro_data.py

# Fig7
python move_micro_data.py

# Fig10b
python move_fig10b_data.py
 
## 3. Fig-9
python extract_app_data.py kvm 1 fig9 dv
python extract_app_data.py kvm 1 fig9 vanilla
python extract_app_data.py kvm 2 fig9 dv
python extract_app_data.py kvm 2 fig9 vanilla
python extract_app_data.py kvm 4 fig9 dv
python extract_app_data.py kvm 4 fig9 vanilla

python move_fig9_data.py
 
## 4. Fig-10a
python extract_app_data.py kvm 4 fig10 512
python extract_app_data.py kvm 4 fig10 1024
python extract_app_data.py kvm 4 fig10 1536
python extract_app_data.py kvm 4 fig10 2048
python extract_app_data.py ulh 4 fig10 512
python extract_app_data.py ulh 4 fig10 1024
python extract_app_data.py ulh 4 fig10 1536
python extract_app_data.py ulh 4 fig10 2048
 
python move_fig10_data.py
 
## Draw
./draw.sh
