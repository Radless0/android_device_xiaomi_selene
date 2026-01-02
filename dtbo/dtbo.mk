# Araç yollarını tanımla
APPEND_CERTS := $(DEVICE_PATH)/dtbo/append_certs.py
DTBO_OUT_DIR := $(DTBO_OUT)/arch/$(KERNEL_ARCH)/boot/dts
# Bu değişken zaten BoardConfig'den geliyor: $(PRODUCT_OUT)/dtbo.img

# Kuralı tanımla
$(PRODUCT_OUT)/dtbo.img: $(DTC) $(MKDTIMG) $(MKDTBOIMG)
	@echo "Building dtbo.img..."
	$(call make-dtbo-target,$(KERNEL_DEFCONFIG))
	$(call make-dtbo-target,dtbs)
	$(MKDTBOIMG) cfg_create $@ $(DTBO_OUT)/dtboimg.cfg -d $(DTBO_OUT_DIR)
	@echo "Signing dtbo.img with Xiaomi certs..."
	python3 $(APPEND_CERTS) --alignment 16 --cert1 $(DEVICE_PATH)/dtbo/cert1.der --cert2 $(DEVICE_PATH)/dtbo/cert2.der --dtbo $@
