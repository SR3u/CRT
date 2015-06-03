//
//  CRT_SettingsDelegate.h
//  CRT
//
//  Created by SR3u on 17.02.14.
//
//

#import <Foundation/Foundation.h>
#import "CRT_Delegate.h"
#import "NotificationController/NotificationController.h"

static NSString * const kVersion=@"version";
static NSString * const kAutoupdate=@"autoupdate";
static NSString * const kUpdateInfoURL=@"updateInfoURL";
static NSString * const kScreenSharingOnly=@"ScreenSharingOnly";
static NSString * const kScreenSharingImported=@"Screen Sharing servers imported";
static NSString * const kUUID=@"UUID";

BOOL checkBoxSelected(NSButton*cb);
NSNumber* checkBoxSelected_ns(NSButton*cb);
void setCheckBox(NSButton*cb,BOOL selected);
void setCheckBox_ns(NSButton*cb,NSNumber*selected);


@interface CRT_SettingsDelegate : NSObject<NSWindowDelegate>
{
    IBOutlet NSWindow *window;
    IBOutlet NSTextView *Version;
    IBOutlet NSPopUpButton *dblClickAction;
    
    NSDictionary* defaultSettings;
    IBOutlet CRT_Delegate *crtDelegate;
    
    IBOutlet NSButton* autoupdate;
    IBOutlet TableData* servers;
    
    IBOutlet NSButton* screenSharingOnly;
    
    IBOutlet NSButton* importFromScreenSharing,*checkForUpdatesNow;
}
+(NSDictionary*) getSettings;
+(id) objectForKey:(id)key;
+(void) setObject:(id)val forKey:(id)key;

-(id) init;

+(void) appWillTerminate;
@end
