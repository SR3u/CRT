//
//  Updater.m
//  CRT
//
//  Created by SR3u on 17.04.15.
//
//

#import "Updater.h"
#import "jsonTools.h"
#import "NSFileManager+DirectoryLocations.h"
#import "CRT_SettingsDelegate.h"

@interface Updater()
@end
@implementation Updater
#if APPSTORE_BUILD
+(BOOL) updateNeededForVersion:(NSString*)curVersion{[CRT_SettingsDelegate setObject:@NO forKey:@"autoupdate"];return NO;}
+(BOOL) update{[CRT_SettingsDelegate setObject:@NO forKey:@"autoupdate"];return NO;}
#else
NSInteger responceYes=-NSModalResponseStop;
NSInteger responceNo=-NSModalResponseAbort;
NSInteger responceNever=-NSModalResponseContinue;

NSString *latestDevVersionInfoURL=@"https://bitbucket.org/SR3u/crt-vnc-client/raw/master/CRT/CRT-Info.plist";
NSString *updateInfoURL=@"https://bitbucket.org/SR3u/crt-vnc-client/raw/master/updateinfo.json";

NSString *latestVersionURL=nil;
NSString *latestVersion=nil;
NSString *currentVersion=nil;
NSString *updateScriptURL=nil;
NSString *appPath;

