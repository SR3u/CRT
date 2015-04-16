//
//  jsonTools.m
//  JSON Tools
//
//  Created by Sergey Rump on 14.04.15.
//  Copyright (c) 2015 SR3u. All rights reserved.
//

#import "jsonTools.h"

@implementation NSDictionary (jsonTools)
+(NSString*) jsonToolsVersion{return @"0.0.1";};
-(NSString*) jsonString{return [self jsonStringWithPrettyPrint:NO];}
-(NSString*) jsonStringWithPrettyPrint:(BOOL) prettyPrint
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:(NSJSONWritingOptions)    (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    if (! jsonData)
    {
        NSLog(@"jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
+(NSDictionary*) dictionaryWithJSONString:(NSString*) jsonString
{
    NSError* error;
    NSDictionary* res=[NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                     options:0
                                                       error:&error];
    if (error!=nil)
    {
        NSLog(@"dictionaryWithJSONString: error: %@", error.localizedDescription);
        return nil;
    }
    return res;
}
@end

@implementation NSArray (jsonTools)
+(NSString*) jsonToolsVersion{return @"0.0.1";};
-(NSString*) jsonString{return [self jsonStringWithPrettyPrint:NO];}
-(NSString*) jsonStringWithPrettyPrint:(BOOL) prettyPrint
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:(NSJSONWritingOptions) (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    if (! jsonData)
    {
        NSLog(@"jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"[]";
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
+(NSArray*) arrayWithJSONString:(NSString*) jsonString
{
    NSError* error;
    NSArray* res=[NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                 options:0
                                                   error:&error];
    if (error!=nil)
    {
        NSLog(@"arrayWithJSONString: error: %@", error.localizedDescription);
        return nil;
    }
    return res;
}
@end

@implementation NSMutableDictionary (jsonTools)
+(NSString*) jsonToolsVersion{return @"0.0.1";};

+(NSMutableDictionary*) dictionaryWithJSONString:(NSString*) jsonString
{
    NSError* error;
    NSMutableDictionary* res=[NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                        options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves
                                                               error:&error];
    if (error!=nil)
    {
        NSLog(@"dictionaryWithJSONString: error: %@", error.localizedDescription);
        return nil;
    }
    return res;
}
@end

@implementation NSMutableArray (jsonTools)
+(NSString*) jsonToolsVersion{return @"0.0.1";};
+(NSMutableArray*) arrayWithJSONString:(NSString*) jsonString
{
    NSError* error;
    NSMutableArray* res=[NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                 options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves
                                                   error:&error];
    if (error!=nil)
    {
        NSLog(@"arrayWithJSONString: error: %@", error.localizedDescription);
        return nil;
    }
    return res;
}
@end