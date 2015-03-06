//
//  CRT_SettingsDelegate.m
//  CRT
//
//  Created by SR3u on 17.02.14.
//
//

#import "CRT_SettingsDelegate.h"
#import "NSFileManager+DirectoryLocations.h"

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
{
    NSMutableDictionary* newSettingsDict;
    NSError* err=nil;
    NSString* JSONString=[NSString stringWithContentsOfFile:[self SettingsJSONFile]
                                   encoding:NSUTF8StringEncoding error:&err];    
    if(err!=nil){NSLog(@"Failed to load settings!\nERROR:\n%@",err);return nil;}
    if([JSONString isEqual:@""])
        return nil;
    NSData *jsonData=[JSONString dataUsingEncoding:NSUTF8StringEncoding];
    newSettingsDict=[[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil] mutableCopy];
    if([newSettingsDict objectForKey:@"version"]==nil){return nil;}
    return newSettingsDict;
}
-(void) saveSettingsToFile:(NSString*)fileName
{
    if([settingsDict isEqual:[self loadSettingsFromFile:[self SettingsJSONFile]]])
        return;
    NSData *dat=[NSJSONSerialization dataWithJSONObject:settingsDict options:0 error:nil];
    NSString *JSONString=[[NSString alloc]initWithData:dat encoding:NSUTF8StringEncoding];
    NSError *err=nil;
    [JSONString writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:&err];
    if (err!=nil){NSLog(@"Failed to save settings!\nERROR:\n%@",err);}
}
-(NSDictionary*) getSettings
{
    return settingsDict;
}
-(void)awakeFromNib
{
    
}
-(BOOL)windowShouldClose:(id)sender
{
    [self saveSettingsToFile:[self SettingsJSONFile]];
    return YES;
}
@end
