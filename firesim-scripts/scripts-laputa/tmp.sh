#!/bin/bash


#!bin/sh
for file in ./*
do
    if test -f $file
    then
		sed -i 's/192.168.3.100/192.168.3.100/g' $file
    fi
done
