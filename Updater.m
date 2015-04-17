//
//  Updater.m
//  CRT
//
//  Created by Sergey Rump on 17.04.15.
//
//

#import "Updater.h"
#import "jsonTools.h"
#import "PanelController.h"

@interface Updater()
@end
@implementation Updater
NSString *latestDevVersionInfoURL=@"https://bitbucket.org/SR3u/crt-vnc-client/raw/master/CRT/CRT-Info.plist";
NSString *updateInfoURL=@"http://sr3u.16mb.com/app_updates/CRT/updateinfo.json";

NSString *latestVersionURL=nil;
NSString *latestVersion=nil;
NSString *currentVersion=nil;

+(BOOL) updateNeededForVersion:(NSString*)curVersion
{@autoreleasepool{
    NSError *e;
    NSString *json=[NSString stringWithContentsOfURL:[NSURL URLWithString:updateInfoURL] encoding:NSUTF8StringEncoding error:&e];
    if(e!=nil){NSLog(@"%s error:%@",__PRETTY_FUNCTION__,e);return NO;}
    if(json==nil){return NO;}
    NSDictionary *d=[NSDictionary dictionaryWithJSONString:json];
    if(d==nil){return NO;}
    latestVersion=[d objectForKey:@"version"];
    if(latestVersion==nil){return NO;}
    currentVersion=curVersion;
    if([latestVersion isEqualToString:currentVersion]){return NO;}
    latestVersionURL=[d objectForKey:@"latestVersionURL"];
    return YES;
}}

+(BOOL) update
{@autoreleasepool{
    if(latestVersionURL==nil){return YES;}
    if(latestVersion==nil){return YES;}
    if(currentVersion==nil){return YES;}
    NSAlert* confirmAlert = [NSAlert alertWithMessageText:@"A new CRT update released!"
                                            defaultButton:@"Yes"//1
                                          alternateButton:@"No"//0
                                              otherButton:@"No and never ask again"//-1
                                informativeTextWithFormat:@"New CRT version available: %@, you use: %@\nDownload now?",
                                                          latestVersion,currentVersion];
    NSInteger res=[confirmAlert runModal];
    if (res==1)
    {dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        NSURL *updateURL=[NSURL URLWithString:latestVersionURL];
        if(![[NSWorkspace sharedWorkspace] openURL:updateURL])
            NSLog(@"Failed to open update url: %@",[updateURL description]);
    });}
    else if (res==-1)
    {
        return NO;
    }
    return YES;
}}
@end