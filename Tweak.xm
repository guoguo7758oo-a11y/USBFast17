// USBFast17
// Diagnostic-only tweak for jailbroken iOS.
// It reports battery/charging telemetry; it does NOT fake USB-PD
// negotiation or force unsafe charging voltages/currents.

#import <Foundation/Foundation.h>
#import <IOKit/IOKitLib.h>
#import <IOKit/IOKitKeys.h>

static void USBFast17Log(void) {
    io_registry_entry_t entry = IORegistryEntryFromPath(
        kIOMainPortDefault,
        "IOService:/IOPMPowerSource"
    );

    if (entry == MACH_PORT_NULL) {
        NSLog(@"[USBFast17] IOPMPowerSource not found");
        return;
    }

    CFMutableDictionaryRef props = NULL;
    if (IORegistryEntryCreateCFProperties(entry, &props, kCFAllocatorDefault, 0) == KERN_SUCCESS && props) {
        NSNumber *voltage = (__bridge NSNumber *)CFDictionaryGetValue(props, CFSTR("Voltage"));
        NSNumber *current = (__bridge NSNumber *)CFDictionaryGetValue(props, CFSTR("Current"));
        NSNumber *capacity = (__bridge NSNumber *)CFDictionaryGetValue(props, CFSTR("CurrentCapacity"));
        NSNumber *external = (__bridge NSNumber *)CFDictionaryGetValue(props, CFSTR("ExternalConnected"));

        NSLog(@"[USBFast17] voltage=%@ mV current=%@ mA capacity=%@ external=%@",
              voltage, current, capacity, external);

        CFRelease(props);
    }

    IOObjectRelease(entry);
}

%ctor {
    @autoreleasepool {
        // Delay logging so SpringBoard has finished initializing.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC),
                       dispatch_get_main_queue(), ^{
            USBFast17Log();
        });
    }
}
