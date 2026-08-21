#import <UIKit/UIKit.h>

@interface PSSpecifier : NSObject
@end

@interface PSListController : UITableViewController

- (NSArray *)loadSpecifiersFromPlistName:(NSString *)name
                                  target:(id)target;

@end

@interface USBFast17PrefsListController : PSListController
@end

@implementation USBFast17PrefsListController

- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers =
            [self loadSpecifiersFromPlistName:@"Root"
                                       target:self];
    }

    return _specifiers;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"USBFast17";
}

@end
