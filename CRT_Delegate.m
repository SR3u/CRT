//
//  CRT_Delegate.m
//  Popup
//
//  Created by SR3u on 14.02.14.
//
//

#import "CRT_Delegate.h"
#import "NSFileManager+DirectoryLocations.h"

@implementation CRT_Delegate
-(NSString*)ServersFile
{
    //[[CRT_Delegate Dir_ApplicationSupport_CRT] stringByAppendingString:@"Servers.array"];
    NSString* str=[FileManager applicationSupportDirectory];
    NSLog(str);
    return str;
}
+(void)OpenActionWindow:(NSWindow*)ActionWindow
{
    NSPoint mouseLoc;
    mouseLoc = [NSEvent mouseLocation]; //get current mouse position
    CGFloat xPos = (CGFloat)mouseLoc.x;
    CGFloat yPos = (CGFloat)mouseLoc.y - NSHeight([ActionWindow frame]);
    [ActionWindow setFrame:NSMakeRect(xPos, yPos, NSWidth([ActionWindow frame]), NSHeight([ActionWindow frame])) display:YES];
    [ActionWindow orderFront:self];
    [ActionWindow orderFrontRegardless];
}
- (IBAction)OpenAddWindow:(id)sender;
{
    [self CloseEditWindow:self];
    [AddServerAddress setStringValue:@"VNC://"];
    [CRT_Delegate OpenActionWindow:AddWindow];
}
- (IBAction)OpenEditWindow:(id)sender;
{
    [self CloseAddWindow:self];
    [CRT_Delegate OpenActionWindow:EditWindow];
}
- (IBAction)CloseAddWindow:(id)sender
{
    [AddWindow orderOut:self];
}
- (IBAction)CloseEditWindow:(id)sender
{
    [EditWindow orderOut:self];
}
- (IBAction)Quit:(id)sender
{
    //Quitting App
    [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
}

+(void)ConnectTo:(NSString*)Addr
{
    Addr=[Addr lowercaseString];
    if(!([Addr hasPrefix:@"vnc://"]))
    {
        NSString *tmp=@"vnc://";
        Addr=[tmp stringByAppendingString:Addr];
    }
    NSString *connectionString=[NSString stringWithFormat:@"open \"/System/Library/CoreServices/Screen Sharing.app\" %@",Addr];
    system([connectionString cStringUsingEncoding:NSUTF8StringEncoding]);
}
-(IBAction)Connect:(id)sender
{
    //ToDo select server from table
    [CRT_Delegate ConnectTo:@"uranserver.no-ip.org"];
}
- (IBAction)AddServer:(id)sender
{
    TableRow *tmp=[TableRow alloc];
    [tmp setName:[AddServerName stringValue]];
    [tmp setAddress:[AddServerAddress stringValue]];
    [Servers add:tmp];
    [Servers saveToFile:[self ServersFile]];
    [self CloseAddWindow:self];
}
- (IBAction)SaveServer:(id)sender
{
    [Servers saveToFile:[self ServersFile]];
    [self CloseEditWindow:self];
}
- (IBAction)AddConnectServer:(id)sender
{
    [self AddServer:self];
    [self CloseAddWindow:self];
}
- (IBAction)SaveConnectServer:(id)sender
{
    [self CloseEditWindow:self];
}
-(void)Init
{
    [Servers loadFromFile:[self ServersFile]];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        FileManager=[NSFileManager defaultManager];
        [self Init];
    }
    return self;
}
@end
