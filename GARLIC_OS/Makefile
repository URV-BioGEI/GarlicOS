#---------------------------------------------------------------------------------
.SUFFIXES:
#---------------------------------------------------------------------------------
ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment. export DEVKITARM=<path to>devkitARM")
endif

include $(DEVKITARM)/ds_rules

export TARGET		:=	$(shell basename $(CURDIR))
export TOPDIR		:=	$(CURDIR)
NITRODATA			:=	nitrofiles

export GAME_TITLE	:=	GARLIC_OS_v2
export GAME_SUBTITLE1	:=	Practica de Estructura de Sistemas Operativos
export GAME_SUBTITLE2	:=	Departamento de Ingenieria Informatica y Matematicas (URV)
export GAME_ICON	:= 	$(DEVKITPRO)/libnds/icon.bmp

export _ADDFILES	:=	-d $(CURDIR)/$(NITRODATA)


.PHONY: arm7/$(TARGET).elf arm9/$(TARGET).elf

#---------------------------------------------------------------------------------
# main targets
#---------------------------------------------------------------------------------
all : $(TARGET).nds	
$(TARGET).nds : arm7/arm7.elf arm9/arm9.elf	
	ndstool	-c $(TARGET).nds -7 arm7/arm7.elf -9 arm9/arm9.elf -b $(GAME_ICON) "$(GAME_TITLE);$(GAME_SUBTITLE1);$(GAME_SUBTITLE2)" $(_ADDFILES)
	@echo built ... $(notdir $@)

run : $(TARGET).nds
	@echo "runing $(TARGET).nds with DesmuME"
	@$(DESMUME)/DeSmuME.exe $(TARGET).nds &
	
debug : $(TARGET).nds arm9/arm9.elf
	@echo "testing $(TARGET).nds/.elf with DeSmuME_dev/Insight (gdb) through TCP port=1000"
	@$(DESMUME)/DeSmuME_dev.exe --arm9gdb=1000 $(TARGET).nds &
	@$(DEVKITPRO)/insight/bin/arm-eabi-insight arm9/arm9.elf &
	
debug7 : $(TARGET).nds arm7/arm7.elf
	@echo "testing $(TARGET).nds/.elf with DeSmuME_dev/Insight (gdb) through TCP port=1000"
	@$(DESMUME)/DeSmuME_dev.exe --arm9gdb=1000 $(TARGET).nds &
	@$(DEVKITPRO)/insight/bin/arm-eabi-insight arm7/arm7.elf &
	
debug9 : $(TARGET).nds arm9/arm9.elf
	@echo "testing $(TARGET).nds/.elf with DeSmuME_dev/Insight (gdb) through TCP port=1000"
	@$(DESMUME)/DeSmuME_dev.exe --arm9gdb=1000 $(TARGET).nds &
	@$(DEVKITPRO)/insight/bin/arm-eabi-insight arm9/arm9.elf &
	

#---------------------------------------------------------------------------------
arm7/arm7.elf:
	$(MAKE) -C arm7
	
#---------------------------------------------------------------------------------
arm9/arm9.elf:
	$(MAKE) -C arm9

#---------------------------------------------------------------------------------
clean:
	$(MAKE) -C arm9 clean
	$(MAKE) -C arm7 clean
	rm -f $(TARGET).nds
