//
//  TableData.m
//  CRT
//
//  Created by SR3u on 20.01.14.
//  Copyright (c) 2014 SR3u. All rights reserved.
//

#import "ScreenSharingImporter.h"
#import "NSFileManager+DirectoryLocations.h"
#import "jsonTools.h"
#import "TableRow.h"
@implementation ScreenSharingImporter
+(NSArray*) ScreenSharingConnections_fromFolder:(NSString*)dir
{@autoreleasepool{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *files = [manager contentsOfDirectoryAtPath:dir
                                                  error:&error];
    if(error!=nil){NSLog(@"%s error: %@",__PRETTY_FUNCTION__,error.localizedDescription);return nil;}
    NSMutableArray *arr=[NSMutableArray new];
    if([files count]==0){return arr;}
    for(NSString *file in files)
    {@autoreleasepool{
        TableRow* t=[self parseScreenSharingServer:file fromDirectory:dir];
        if(t!=nil){[arr addObject:t];}
    }}
    return arr;
}}
+(NSArray*) ScreenSharingConnections
{
    NSFileManager *fm=[NSFileManager defaultManager];
    NSString *applicationSupport=[fm applicationSupportDirectory];
    NSArray *sarr=[applicationSupport componentsSeparatedByString:@"/"];
    applicationSupport=[NSString new];
    for(NSUInteger i=0;i<[sarr count]-1;i++)
    {
        applicationSupport=[applicationSupport stringByAppendingString:[sarr objectAtIndex:i]];
        applicationSupport=[applicationSupport stringByAppendingString:@"/"];
    }
    NSString *ScreenSharingDir=[applicationSupport stringByAppendingString:@"Screen Sharing/"];
    BOOL dir=NO;
    if(![fm fileExistsAtPath:ScreenSharingDir isDirectory:&dir]){return nil;}
    if (!dir){return nil;}
    NSArray *arr=[self ScreenSharingConnections_fromFolder:ScreenSharingDir];
    return arr;
}

+(TableRow*)parseScreenSharingServer:(NSString*)file fromDirectory:(NSString*)dir
{@autoreleasepool{
    NSString* path=[dir stringByAppendingString:file];
    NSDictionary *d=[NSDictionary dictionaryWithContentsOfFile:path];
    NSString *url=[d objectForKey:@"URL"];
    NSString *name=file;
    if(name==nil){return nil;}
    if(url==nil){return nil;}
    TableRow *res=[TableRow new];
    [res setName:name];
    [res setAddress:url];
    return res;
}}
+(NSString*) kImported{return @"Screen Sharing servers imported";}
@end
