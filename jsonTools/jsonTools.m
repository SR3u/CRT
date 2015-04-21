//
//  jsonTools.m
//  JSON Tools
//
//  Created by SR3u on 14.04.15.
//  Copyright (c)2015 SR3u. All rights reserved.
//

#import "jsonTools.h"

@implementation NSDictionary (jsonTools)
-(NSString*)jsonString{return [self jsonStringWithPrettyPrint:jsonTools_Default_prettyPrint];}
-(NSString*)jsonStringWithPrettyPrint:(BOOL)prettyPrint
{return [self jsonStringWithPrettyPrint:prettyPrint encoding:jsonTools_Default_encoding];}
-(NSString*)jsonStringWithPrettyPrint:(BOOL)prettyPrint encoding:(NSStringEncoding)encoding
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:(NSJSONWritingOptions)(prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    if (! jsonData)
    {
        NSLog(@"%s: error: %@",__PRETTY_FUNCTION__,error.localizedDescription);
        return @"{}";
    }
    return [[NSString alloc] initWithData:jsonData encoding:jsonTools_Default_encoding];
}
-(NSString*) jsonStringWithEncoding:(NSStringEncoding)encoding
{return [self jsonStringWithPrettyPrint:jsonTools_Default_prettyPrint encoding:encoding];}
+(NSDictionary*)dictionaryWithJSONString:(NSString*)jsonString
{return [self dictionaryWithJSONString:jsonString encoding:jsonTools_Default_encoding];}
+(NSDictionary*)dictionaryWithJSONString:(NSString*)jsonString encoding:(NSStringEncoding)encoding;
{
    NSError* error;
    NSDictionary* res=[NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:encoding]
                                                      options:0
                                                        error:&error];
    if (error!=nil)
    {
        NSLog(@"%s: error: %@",__PRETTY_FUNCTION__,error.localizedDescription);
        return nil;
    }
    return res;
}
@end

@implementation NSArray (jsonTools)
-(NSString*)jsonString{return [self jsonStringWithPrettyPrint:jsonTools_Default_prettyPrint];}
-(NSString*)jsonStringWithPrettyPrint:(BOOL)prettyPrint
{return [self jsonStringWithPrettyPrint:prettyPrint encoding:jsonTools_Default_encoding];}
-(NSString*)jsonStringWithPrettyPrint:(BOOL)prettyPrint encoding:(NSStringEncoding)encoding
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:(NSJSONWritingOptions)(prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    if (! jsonData)
    {
        NSLog(@"%s: error: %@",__PRETTY_FUNCTION__,error.localizedDescription);
        return @"[]";
    }
    return [[NSString alloc] initWithData:jsonData encoding:encoding];
}
-(NSString*) jsonStringWithEncoding:(NSStringEncoding)encoding
{return [self jsonStringWithPrettyPrint:jsonTools_Default_prettyPrint encoding:encoding];}
+(NSArray*)arrayWithJSONString:(NSString*)jsonString
{return [self arrayWithJSONString:jsonString encoding:jsonTools_Default_encoding];}
+(NSArray*)arrayWithJSONString:(NSString*)jsonString encoding:(NSStringEncoding)encoding
{
    NSError* error;
    NSArray* res=[NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:encoding]
                                                 options:0
                                                   error:&error];
    if (error!=nil)
    {
        NSLog(@"%s: error: %@",__PRETTY_FUNCTION__,error.localizedDescription);
        return nil;
    }
    return res;
}
@end

@implementation NSMutableDictionary (jsonTools)
+(NSMutableDictionary*)dictionaryWithJSONString:(NSString*)jsonString
{return [self dictionaryWithJSONString:jsonString encoding:jsonTools_Default_encoding];}
+(NSMutableDictionary*)dictionaryWithJSONString:(NSString*)jsonString encoding:(NSStringEncoding)encoding
{
    NSError* error;
    NSMutableDictionary* res=[NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:encoding]
                                        options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves
                                                               error:&error];
    if (error!=nil)
    {
        NSLog(@"%s: error: %@",__PRETTY_FUNCTION__,error.localizedDescription);
        return nil;
    }
    return res;
}
@end

@implementation NSMutableArray (jsonTools)
+(NSMutableArray*)arrayWithJSONString:(NSString*)jsonString
{return [self arrayWithJSONString:jsonString encoding:jsonTools_Default_encoding];}
+(NSMutableArray*)arrayWithJSONString:(NSString*)jsonString encoding:(NSStringEncoding)encoding
{
    NSError* error;
    NSMutableArray* res=[NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:encoding]
                                                 options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves
                                                   error:&error];
    if (error!=nil)
    {
        NSLog(@"%s: error: %@",__PRETTY_FUNCTION__,error.localizedDescription);
        return nil;
    }
    return res;
}
@end