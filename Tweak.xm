// USBFast17
// Diagnostic-only tweak for jailbroken iOS.
// Reads IOPMPowerSource charging/battery information.
// Does not modify USB-PD negotiation, voltage or current.

#import <Foundation/Foundation.h>
#import <IOKit/IOKitLib.h>
#import <IOKit/IOKitKeys.h>

static void USBFast17Log(void) {
    mach_port_t masterPort = kIOMasterPortDefault;

    io_registry_entry_t entry =
        IORegistryEntryFromPath(
            masterPort,
            "IOService:/IOResources/IOPMPowerSource"
        );

    if (entry == MACH_PORT_NULL) {
        NSLog(@"[USBFast17] IOPMPowerSource not found");
        return;
    }

    CFMutableDictionaryRef props = NULL;

    kern_return_t kr =
        IORegistryEntryCreateCFProperties(
            entry,
            &props,
            kCFAllocatorDefault,
            0
        );

    if (kr == KERN_SUCCESS && props) {

        CFTypeRef voltage =
            CFDictionaryGetValue(props, CFSTR("Voltage"));

        CFTypeRef current =
            CFDictionaryGetValue(props, CFSTR("Current"));

        CFTypeRef capacity =
            CFDictionaryGetValue(props, CFSTR("CurrentCapacity"));

        CFTypeRef external =
            CFDictionaryGetValue(props, CFSTR("ExternalConnected"));

        NSLog(
            @"[USBFast17] voltage=%@ mV current=%@ mA capacity=%@ external=%@",
            voltage,
            current,
            capacity,
            external
        );

        CFRelease(props);
    }

    IOObjectRelease(entry);
}

%ctor {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            5 * NSEC_PER_SEC
        ),
        dispatch_get_main_queue(),
        ^{
            USBFast17Log();
        }
    );
}
