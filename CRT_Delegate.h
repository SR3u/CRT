//
//  CRT_Delegate.h
//  Popup
//
//  Created by SR3u on 14.02.14.
//
//

#import "TableData.h"
#import "PanelController.h"
#import <Foundation/Foundation.h>

@interface CRT_Delegate : NSObject
{
    IBOutlet PanelController *MainPanelController;
    
    IBOutlet NSWindow *AddWindow;
    IBOutlet NSWindow *EditWindow;

    IBOutlet NSTextField *AddServerName;
    IBOutlet NSTextField *AddServerAddress;
    
    IBOutlet NSTextField *EditServerName;
    IBOutlet NSTextField *EditServerAddress;
    
    IBOutlet NSTableView *Table;
    IBOutlet TableData *Servers;
    
    IBOutlet NSWindow *SettingsWindow;
    IBOutlet NSTextField *Version,*Copyright;
    
    NSFileManager* FileManager;
    
    IBOutlet NSButton *addButton,*removeButton,*editButton;
}

- (IBAction)OpenAddWindow:(id)sender;
- (IBAction)OpenEditWindow:(id)sender;

- (IBAction)AddServer:(id)sender;
- (IBAction)SaveServer:(id)sender;

- (IBAction)AddConnectServer:(id)sender;
- (IBAction)SaveConnectServer:(id)sender;

- (IBAction)CloseAddWindow:(id)sender;
- (IBAction)CloseEditWindow:(id)sender;

- (IBAction)DeleteServer:(id)sender;

- (IBAction)Quit:(id)sender;

- (IBAction)OpenSettingsWindow:(id)sender;

- (IBAction)ClosePanel:(id)sender;
- (IBAction)OpenPanel:(id)sender;

-(IBAction)SaveAllServers:(id)sender;

-(void)awakeFromNib;
-(void)Update;
+(void)OpenActionWindow:(NSWindow*)ActionWindow;
@end
