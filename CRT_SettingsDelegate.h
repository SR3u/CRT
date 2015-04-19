//
//  CRT_SettingsDelegate.h
//  CRT
//
//  Created by SR3u on 17.02.14.
//
//

#import <Foundation/Foundation.h>
#import "CRT_Delegate.h"
@interface CRT_SettingsDelegate : NSObject<NSWindowDelegate>
{
    IBOutlet NSWindow *window;
    IBOutlet NSTextView *Version;
    IBOutlet NSPopUpButton *dblClickAction;
    
    NSDictionary* defaultSettings;
    IBOutlet CRT_Delegate *crtDelegate;
    
    IBOutlet NSButton* autoupdate;
    IBOutlet TableData* servers;
}
+(NSDictionary*) getSettings;
+(void) setObject:(id)val forKey:(id)key;

-(id) init;

@end
