//
//  jsonTools.h
//  JSON Tools
//
//  Created by SR3u on 14.04.15.
//  Copyright (c) 2015 SR3u. All rights reserved.
//

#import <Foundation/Foundation.h>

#define jsonTools_Default_prettyPrint NO
#define jsonTools_Default_encoding NSUTF8StringEncoding

@interface NSDictionary (jsonTools)
-(NSString*) jsonString;
-(NSString*) jsonStringWithPrettyPrint:(BOOL)prettyPrint;//prettyPrint means more human-readable
-(NSString*) jsonStringWithPrettyPrint:(BOOL) prettyPrint encoding:(NSStringEncoding)encoding;
-(NSString*) jsonStringWithEncoding:(NSStringEncoding)encoding;
+(NSDictionary*) dictionaryWithJSONString:(NSString*)jsonString;//all objects inside are NOT mutable
+(NSDictionary*) dictionaryWithJSONString:(NSString*)jsonString encoding:(NSStringEncoding)encoding;//all objects inside are NOT mutable
@end
@interface NSArray (jsonTools)
-(NSString*) jsonString;
-(NSString *)jsonStringWithPrettyPrint:(BOOL)prettyPrint;//prettyPrint means more human-readable
-(NSString*) jsonStringWithPrettyPrint:(BOOL) prettyPrint encoding:(NSStringEncoding)encoding;
-(NSString*) jsonStringWithEncoding:(NSStringEncoding)encoding;
+(NSArray*) arrayWithJSONString:(NSString*)jsonString;//all objects inside are NOT mutable
+(NSArray*) arrayWithJSONString:(NSString*)jsonString encoding:(NSStringEncoding)encoding;//all objects inside are NOT mutable
@end

@interface NSMutableDictionary (jsonTools)
+(NSMutableDictionary*) dictionaryWithJSONString:(NSString*)jsonString;//all objects inside are mutable
+(NSMutableDictionary*) dictionaryWithJSONString:(NSString*)jsonString encoding:(NSStringEncoding)encoding;//all objects inside are NOT mutable
@end
@interface NSMutableArray (jsonTools)
+(NSMutableArray*) arrayWithJSONString:(NSString*)jsonString;//all objects inside are mutable
+(NSMutableArray*) arrayWithJSONString:(NSString*)jsonString encoding:(NSStringEncoding)encoding;//all objects inside are mutable
@end

