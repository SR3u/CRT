//
//  CRT_SettingsDelegate.m
//  CRT
//
//  Created by SR3u on 17.02.14.
//
//

#import "CRT_SettingsDelegate.h"
#import "NSFileManager+DirectoryLocations.h"
#import "jsonTools.h"
#import "Updater.h"
#import "ScreenSharingImporter.h"
#import "TableData.h"
#import "Updater.h"

@implementation CRT_SettingsDelegate
NSMutableDictionary* settingsDict,*UserNotificationsActions,*UserNotificationsTTL;
NSUserNotificationCenter *CRT_NotificationCenter;
CRT_SettingsDelegate *CRT_SettingsDelegate_instance;

void notification(NSString* _id,NSString* title,NSString* text,
                  dispatch_block_t action,unsigned int ttl)
{
    if (_id==nil){return;}
    if(CRT_NotificationCenter==nil)
    {
        if(CRT_SettingsDelegate_instance==nil){return;}
        CRT_NotificationCenter=[NSUserNotificationCenter defaultUserNotificationCenter];
        [CRT_NotificationCenter setDelegate:CRT_SettingsDelegate_instance];
    }
    NSUserNotification* a = [NSUserNotification new];
    a.identifier=_id;
    if(title!=nil){a.title=title;}
    if(text!=nil){a.informativeText=text;}
    a.soundName = NSUserNotificationDefaultSoundName;
    if(action!=nil)
    {
        if(UserNotificationsActions==nil)
        {UserNotificationsActions=[NSMutableDictionary new];}
        [UserNotificationsActions setObject:action forKey:a.identifier];
    }
    if(UserNotificationsTTL==nil)
    {UserNotificationsTTL=[NSMutableDictionary new];}
    [UserNotificationsTTL setObject:[NSNumber numberWithUnsignedInt:ttl]
                             forKey:a.identifier];
    [CRT_NotificationCenter deliverNotification:a];
}


