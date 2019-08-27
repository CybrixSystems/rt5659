# make sure that the environment variables ARCH and CROSS_COMPILE
# are set for your architecture and cross compiler.
# And that KDIR points to the kernel to build against.
#
# e.g.:
# export ARCH=arm
# export CROSS_COMPILE=arm-linux-gnueabihf-
# export KDIR=../linux


# In case of out of tree build, build as a module
# (when build inside kernel we will not enter this directory and this will have no effect)
ifeq ($(CONFIG_SND_SOC_ACPI_INTEL_MATCH),)
CONFIG_SND_SOC_ACPI_INTEL_MATCH := m
endif

ifneq ($(KERNELRELEASE),)

# add version number derived from Git
#ifeq ($(KDIR),)
#PLMA_TFA_AUDIO_DRV_DIR=$(realpath -f $(srctree)/$(src))
#else
#PLMA_TFA_AUDIO_DRV_DIR=$(realpath -f $(src))
#endif
# GIT_VERSION=$(shell cd $(PLMA_TFA_AUDIO_DRV_DIR); git describe --tags --dirty --match "v[0-9]*.[0-9]*.[0-9]*")
# EXTRA_CFLAGS += -DTFA98XX_GIT_VERSIONS=\"$(GIT_VERSION)\"

EXTRA_CFLAGS += -I$(src)/inc
EXTRA_CFLAGS += -Werror

# obj-$(CONFIG_SND_SOC_ACPI_INTEL_MATCH) := soc-acpi-intel-match.o

# obj-$(CONFIG_SND_SOC_ACPI_INTEL_MATCH) := snd-soc-acpi-intel-match-objs

snd-soc-acpi-intel-match-objs := src/soc-acpi-intel-byt-match.o src/soc-acpi-intel-cht-match.o \
	src/soc-acpi-intel-hsw-bdw-match.o \
	src/soc-acpi-intel-skl-match.o src/soc-acpi-intel-kbl-match.o \
	src/soc-acpi-intel-bxt-match.o src/soc-acpi-intel-glk-match.o \
	src/soc-acpi-intel-cnl-match.o src/soc-acpi-intel-icl-match.o \
	src/soc-acpi-intel-hda-match.o

obj-$(CONFIG_SND_SOC_ACPI_INTEL_MATCH) := snd-soc-acpi-intel-match.o

# snd-soc-acpi-intel-match-objs += src/tfa_container.o
# snd-soc-acpi-intel-match-objs += src/tfa_dsp.o
# snd-soc-acpi-intel-match-objs += src/tfa_init.o


else

MAKEARCH := $(MAKE) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE)

all:
	$(MAKEARCH) -C $(KDIR) M=$(PWD) modules

modules:
	$(MAKE) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) -c $(KDIR) M=$(shell pwd) O="$(KBUILD_OUTPUT)" modules

modules_install:
	$(MAKEARCH) INSTALL_MOD_STRIP=1 -C $(KDIR) M=$(shell pwd) modules_install

clean:
	$(MAKEARCH) -C $(KDIR) M=$(PWD) clean
	rm -f $(snd-soc-acpi-intel-match-objs)

endif
