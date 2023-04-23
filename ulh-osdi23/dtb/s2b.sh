for i in 1 2 4 ;
do
    dtc -o smp$i-vplic-512m.dtb -O dtb -I dts smp$i-vplic-512m.dts;
done
