//
//  NotificationController.h
//  CRT
//
//  Created by Sergey Rump on 03.06.15.
//
//

#ifndef CRT_NotificationController_h
#define CRT_NotificationController_h
#import <Foundation/Foundation.h>

@interface NotificationController : NSObject<NSUserNotificationCenterDelegate>
@property NSMutableDictionary *userNotificationsActions;
@property NSMutableDictionary *userNotificationsTTL;
@property NSUserNotificationCenter *userNotificationCenter;

+(NotificationController*) instance;
-(id) init;
-(void) notificationWithId:(NSString*)_id
                     title:(NSString*)title
                      text:(NSString*)text
                    action:(dispatch_block_t)action
                       ttl:(unsigned int) ttl;

+(void) notificationWithId:(NSString*)_id
                     title:(NSString*)title
                      text:(NSString*)text
                    action:(dispatch_block_t)action
                       ttl:(unsigned int) ttl;

-(void) appWillTerminate;
+(void) appWillTerminate;
@end

#endif
