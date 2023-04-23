for i in 1 2 4 ;
do
    dtc -o smp$i-vplic-512m.dts -O dts -I dtb smp$i-vplic-512m.dtb;
done
