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

@implementation CRT_SettingsDelegate

-(id) init
{
    if(!(self=[super init]))
        return nil;
    [self loadSettingsFromFile:[self SettingsJSONFile]];
    if(settingsDict==nil)
        settingsDict=[[self defaultSettings] mutableCopy];
    [settingsDict setObject:[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"]forKey:@"version"];
    [self saveSettingsToFile:[self SettingsJSONFile]];
    return self;
}
-(NSDictionary*) defaultSettings
{
    NSDictionary *res=[NSDictionary dictionaryWithObjectsAndKeys:
                       [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],@"version",
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
-(NSDictionary*) loadSettingsFromFile:(NSString*)fileName
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
}
-(void) refreshSettings
{
    //[settingsDict setObject:[NSNumber numberWithInteger:[dblClickAction indexOfSelectedItem]] forKey:@"dblClickAction"];
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
