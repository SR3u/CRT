//
//  CRT_Delegate.h
//  Popup
//
//  Created by SR3u on 14.02.14.
//
//

#import "TableData.h"
#import <Foundation/Foundation.h>

@interface CRT_Delegate : NSObject
{
    IBOutlet NSWindow *AddWindow;
    IBOutlet NSWindow *EditWindow;

    IBOutlet NSTextField *AddServerName;
    IBOutlet NSTextField *AddServerAddress;
    
    IBOutlet NSTextField *EditServerName;
    IBOutlet NSTextField *EditServerAddress;
    
    IBOutlet NSTableView *Table;
    IBOutlet TableData *Servers;
    
    NSFileManager* FileManager;
}
- (IBAction)OpenAddWindow:(id)sender;
- (IBAction)OpenEditWindow:(id)sender;

- (IBAction)AddServer:(id)sender;
- (IBAction)SaveServer:(id)sender;

- (IBAction)AddConnectServer:(id)sender;
- (IBAction)SaveConnectServer:(id)sender;

- (IBAction)CloseAddWindow:(id)sender;
- (IBAction)CloseEditWindow:(id)sender;

- (IBAction)Quit:(id)sender;

- (id)init;
-(void)Init;
+(void)OpenActionWindow:(NSWindow*)ActionWindow;
@end
