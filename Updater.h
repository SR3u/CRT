//
//  Updater.h
//  CRT
//
//  Created by SR3u on 17.04.15.
//
//
#import <Foundation/Foundation.h>
@interface Updater : NSObject
+(BOOL) updateNeededForVersion:(NSString*)curVersion;
+(BOOL) update;
@end