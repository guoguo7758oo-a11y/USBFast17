#import <Foundation/Foundation.h>
#import <IOKit/IOKitLib.h>
#import <IOKit/IOKitKeys.h>

static BOOL USBFast17Enabled(void) {
    NSNumber *v = [[NSUserDefaults standardUserDefaults] objectForKey:@"Enabled"];
    return v ? v.boolValue : YES;
}

static NSInteger USBFast17Interval(void) {
    NSNumber *v = [[NSUserDefaults standardUserDefaults] objectForKey:@"LogInterval"];
    NSInteger n = v ? v.integerValue : 5;
    return MIN(MAX(n, 1), 60);
}

static void USBFast17Log(void) {
    if (!USBFast17Enabled()) return;

    io_registry_entry_t entry = IORegistryEntryFromPath(
        kIOMainPortDefault, "IOService:/IOPMPowerSource"
    );
    if (entry == MACH_PORT_NULL) {
        NSLog(@"[USBFast17] IOPMPowerSource not found");
        return;
    }

    CFMutableDictionaryRef props = NULL;
    if (IORegistryEntryCreateCFProperties(entry, &props,
        kCFAllocatorDefault, 0) == KERN_SUCCESS && props) {

        NSNumber *voltage = (__bridge NSNumber *)CFDictionaryGetValue(props, CFSTR("Voltage"));
        NSNumber *current = (__bridge NSNumber *)CFDictionaryGetValue(props, CFSTR("Current"));
        NSNumber *capacity = (__bridge NSNumber *)CFDictionaryGetValue(props, CFSTR("CurrentCapacity"));
        NSNumber *external = (__bridge NSNumber *)CFDictionaryGetValue(props, CFSTR("ExternalConnected"));

        NSLog(@"[USBFast17] voltage=%@ mV current=%@ mA capacity=%@ external=%@",
              voltage ?: @0, current ?: @0, capacity ?: @0, external ?: @0);

        CFRelease(props);
    }
    IOObjectRelease(entry);
}

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC),
                   dispatch_get_main_queue(), ^{
        USBFast17Log();
    });

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
        while (1) {
            sleep((unsigned int)USBFast17Interval());
            if (USBFast17Enabled()) USBFast17Log();
        }
    });
}
