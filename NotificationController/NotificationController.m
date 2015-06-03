//
//  NotificationController.m
//  CRT
//
//  Created by Sergey Rump on 03.06.15.
//
//
#import "NotificationController.h"
@implementation NotificationController
NotificationController* NotificationController_instance;
-(id) init
{@autoreleasepool{@synchronized(NotificationController_instance){
    if(!(self =[super init]))
        return nil;
    if(NotificationController_instance!=nil){NSLog(@"%s error: second singleton instance!",__PRETTY_FUNCTION__);return nil;}
    NotificationController_instance=self;
    return self;
}}}
+(NotificationController*)instance
{
    if(NotificationController_instance==nil)
    {
        NotificationController_instance=[NotificationController new];
    }
    return NotificationController_instance;
}
-(void) notificationWithId:(NSString*)_id
                     title:(NSString*)title
                      text:(NSString*)text
                    action:(dispatch_block_t)action
                       ttl:(unsigned int) ttl
{
    if (_id==nil){return;}
    if(_userNotificationCenter==nil)
    {
        _userNotificationCenter=[NSUserNotificationCenter defaultUserNotificationCenter];
        [_userNotificationCenter setDelegate:self];
    }
    NSUserNotification* a = [NSUserNotification new];
    a.identifier=_id;
    if(title!=nil){a.title=title;}
    if(text!=nil){a.informativeText=text;}
    a.soundName = NSUserNotificationDefaultSoundName;
    if(action!=nil)
    {
        if(_userNotificationsActions==nil)
        {_userNotificationsActions=[NSMutableDictionary new];}
        [_userNotificationsActions setObject:action forKey:a.identifier];
    }
    if(_userNotificationsTTL==nil)
    {_userNotificationsTTL=[NSMutableDictionary new];}
    [_userNotificationsTTL setObject:[NSNumber numberWithUnsignedInt:ttl]
                             forKey:a.identifier];
    [_userNotificationCenter deliverNotification:a];
}
-(BOOL)userNotificationCenter:(id)userNotificationCenter shouldPresentNotification:(id)notification
{
    dispatch_async(dispatch_get_global_queue(0,0),^{@autoreleasepool{
        NSUserNotification*n=notification;
        NSNumber *TTL=[_userNotificationsTTL objectForKey:n.identifier];
        if(TTL!=nil)
        {
            unsigned int ttl=[TTL unsignedIntValue];
            if(ttl>0)
            {
                sleep(ttl);
                NSUserNotificationCenter *nc=userNotificationCenter;
                [nc removeDeliveredNotification:n];
            }
        }
    }});
    return YES;
}
-(void)userNotificationCenter:(id)userNotificationCenter didActivateNotification:(id)notification
{
    if([notification isKindOfClass:[NSUserNotification class]])
    {
        NSUserNotification *n=notification;
        dispatch_block_t action=[_userNotificationsActions objectForKey:n.identifier];
        if(action!=nil){dispatch_async(dispatch_get_global_queue(0,0),action);}
        [_userNotificationsActions removeObjectForKey:n.identifier];
        NSUserNotificationCenter *nc=userNotificationCenter;
        [nc removeDeliveredNotification:notification];
    }
}
-(void)userNotificationCenter:(id)userNotificationCenter didDeliverNotification:(id)notification{}

-(void) appWillTerminate
{
    [_userNotificationCenter removeAllDeliveredNotifications];
}

+(void) appWillTerminate
{
    [[self instance] appWillTerminate];
}
+(void) notificationWithId:(NSString*)_id
                     title:(NSString*)title
                      text:(NSString*)text
                    action:(dispatch_block_t)action
                       ttl:(unsigned int) ttl
{
    [[self instance] notificationWithId:_id title:title text:text action:action ttl:ttl];
}

@end