BOOL checkBoxSelected(NSButton*cb){return ([cb state]==NSOnState);}
NSNumber* checkBoxSelected_ns(NSButton*cb){return [NSNumber numberWithBool:checkBoxSelected(cb)];}
void setCheckBox(NSButton*cb,BOOL selected)
{
    if (selected){[cb setState:NSOnState];}
    else{[cb setState:NSOffState];}
}
void setCheckBox_ns(NSButton*cb,NSNumber*selected){setCheckBox(cb, [selected boolValue]);}
-(id) init
{@autoreleasepool{@synchronized(CRT_SettingsDelegate_instance){
    if(!(self =[super init]))
        return nil;
    if(CRT_SettingsDelegate_instance!=nil){NSLog(@"%s error: second singleton instance!",__PRETTY_FUNCTION__);return nil;}
    CRT_SettingsDelegate_instance=self;
    settingsDict=[[self class] loadSettingsFromFile:[[[self class] class] SettingsJSONFile]];
    if(settingsDict==nil)
        settingsDict=[[[self class] defaultSettings] mutableCopy];
    [[self class]fixMissingKeys];
    [settingsDict setObject:[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"]forKey:kVersion];
    if([[settingsDict objectForKey:kAutoupdate]boolValue]){[self checkForUpdate:[self class]];}
    [[self class] saveSettingsToFile:[[self class] SettingsJSONFile]];
    return self;
}}}
-(IBAction)checkForUpdate:(id)sender
{dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{@autoreleasepool{
    checkForUpdatesNow.enabled=NO;
    BOOL upd=[Updater updateNeededForVersion:[settingsDict objectForKey:kVersion]];
    if(upd)
    {
        if (![Updater update])
        {
            notification(@"update_failed",@"Update failed!",@"Try again later.",nil,20);
        }
    }
    else
    {
        if(sender!=[self class])
        {
            notification(@"no_updates_foundNSString* _id,",@"No updates found!",@"You are usilg the latest version of CRT!",nil,20);
        }
    }
    checkForUpdatesNow.enabled=YES;
}});}
+(void) fixMissingKeys
{@autoreleasepool{
    NSDictionary *d=[self defaultSettings];
    for (id key in d)
    {
        if([settingsDict objectForKey:key]==nil)
        {
            [settingsDict setObject:[d objectForKey:key] forKey:key];
        }
    }
}}
-(IBAction)importScreenSharingServers:(id)sender
{
    if([[settingsDict objectForKey:kScreenSharingOnly]boolValue]){return;}
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
    ^{@autoreleasepool{
        NSArray *screenSharingServers=[ScreenSharingImporter ScreenSharingConnections];
        if(screenSharingServers==nil)
        {
            [CRT_SettingsDelegate setObject:@NO forKey:kScreenSharingImported];
            return;
        }
        [CRT_SettingsDelegate setObject:@YES forKey:kScreenSharingImported];
        [servers addArray:screenSharingServers];
        [crtDelegate SaveAllServers:self];
        [window close];
    }});
}
+(NSDictionary*) defaultSettings
{
    NSDictionary *res=[NSDictionary dictionaryWithObjectsAndKeys:
                       [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],kVersion,
                       @YES,kAutoupdate,@"http://sr3u.16mb.com/app_updates/CRT/updateinfo.json",kUpdateInfoURL,
                       @NO,kScreenSharingOnly,[self getSystemUUID],kUUID,
                       //@1,@"dblClickAction",
                       nil];
    return res;
}
+(NSString*)SettingsJSONFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* str=[[fileManager applicationSupportDirectory] stringByAppendingString:@"/Settings.json"];
    if (![fileManager fileExistsAtPath:str])
    {
        [fileManager createFileAtPath:str contents:nil attributes:nil];
    }
    return str;
}
+(NSMutableDictionary*) loadSettingsFromFile:(NSString*)fileName
{@autoreleasepool{
    NSMutableDictionary* newSettingsDict;
    NSError* err=nil;
    NSString* JSONString=[NSString stringWithContentsOfFile:fileName
                                   encoding:NSUTF8StringEncoding error:&err];    
    if(err!=nil){NSLog(@"Failed to load settings!\nERROR:\n%@",err);return nil;}
    if([JSONString isEqual:@""])
        return nil;
    newSettingsDict=[NSMutableDictionary dictionaryWithJSONString:JSONString];
    if([newSettingsDict objectForKey:kVersion]==nil){return nil;}
    return newSettingsDict;
}}
+(void) saveSettingsToFile:(NSString*)fileName
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
    ^{@autoreleasepool{
        if([settingsDict isEqual:[[self class] loadSettingsFromFile:[[self class] SettingsJSONFile]]])
            return;
        NSString *JSONString=[settingsDict jsonStringWithPrettyPrint:YES];
        NSError *err=nil;
        [JSONString writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:&err];
        if (err!=nil){NSLog(@"Failed to save settings!\nERROR:\n%@",err);}

    }});
}
-(void) refreshUI
{
#if APPSTORE_BUILD
    checkForUpdatesNow.hidden=YES; autoupdate.hidden=YES;
#endif
    setCheckBox(autoupdate,[[settingsDict objectForKey:kAutoupdate]boolValue]);
    setCheckBox(screenSharingOnly,[[settingsDict objectForKey:kScreenSharingOnly]boolValue]);
    importFromScreenSharing.hidden=[[settingsDict objectForKey:kScreenSharingOnly]boolValue];
}
-(void) refreshSettings
{
    [settingsDict setObject:checkBoxSelected_ns(autoupdate) forKey:kAutoupdate];
    [settingsDict setObject:checkBoxSelected_ns(screenSharingOnly) forKey:kScreenSharingOnly];
}
+(void) setObject:(id)val forKey:(id)key
{
    if(![[settingsDict objectForKey:key] isEqualTo:val])
    {
        [settingsDict setObject:val forKey:key];
        [[self class] saveSettingsToFile:[[self class]SettingsJSONFile]];
        [CRT_SettingsDelegate_instance refreshUI];
    }
}
+(id) objectForKey:(id)key;
{
    return [settingsDict objectForKey:key];
}
+(NSDictionary*) getSettings
{
    return settingsDict;
}
-(BOOL)windowShouldClose:(id)sender
{
    [self refreshSettings];
    [[self class] saveSettingsToFile:[[self class] SettingsJSONFile]];
    [crtDelegate OpenPanel:sender];
    [crtDelegate Update];
    return YES;
}
- (void)awakeFromNib
{
    [self refreshUI];
    if([settingsDict objectForKey:kScreenSharingImported]==nil){[self importScreenSharingServers:self];}
}
-(IBAction)refreshUI:(id)sender
{
    [self refreshSettings];
    [self refreshUI];
}
+(NSString *)getSystemUUID
{@autoreleasepool{
#if APPSTORE_BUILD
    return @"";
#else
    io_service_t platformExpert=IOServiceGetMatchingService(kIOMasterPortDefault,
                                                            IOServiceMatching("IOPlatformExpertDevice"));
    if (!platformExpert)
        return nil;
    CFTypeRef serialNumberAsCFString=IORegistryEntryCreateCFProperty(platformExpert,CFSTR(kIOPlatformUUIDKey),
                                                                     kCFAllocatorDefault, 0);
    if (!serialNumberAsCFString)
        return nil;
    IOObjectRelease(platformExpert);
    return(__bridge NSString*)(serialNumberAsCFString);
#endif
}}
- (BOOL)userNotificationCenter:(id)userNotificationCenter shouldPresentNotification:(id)notification
{
    dispatch_async(dispatch_get_global_queue(0,0),^{@autoreleasepool{
        NSUserNotification*n=notification;
        NSNumber *TTL=[UserNotificationsTTL objectForKey:n.identifier];
        if(TTL!=nil)
        {
            unsigned int ttl=[TTL unsignedIntValue];
            if(ttl>0)
            {
                sleep(ttl);
                NSUserNotificationCenter *nc=userNotificationCenter;
                [nc removeDeliveredNotification:n];
            }
        }
    }});
    return YES;
}
- (void)userNotificationCenter:(id)userNotificationCenter didActivateNotification:(id)notification
{
    if([notification isKindOfClass:[NSUserNotification class]])
    {
        NSUserNotification *n=notification;
        dispatch_block_t action=[UserNotificationsActions objectForKey:n.identifier];
        if(action!=nil){dispatch_async(dispatch_get_global_queue(0,0),action);}
        [UserNotificationsActions removeObjectForKey:n.identifier];
        NSUserNotificationCenter *nc=userNotificationCenter;
        [nc removeDeliveredNotification:notification];
    }
}
-(void)userNotificationCenter:(id)userNotificationCenter didDeliverNotification:(id)notification{}
+(void) appWillTerminate
{
    [CRT_NotificationCenter removeAllDeliveredNotifications];
}
@end
