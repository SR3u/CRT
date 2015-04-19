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

@implementation CRT_SettingsDelegate
NSMutableDictionary* settingsDict;
CRT_SettingsDelegate *CRT_SettingsDelegate_instance;
-(id) init
{@autoreleasepool{@synchronized(CRT_SettingsDelegate_instance){
    if(!(self =[super init]))
        return nil;
    if(CRT_SettingsDelegate_instance!=nil){NSLog(@"%s error: second singleton instance!",__PRETTY_FUNCTION__);return nil;}
    CRT_SettingsDelegate_instance=self;
    settingsDict=[[self class] loadSettingsFromFile:[[[self class] class] SettingsJSONFile]];
    if(settingsDict==nil)
        settingsDict=[[[self class] defaultSettings] mutableCopy];
    [settingsDict setObject:[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"]forKey:@"version"];
    if([[settingsDict objectForKey:@"autoupdate"]boolValue]){[self checkForUpdate:[self class]];}
    [[self class] saveSettingsToFile:[[self class] SettingsJSONFile]];
    return self;
}}}
-(IBAction)checkForUpdate:(id)sender
{dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{@autoreleasepool{
    BOOL upd=[Updater updateNeededForVersion:[settingsDict objectForKey:@"version"]];
    if(upd){[Updater update];}
    else
    {
        if(sender!=[self class])
        {
            NSAlert* confirmAlert = [NSAlert alertWithMessageText:@"No updates found!"
                                                    defaultButton:@"OK"
                                                  alternateButton:nil
                                                      otherButton:nil
                                        informativeTextWithFormat:@"You are usilg the latest version of CRT!"];
            dispatch_async(dispatch_get_main_queue(),^{[confirmAlert runModal];});
        }
    }
}});}
+(NSDictionary*) defaultSettings
{
    NSDictionary *res=[NSDictionary dictionaryWithObjectsAndKeys:
                       [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],@"version",
                       @YES,@"autoupdate",@"http://sr3u.16mb.com/app_updates/CRT/updateinfo.json",@"updateInfoURL",
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
    if([newSettingsDict objectForKey:@"version"]==nil){return nil;}
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
   //[dblClickAction selectItemAtIndex:[[settingsDict objectForKey:@"dblClickAction"] integerValue]];
    if([[settingsDict objectForKey:@"autoupdate"]boolValue]){[autoupdate setState:NSOnState];}
    else{[autoupdate setState:NSOffState];}
}
-(void) refreshSettings
{
    //[settingsDict setObject:[NSNumber numberWithInteger:[dblClickAction indexOfSelectedItem]] forKey:@"dblClickAction"];
    if([autoupdate state]==NSOnState){[settingsDict setObject:@YES forKey:@"autoupdate"];}
    else{[settingsDict setObject:@NO forKey:@"autoupdate"];}
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
+(NSDictionary*) getSettings
{
    return settingsDict;
}
-(BOOL)windowShouldClose:(id)sender
{
    [self refreshSettings];
    [[self class] saveSettingsToFile:[[self class] SettingsJSONFile]];
    [crtDelegate OpenPanel:sender];
    return YES;
}
- (void)awakeFromNib
{
    [self refreshUI];
}
@end
