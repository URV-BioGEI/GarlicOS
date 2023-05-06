#!/bin/bash

CURRENT_DIR="$(pwd)"
PROJECT_DIR="$(cd "$(dirname -- "$1")" >/dev/null; pwd -P)/$(basename -- "$1")"

# Compile API
cd "${PROJECT_DIR}/GARLIC_API"
make clean
make

# Create programs dir
cd "${PROJECT_DIR}"
mkdir GARLIC_OS/nitrofiles/Programas

# Compile programs
cd "${PROJECT_DIR}/GARLIC_PROGS"
for prog_folder_name in *; do
	cd "${PROJECT_DIR}/GARLIC_PROGS/${prog_folder_name}"
	make clean
	make 
	mv "${prog_folder_name}.elf" "${PROJECT_DIR}/GARLIC_OS/nitrofiles/Programas"
done

# Compile OS
cd "${PROJECT_DIR}/GARLIC_OS"
make clean
make
make run
	

