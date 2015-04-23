#import "ApplicationDelegate.h"
#import "CRT_SettingsDelegate.h"
#import "NSFileManager+DirectoryLocations.h"

@implementation ApplicationDelegate

@synthesize panelController = _panelController;
@synthesize menubarController = _menubarController;

#pragma mark -

- (void)dealloc
{
    [_panelController removeObserver:self forKeyPath:@"hasActivePanel"];
}

#pragma mark -

void *kContextActivePanel = &kContextActivePanel;

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kContextActivePanel) {
        self.menubarController.hasActiveIcon = self.panelController.hasActivePanel;
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    // Install icon into the menu bar
    self.menubarController = [[MenubarController alloc] init];
    [[NSUserNotificationCenter defaultUserNotificationCenter]removeAllDeliveredNotifications];
    [[self class] autostart];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    // Explicitly remove the icon from the menu bar
    self.menubarController = nil;
    return NSTerminateNow;
}

#pragma mark - Actions

- (IBAction)togglePanel:(id)sender
{
    self.menubarController.hasActiveIcon = !self.menubarController.hasActiveIcon;
    self.panelController.hasActivePanel = self.menubarController.hasActiveIcon;
}

#pragma mark - Public accessors

- (PanelController *)panelController
{
    if (_panelController == nil) {
        _panelController = [[PanelController alloc] initWithDelegate:self];
        [_panelController addObserver:self forKeyPath:@"hasActivePanel" options:0 context:kContextActivePanel];
    }
    return _panelController;
}

#pragma mark - PanelControllerDelegate

- (StatusItemView *)statusItemViewForPanelController:(PanelController *)controller
{
    return self.menubarController.statusItemView;
}
-(void) applicationWillTerminate:(NSNotification *)notification
{
    [CRT_SettingsDelegate appWillTerminate];
}
#pragma mark - AutoStart
+(void) autostart
{
    NSString*autostartScript=[NSString stringWithFormat:@"'%@/autostart'",[self autostartFolder]];
    NSTask *task = [NSTask new];
    NSMutableArray *args = [NSMutableArray array];
    [args addObject:@"-c"];
    [args addObject:autostartScript];
    [task setLaunchPath:@"/bin/bash"];
    [task setArguments:args];
    [task launch];
    [NSApp terminate:nil];
}
+(NSString*) autostartFolder
{@autoreleasepool{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* str=[[fileManager applicationSupportDirectory] stringByAppendingString:@"/Autostart"];
    BOOL res=NO;
    if (![fileManager fileExistsAtPath:str isDirectory:&res])
    {
        NSError *error;
        [fileManager createDirectoryAtPath:str withIntermediateDirectories:YES attributes:nil error:&error];
        if(error!=nil){NSLog(@"%s error: %@",__PRETTY_FUNCTION__,error.localizedDescription);return str;}
    }
    else
    {
        if(res){return str;}
        else{NSLog(@"%s error: Updatge folder is not a directory!",__PRETTY_FUNCTION__);}
    }
    return str;
}}
@end