+(NSURL*) getUpdateInfoURL
{
    NSDictionary *settings=[CRT_SettingsDelegate getSettings];
    NSString*tmp=[settings objectForKey:@"updateInfoURL"];
    if(tmp==nil)
    {
        [CRT_SettingsDelegate setObject:updateInfoURL forKey:@"updateInfoURL"];
        return [NSURL URLWithString:updateInfoURL];
    }
    return [NSURL URLWithString:tmp];
}
+(BOOL) compareVersion:(NSString*)cVersion toVersion:(NSString*)nVersion
{
    if ([nVersion compare:cVersion options:NSNumericSearch] == NSOrderedDescending)
    {// cVersion is lower than the nVersion
        return YES;
    }
    return NO;
}
+(BOOL) updateNeededForVersion:(NSString*)curVersion
{@autoreleasepool{
    appPath=[[NSBundle mainBundle] bundlePath];
    if(appPath==nil){return NO;}
    NSString* defaultUpdateInfoURL=updateInfoURL;
    NSError *e;
    NSString *json=[NSString stringWithContentsOfURL:[[self class] getUpdateInfoURL] encoding:NSUTF8StringEncoding error:&e];
    if(e!=nil)
    {
        NSLog(@"%s error:%@\nRetrying...",__PRETTY_FUNCTION__,e);
        updateInfoURL=defaultUpdateInfoURL;
        json=[NSString stringWithContentsOfURL:[NSURL URLWithString:updateInfoURL] encoding:NSUTF8StringEncoding error:&e];
        if(e!=nil){NSLog(@"%s error:%@",__PRETTY_FUNCTION__,e);return NO;}
        [CRT_SettingsDelegate setObject:updateInfoURL forKey:@"updateInfoURL"];
    }
    if(json==nil){return NO;}
    NSDictionary *d=[NSDictionary dictionaryWithJSONString:json];
    if(d==nil)
    {
        NSLog(@"%s failed to get update info. Retrying...",__PRETTY_FUNCTION__);
        updateInfoURL=defaultUpdateInfoURL;
        json=[NSString stringWithContentsOfURL:[NSURL URLWithString:updateInfoURL] encoding:NSUTF8StringEncoding error:&e];
        if(e!=nil){NSLog(@"%s error:%@",__PRETTY_FUNCTION__,e);return NO;}
        [CRT_SettingsDelegate setObject:updateInfoURL forKey:@"updateInfoURL"];
        d=[NSDictionary dictionaryWithJSONString:json];
        if(d==nil){return NO;}
    }
    latestVersion=[d objectForKey:@"version"];
    if(latestVersion==nil){return NO;}
    currentVersion=curVersion;
    if([latestVersion isEqualToString:currentVersion]){return NO;}
    latestVersionURL=[d objectForKey:@"latestVersionURL"];
    updateScriptURL=[d objectForKey:@"updateScriptURL"];
    return [self compareVersion:currentVersion toVersion:latestVersion];
}}
+(NSString*) updateFolder
{@autoreleasepool{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* str=[[fileManager applicationSupportDirectory] stringByAppendingString:@"/Update"];
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
+(NSString*) updateZIP
{@autoreleasepool{
    return [[self updateFolder] stringByAppendingString:@"/update.zip"];
}}
+(NSString*) updateScript
{@autoreleasepool{
    return [[self updateFolder] stringByAppendingString:@"/update.sh"];
}}
+(NSString*) updateLog
{@autoreleasepool{
    return [[[NSFileManager defaultManager] applicationSupportDirectory] stringByAppendingString:@"/last_update.log"];
}}
+(BOOL) cleanUpdateFolder
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *dirToEmpty = [self updateFolder];
    NSError *error = nil;
    NSArray *files = [manager contentsOfDirectoryAtPath:dirToEmpty
                                                  error:&error];
    if(error!=nil){NSLog(@"%s error: %@",__PRETTY_FUNCTION__,error.localizedDescription);return NO;}
    for(NSString *file in files)
    {
        [manager removeItemAtPath:[dirToEmpty stringByAppendingPathComponent:file]
                            error:&error];
        if(error!=nil){NSLog(@"%s error: %@",__PRETTY_FUNCTION__,error.localizedDescription);return NO;}
    }
    return YES;
}
+(NSString*)appFolder
{@autoreleasepool{if(appPath==nil){return nil;}
    NSArray *arr=[appPath componentsSeparatedByString:@"/"];
    NSString *appFolder=@"";
    for(NSUInteger i=0;i<[arr count]-1;i++)
    {
        appFolder=[appFolder stringByAppendingString:[arr objectAtIndex:i]];
        appFolder=[appFolder stringByAppendingString:@"/"];
    }
    return appFolder;
}}
+(BOOL) update
{@autoreleasepool{
    if(latestVersionURL==nil){return NO;}
    if(latestVersion==nil){return NO;}
    if(currentVersion==nil){return NO;}
    if(updateScriptURL==nil){return NO;}
    if(appPath==nil){return NO;}
    [NotificationController notificationWithId:@"update"
                                         title: @"A new CRT update released!"
                                          text:[NSString stringWithFormat:@"New CRT version available: %@, you use: %@\nClick here to download",
                                                latestVersion,currentVersion]
                                        action:
    ^{
        NSURL *updateURL=[NSURL URLWithString:latestVersionURL];
        NSError *error;
        NSLog(@"%s Downloading update",__PRETTY_FUNCTION__);
        NSData *nextVersion=[NSData dataWithContentsOfURL:updateURL options:0 error:&error];
        if(error!=nil){NSLog(@"%s error: %@",__PRETTY_FUNCTION__,error.localizedDescription);return;}
        NSLog(@"%s Writting update to file",__PRETTY_FUNCTION__);
        [nextVersion writeToFile:[self updateZIP] options:NSDataWritingAtomic error:&error];
        if(error!=nil){NSLog(@"%s error: %@",__PRETTY_FUNCTION__,error.localizedDescription);return;}
        NSLog(@"%s Downloading update script",__PRETTY_FUNCTION__);
        NSString *updateScript=[NSString stringWithContentsOfURL:[NSURL URLWithString:updateScriptURL]
                                                        encoding:NSUTF8StringEncoding error:&error];
        if(error!=nil){NSLog(@"%s error: %@",__PRETTY_FUNCTION__,error.localizedDescription);return;}
        NSLog(@"%s Writting update script to file",__PRETTY_FUNCTION__);
        [updateScript writeToFile:[self updateScript] atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if(error!=nil){NSLog(@"%s error: %@",__PRETTY_FUNCTION__,error.localizedDescription);return;}
        NSLog(@"%s Executing update script",__PRETTY_FUNCTION__);
        NSString *cmd=[NSString stringWithFormat:@"chmod 0777 '%@'",[self updateScript]];
        int res=system([cmd cStringUsingEncoding:NSUTF8StringEncoding]);
        if(res!=0){NSLog(@"%s error: failed to chmod",__PRETTY_FUNCTION__);return;}
        cmd=[NSString stringWithFormat:@"'%@' '%@' '%@' '%@' '%@'",[self updateScript],
             currentVersion,latestVersion,appPath,[self appFolder]];
        res=system([cmd cStringUsingEncoding:NSUTF8StringEncoding]);
        if(res!=0){NSLog(@"%s error: failed to execute update script",__PRETTY_FUNCTION__);return;}
        NSLog(@"%s Removing old junk!",__PRETTY_FUNCTION__);
        if(![self cleanUpdateFolder]){NSLog(@"%s error: failed to clean up",__PRETTY_FUNCTION__);return;}
        NSLog(@"%s Update done!",__PRETTY_FUNCTION__);
        NSString* updatelog=[NSString stringWithContentsOfFile:[self updateLog] encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"update.log:\n %@",updatelog);
        [NotificationController notificationWithId:@"updated"
                                             title:@"CRT updated"
                                              text:@"To use new version click here.\nThis will restart CRT"
                                            action:^{[self restart];} ttl:30];
    }
                                           ttl:30];
    return YES;
}}
#endif //APPSTORE_BUILD
+(void) restart
{//restarting self
    NSTask *task = [NSTask new];
    NSMutableArray *args = [NSMutableArray array];
    [args addObject:@"-c"];
    [args addObject:[NSString stringWithFormat:@"open \"%@\"",[[NSBundle mainBundle] bundlePath]]];
    [task setLaunchPath:@"/bin/sh"];
    [task setArguments:args];
    [task launch];
    [NSApp terminate:nil];
}
@end