//
//  CRT_Delegate.m
//  Popup
//
//  Created by SR3u on 14.02.14.
//
//

#import "CRT_Delegate.h"
#import "NSFileManager+DirectoryLocations.h"

NSString* screenSharingUtilities[]=
{
    @"open \"/System/Library/CoreServices/Screen Sharing.app\" %@",
    @"open \"/System/Library/CoreServices/Applications/Screen Sharing.app\" %@",
};
NSString *formatString=@"";

@implementation CRT_Delegate


-(void)initFormatString
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *pathForFile=@"/System/Library/CoreServices/Screen Sharing.app";
    
    if ([fileManager fileExistsAtPath:pathForFile])
        formatString=screenSharingUtilities[0];
    else
    {
        if ([fileManager fileExistsAtPath:@"/System/Library/CoreServices/Applications/Screen Sharing.app"])
            formatString=screenSharingUtilities[1];
        else
        {
            NSLog(@"cannot find ScreenSharing.app at default locations, please update CRT.app");
            [self Quit:self];
        }
    }
}

-(NSString*)ServersFile
{
    NSString* str=[[FileManager applicationSupportDirectory] stringByAppendingString:@"/Servers.json"];
    if (![FileManager fileExistsAtPath:str])
    {
        [FileManager createFileAtPath:str contents:nil attributes:nil];
    }
    return str;
}
+(void)OpenActionWindow:(NSWindow*)ActionWindow
{
    NSPoint mouseLoc;
    mouseLoc = [NSEvent mouseLocation]; //get current mouse position
    CGFloat xPos = (CGFloat)mouseLoc.x-NSWidth([ActionWindow frame])/2;
    CGFloat yPos = (CGFloat)mouseLoc.y - NSHeight([ActionWindow frame]);
    [ActionWindow setFrame:NSMakeRect(xPos, yPos, NSWidth([ActionWindow frame]),
                                      NSHeight([ActionWindow frame])) display:YES];
    [ActionWindow orderFront:self];
    [ActionWindow orderFrontRegardless];
}
- (IBAction)ClosePanel:(id)sender{[MainPanelController closePanel];}
- (IBAction)OpenPanel:(id)sender{[MainPanelController openPanel];}

- (IBAction)OpenAddWindow:(id)sender;
{
    [self CloseEditWindow:self];
    [AddServerAddress setStringValue:@"VNC://"];
    [CRT_Delegate OpenActionWindow:AddWindow];
    [self ClosePanel:sender];
}
- (IBAction)OpenEditWindow:(id)sender;
{
    [self CloseAddWindow:self];
    TableRow *tmp=[Servers objectAtIndex:[Table selectedRow]];
    if(tmp == nil)
        return;
    [EditServerName setStringValue:[tmp getName]];
    [EditServerAddress setStringValue:[tmp getAddress]];
    [CRT_Delegate OpenActionWindow:EditWindow];
    [self ClosePanel:sender];
}
- (IBAction)CloseAddWindow:(id)sender
{
    [AddServerName setStringValue:@""];
    [AddServerAddress setStringValue:@"VNC://"];
    [AddWindow orderOut:self];
    [self OpenPanel:sender];
}
- (IBAction)CloseEditWindow:(id)sender
{
    [EditServerName setStringValue:@""];
    [EditServerAddress setStringValue:@"VNC://"];
    [EditWindow orderOut:self];
    [self OpenPanel:sender];
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
    NSString *connectionString=[NSString stringWithFormat:formatString,Addr];
    system([connectionString cStringUsingEncoding:NSUTF8StringEncoding]);
}
- (IBAction)DeleteServer:(id)sender
{
    [Servers removeObjectAtIndex:[Table selectedRow]];
    [Servers saveToFile:[self ServersFile]];
}
-(IBAction)Connect:(id)sender
{
    TableRow* tmp=[Servers objectAtIndex:[Table selectedRow]];
    if(tmp==nil){return;}
    [CRT_Delegate ConnectTo:[tmp getAddress]];
}
- (IBAction)AddServer:(id)sender
{
    TableRow *tmp=[TableRow new];
    [tmp setName:[AddServerName stringValue]];
    [tmp setAddress:[AddServerAddress stringValue]];
    [Servers add:tmp];
    [Servers saveToFile:[self ServersFile]];
    [self CloseAddWindow:self];
}
- (IBAction)SaveServer:(id)sender
{
    TableRow* tmp=[TableRow new];
    tmp=[tmp init];
    [tmp setName:[EditServerName stringValue]];
    [tmp setAddress:[EditServerAddress stringValue]];
    [Servers replaceObjectAtIndex:[Table selectedRow] withObject:tmp];
    [Servers saveToFile:[self ServersFile]];
    [self CloseEditWindow:self];
}
- (IBAction)AddConnectServer:(id)sender
{
    [CRT_Delegate ConnectTo:[AddServerAddress stringValue]];
    [self AddServer:self];
    [self CloseAddWindow:self];
}
- (IBAction)SaveConnectServer:(id)sender
{
    [CRT_Delegate ConnectTo:[EditServerAddress stringValue]];
    [self SaveServer:self];
    [self CloseEditWindow:self];
}
- (IBAction)OpenSettingsWindow:(id)sender
{
    [CRT_Delegate OpenActionWindow:SettingsWindow];
    [Version setStringValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    [Copyright setStringValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSHumanReadableCopyright"]];
    [self ClosePanel:sender];
}
-(void)Update
{
    [Servers loadFromFile:[self ServersFile]];
}
- (void)awakeFromNib
{
    [self initFormatString];
    FileManager=[NSFileManager defaultManager];
    [Table setTarget:self];
    [Table setDoubleAction:@selector(ServersDblClick:)];
    [self Update];
}
-(IBAction) ServersDblClick:(id)sender
{
    [self Connect:Table];
}
@end
