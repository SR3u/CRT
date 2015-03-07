//
//  CRT_SettingsDelegate.h
//  CRT
//
//  Created by SR3u on 17.02.14.
//
//

#import <Foundation/Foundation.h>

@interface CRT_SettingsDelegate : NSObject<NSWindowDelegate>
{
    IBOutlet NSWindow *window;
    IBOutlet NSTextView *Version;
    IBOutlet NSPopUpButton *dblClickAction;
    
    NSMutableDictionary* settingsDict;
    NSDictionary* defaultSettings;
}
-(NSDictionary*) getSettings;

-(id) init;

@end
