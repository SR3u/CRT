#import "MenubarController.h"
#import "PanelController.h"
#import "CRT_Delegate.h"

@interface ApplicationDelegate : NSObject <NSApplicationDelegate, PanelControllerDelegate>
@property (nonatomic, strong) MenubarController *menubarController;
@property (nonatomic, strong, readonly) PanelController *panelController;

- (IBAction)togglePanel:(id)sender;

@end
