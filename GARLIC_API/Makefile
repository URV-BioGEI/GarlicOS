#-------------------------------------------------------------------------------
# Makefile for GARLIC API's Object (interface routines)
#-------------------------------------------------------------------------------

ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment. export DEVKITARM=<path to>devkitARM")
endif


#-------------------------------------------------------------------------------
# options for Object code generation
#-------------------------------------------------------------------------------
ARCH	:=	-march=armv5te -mlittle-endian

ASFLAGS	:=	-g0 $(ARCH) -mcpu=arm946e-s
				# -g0						: disable debug info generation
				# $(ARCH) -mcpu=arm946e-s	: define architecture and machine

#-------------------------------------------------------------------------------
# make commands
#-------------------------------------------------------------------------------

GARLIC_API.o : GARLIC_API.s
	arm-none-eabi-as $(ASFLAGS) GARLIC_API.s -o GARLIC_API.o

#---------------------------------------------------------------------------------
# clean commands
#---------------------------------------------------------------------------------
clean : 
	@rm -fv GARLIC_API.o
