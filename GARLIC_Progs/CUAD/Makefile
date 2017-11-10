#-------------------------------------------------------------------------------
# Makefile for a GARLIC program (Executable)
#-------------------------------------------------------------------------------
ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment. export DEVKITARM=<path to>devkitARM")
endif

#-------------------------------------------------------------------------------
# Current directory for GARLIC's API content
#-------------------------------------------------------------------------------
GARLICAPI	:=	../../GARLIC_API
				# assume a relative structure of the GARLIC project directories

#---------------------------------------------------------------------------------
# TARGET is the name of the project's directory
#---------------------------------------------------------------------------------
TARGET	:=	$(shell basename $(CURDIR))

#-------------------------------------------------------------------------------
# options for Executable code generation
#-------------------------------------------------------------------------------
ARCH	:=	-march=armv5te -mlittle-endian

CFLAGS	:=	-Wall -g0 $(ARCH) -mtune=arm946e-s -fomit-frame-pointer -ffast-math
				# -Wall						: enable all warnings
				# -g0						: disable debug info generation
				# $(ARCH) -mtune=arm946e-s	: tune code generation for specific machine
				# -fomit-frame-pointer 		: avoid to use a 'frame-pointer' register in functions that do not need it
				# -ffast-math				: optimize math operations

ASFLAGS	:=	-g0 $(ARCH) -mcpu=arm946e-s
				# -g0						: disable debug info generation
				# $(ARCH) -mcpu=arm946e-s	: define architecture and machine

LDFLAGS	:=	--oformat elf32-littlearm \
			--emit-relocs --gc-sections --strip-debug \
			-z max-page-size=0x0400
				# --oformat elf32-littlearm	: define output code target
				# --emit-relocs				: generate relocations in final output
				# --gc-sections				: remove unused sections
				# --strip-debug				: strip debugging symbols
				# -z max-page-size=0x0400	: force max page size to 1 Kbyte,
				#							  which fits the alignment of segments to a lower setting than the default (16 Kb),
				#							  and provides a working executable (otherwise, the start of the text segment gets wrongly trimmed to 0x00000000).
				#							  Besides, it reduces de size of the .elf file.

#-------------------------------------------------------------------------------
# make commands
#-------------------------------------------------------------------------------

$(TARGET).elf : $(TARGET).o
	arm-none-eabi-ld $(LDFLAGS) $(TARGET).o $(GARLICAPI)/GARLIC_API.o -o $(TARGET).elf

$(TARGET).o : $(TARGET).s
	arm-none-eabi-as $(ASFLAGS) $(TARGET).s -o $(TARGET).o

$(TARGET).s : $(TARGET).c
	arm-none-eabi-gcc $(CFLAGS) -S $(TARGET).c -I$(GARLICAPI) -o $(TARGET).s

#---------------------------------------------------------------------------------
# clean commands
#---------------------------------------------------------------------------------
clean : 
	@rm -fv $(TARGET).s
	@rm -fv $(TARGET).o
	@rm -fv $(TARGET).elf
