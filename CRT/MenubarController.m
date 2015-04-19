#import "MenubarController.h"
#import "StatusItemView.h"

@implementation MenubarController

@synthesize statusItemView = _statusItemView;

#pragma mark -
MenubarController* MenubarController_instance;

- (id)init
{
    self = [super init];
    if (self != nil)
    {@autoreleasepool{
        MenubarController_instance=self;
        // Install status item into the menu bar
        NSImage* statusImage=[NSImage imageNamed:@"Status"];
        double statussize=statusImage.size.width;
        NSStatusItem *statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:statussize];
        _statusItemView = [[StatusItemView alloc] initWithStatusItem:statusItem];
        _statusItemView.image = statusImage;
        _statusItemView.alternateImage = [NSImage imageNamed:@"StatusHighlighted"];
        _statusItemView.action = @selector(togglePanel:);
    }}
    return self;
}

+(CGFloat) statusBarItemWidth
{
    return [MenubarController_instance statusItemView].statusItem.length;
}

- (void)dealloc
{
    [[NSStatusBar systemStatusBar] removeStatusItem:self.statusItem];
}

#pragma mark -
#pragma mark Public accessors

- (NSStatusItem *)statusItem
{
    return self.statusItemView.statusItem;
}

#pragma mark -

- (BOOL)hasActiveIcon
{
    return self.statusItemView.isHighlighted;
}

- (void)setHasActiveIcon:(BOOL)flag
{
    self.statusItemView.isHighlighted = flag;
}

@end
