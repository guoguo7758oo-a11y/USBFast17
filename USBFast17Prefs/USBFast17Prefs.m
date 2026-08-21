#import <UIKit/UIKit.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>

@interface USBFast17PrefsListController : PSListController {
    NSArray *_usbFast17Specifiers;
}
@end

@implementation USBFast17PrefsListController

- (NSArray *)specifiers {
    if (!_usbFast17Specifiers) {
        _usbFast17Specifiers =
            [self loadSpecifiersFromPlistName:@"Root"
                                        target:self];
    }

    return _usbFast17Specifiers;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"USBFast17";
}

@end
