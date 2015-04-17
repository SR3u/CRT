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

-(id) init
{@autoreleasepool{
    if(!(self=[super init]))
        return nil;
    settingsDict=[self loadSettingsFromFile:[self SettingsJSONFile]];
    if(settingsDict==nil)
        settingsDict=[[self defaultSettings] mutableCopy];
    [settingsDict setObject:[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"]forKey:@"version"];
    if([[settingsDict objectForKey:@"autoupdate"]boolValue]){[self checkForUpdate:self];}
    [self saveSettingsToFile:[self SettingsJSONFile]];
    return self;
}}
-(IBAction)checkForUpdate:(id)sender
{
    if([Updater updateNeededForVersion:[settingsDict objectForKey:@"version"]])
        if([Updater update]==NO){[settingsDict setObject:@NO forKey:@"autoupdate"];}
    else
    {
        if(sender!=self)
        {
            NSAlert* confirmAlert = [NSAlert alertWithMessageText:@"No updates found!"
                                                    defaultButton:@"OK"
                                                  alternateButton:nil
                                                      otherButton:nil
                                        informativeTextWithFormat:@"You are usilg the latest version of CRT!"];
            [confirmAlert runModal];
        }
    }
}
-(NSDictionary*) defaultSettings
{
    NSDictionary *res=[NSDictionary dictionaryWithObjectsAndKeys:
                       [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],@"version",
                       @YES,@"autoupdate",
                       //@1,@"dblClickAction",
                       nil];
    return res;
}
-(NSString*)SettingsJSONFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* str=[[fileManager applicationSupportDirectory] stringByAppendingString:@"/Settings.json"];
    if (![fileManager fileExistsAtPath:str])
    {
        [fileManager createFileAtPath:str contents:nil attributes:nil];
    }
    return str;
}
-(NSMutableDictionary*) loadSettingsFromFile:(NSString*)fileName
{@autoreleasepool{
    NSMutableDictionary* newSettingsDict;
    NSError* err=nil;
    NSString* JSONString=[NSString stringWithContentsOfFile:[self SettingsJSONFile]
                                   encoding:NSUTF8StringEncoding error:&err];    
    if(err!=nil){NSLog(@"Failed to load settings!\nERROR:\n%@",err);return nil;}
    if([JSONString isEqual:@""])
        return nil;
    newSettingsDict=[NSMutableDictionary dictionaryWithJSONString:JSONString];
    if([newSettingsDict objectForKey:@"version"]==nil){return nil;}
    return newSettingsDict;
}}
-(void) saveSettingsToFile:(NSString*)fileName
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
    ^{@autoreleasepool{
        if([settingsDict isEqual:[self loadSettingsFromFile:[self SettingsJSONFile]]])
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

-(NSDictionary*) getSettings
{
    return settingsDict;
}
-(BOOL)windowShouldClose:(id)sender
{
    [self refreshSettings];
    [self saveSettingsToFile:[self SettingsJSONFile]];
    [crtDelegate OpenPanel:sender];
    return YES;
}
- (void)awakeFromNib
{
    [self refreshUI];
}
@end
