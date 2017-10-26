#-------------------------------------------------------------------------------
.SUFFIXES:
#-------------------------------------------------------------------------------

ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment. export DEVKITARM=<path to>devkitARM")
endif

ifeq ($(strip $(DEVKITPRO)),)
$(error "Please set DEVKITPRO in your environment. export DEVKITPRO=<path to>devkitPRO")
endif

ifeq ($(strip $(DESMUME)),)
$(error "Please set DESMUME in your environment. export DESMUME=<path to>DeSmuME")
endif

include $(DEVKITARM)/base_rules

#-------------------------------------------------------------------------------
# TARGET is the name of the output
# BUILD is the directory where object files & intermediate files will be placed
# SOURCES is a list of directories containing source code
# INCLUDES is a list of directories containing extra header files
# DATA contains .bin files with extra data for the project (e.g. graphic tiles)
# NITRODATA contains the "virtual" file system accessed through filesystem lib
#-------------------------------------------------------------------------------
TARGET		:=	$(shell basename $(CURDIR))
BUILD		:=	build
SOURCES		:=	source
INCLUDES	:=	include
DATA		:=	data
NITRODATA	:=	nitrofiles

#-------------------------------------------------------------------------------
# options for code generation
#-------------------------------------------------------------------------------
ARCH	:=	-march=armv5te -mlittle-endian

CFLAGS	:=	-Wall -g -O2 \
			$(ARCH) -mtune=arm946e-s -fomit-frame-pointer -ffast-math
				# -Wall						: enable all warnings
				# -g						: enable debug info generation
				# -O2						: code optimization level 2
				# $(ARCH) -mtune=arm946e-s	: tune code generation for specific machine
				# -fomit-frame-pointer 		: avoid to use a 'frame-pointer' register in functions that do not need it
				# -ffast-math				: optimize math operations

CFLAGS	+=	$(INCLUDE) -DARM9

ASFLAGS	:=	-g $(ARCH)
LDFLAGS	=	-specs=ds_arm9.specs $(ARCH)

#-------------------------------------------------------------------------------
# any extra libraries we wish to link with the project (order is important)
#-------------------------------------------------------------------------------
LIBS	:= 	-lfilesystem -lfat -lnds9
 
#-------------------------------------------------------------------------------
# list of directories containing libNDS libraries, this must be the top level
# containing include and lib
#-------------------------------------------------------------------------------
LIBNDS	:=	$(DEVKITPRO)/libnds
 
#---------------------------------------------------------------------------------
# check if the build directory is not created yet
#---------------------------------------------------------------------------------
ifneq ($(BUILD),$(notdir $(CURDIR)))
#---------------------------------------------------------------------------------

export OUTPUT	:=	$(CURDIR)/$(TARGET)

export VPATH	:=	$(foreach dir,$(SOURCES),$(CURDIR)/$(dir))
export DEPSDIR	:=	$(CURDIR)/$(BUILD)

CFILES		:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.c)))
AFILES		:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.s)))
BINFILES	:=	$(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*.bin)))
 
export OFILES	:=	$(BINFILES:.bin=.o) $(CFILES:.c=.o)
export SFILES	:=	$(AFILES:.s=.o)

# GARLIC_API is the directory where the API's include and source code lives
#			(assume a relative structure of the GARLIC project directories)
export GARLICAPI	:=	$(CURDIR)/../GARLIC_API

export INCLUDE	:=	$(foreach dir,$(INCLUDES),-I$(CURDIR)/$(dir)) \
					$(foreach dir,$(LIBNDS),-I$(dir)/include) \
					-I$(GARLICAPI)
 
export LIBPATHS	:=	$(foreach dir,$(LIBNDS),-L$(dir)/lib)


#---------------------------------------------------------------------------------
# use CC for linking standard C projects 
#---------------------------------------------------------------------------------
export LD	:=	$(CC)

export GAME_TITLE	:=	GARLIC_OS_v1
export GAME_SUBTITLE1	:=	Practica de Estructura de Sistemas Operativos
export GAME_SUBTITLE2	:=	Departamento de Ingenieria Informatica y Matematicas (URV)
export GAME_ICON	:= 	$(DEVKITPRO)/libnds/icon.bmp

export _ADDFILES	:=	-d $(CURDIR)/$(NITRODATA)


.PHONY: $(BUILD) clean
 
#---------------------------------------------------------------------------------
$(BUILD):
	@[ -d $@ ] || mkdir -p $@
	@make --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile

#---------------------------------------------------------------------------------
clean:
	@echo "Removing ALL intermediate files... "
	@echo "Por favor, recuerda que habitualmente NO es necesario hacer un 'clean' antes de un 'make'"
	@sleep 3
	@rm -fr $(BUILD) $(TARGET).elf $(TARGET).nds

#---------------------------------------------------------------------------------
run : $(TARGET).nds
	@echo "runing $(TARGET).nds with DesmuME"
	@$(DESMUME)/DeSmuME.exe $(TARGET).nds &

#---------------------------------------------------------------------------------
debug : $(TARGET).nds $(TARGET).elf
	@echo "testing $(TARGET).nds/.elf with DeSmuME_dev/Insight (gdb) through TCP port=1000"
	@$(DESMUME)/DeSmuME_dev.exe --arm9gdb=1000 $(TARGET).nds &
	@$(DEVKITPRO)/insight/bin/arm-eabi-insight $(TARGET).elf &

#---------------------------------------------------------------------------------
else

DEPENDS	:=	$(OFILES:.o=.d) $(SFILES:.o=.d)

#---------------------------------------------------------------------------------
# main targets
#---------------------------------------------------------------------------------
$(OUTPUT).nds	: 	$(OUTPUT).elf
$(OUTPUT).elf	:	$(OFILES) $(SFILES)

#---------------------------------------------------------------------------------
%.nds: %.elf
	@ndstool -c $@ -9 $< -b $(GAME_ICON) "$(GAME_TITLE);$(GAME_SUBTITLE1);$(GAME_SUBTITLE2)" $(_ADDFILES)
	@echo built ... $(notdir $@)

#---------------------------------------------------------------------------------
%.elf:
	@echo linking $(notdir $@)
	$(LD)  $(LDFLAGS) $(OFILES) $(LIBPATHS) $(LIBS) $(SFILES) -o $@

#---------------------------------------------------------------------------------
%.bin.o	:	%.bin
#---------------------------------------------------------------------------------
	@echo $(notdir $<)
	$(bin2o)
 
-include $(DEPSDIR)/*.d


#---------------------------------------------------------------------------------------
endif
#---------------------------------------------------------------------------------------
