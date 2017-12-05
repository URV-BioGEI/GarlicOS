#!/bin/bash
cd /d/ESO_grup_H/GARLIC_API # direccion de inicio debe ser ruta/.../GARLIC_API
make clean
make
cd ..

cd GARLIC_OS/nitrofiles 
mkdir Programas
cd ../../GARLIC_PROGS
numprogs=$(($(ls -l | wc -l)-1))
echo $numprogs programas a compilar manin

for i in `seq 1 10`; do
	prog=$(ls -l | tr -s ' ' | cut -d ' ' -f9 | tail -n $numprogs | head -n $i | tail -n 1)
	cd $prog
	make clean
	make 
	mv *.elf ../../GARLIC_OS/nitrofiles/Programas
	cd ..
done

cd ../GARLIC_OS
make clean
make
make run
	

