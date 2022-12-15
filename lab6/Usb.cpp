#include "libusb-1.0/libusb.h"
#include <stdio.h>
#include <cstring>
/*
 * How to execute:
 * >g++ Usb.cpp -o usb -lusb-1.0
 * >./usb
 *
 *
 *
 */


void PrintFields(libusb_device *device) {
    struct libusb_device_descriptor descriptor;
    libusb_get_device_descriptor(device,&descriptor);
    struct libusb_device_handle *handle;
    libusb_open(device,&handle);
    unsigned char iSerialNumber[256];
    if (handle && descriptor.iSerialNumber) {
        libusb_get_string_descriptor_ascii(handle, descriptor.iSerialNumber, iSerialNumber, sizeof(iSerialNumber));
    }
    else
        strncpy(reinterpret_cast<char *>(iSerialNumber), "null", sizeof(iSerialNumber));
    libusb_close(handle);
    printf("%-20.2x 0x%-18.4x 0x%-18.4x %-20s\n", (int) descriptor.bDeviceClass, descriptor.idVendor, descriptor.idProduct, iSerialNumber);
}

int main() {
    libusb_device **device;
    libusb_context *context;
    libusb_init(&context);
    ssize_t devices_amount = libusb_get_device_list(context, &device);
    printf("Devices found: %zd\n\n", devices_amount);
    printf("%-20s %-20s %-20s %-20s\n","Device class","Vendor ID","Product ID","Serial number\n");
    for (int i = 0; i < devices_amount; i++) {
        PrintFields(device[i]);
    }
    libusb_free_device_list(device, 1);
    libusb_exit(context);
    return 0;
}