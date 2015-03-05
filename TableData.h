//
//  TableData.h
//  G_CMO
//
//  Created by SR3u on 20.01.14.
//  Copyright (c) 2014 SR3u. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableRow.h"
@interface TableData : NSObject
{
    IBOutlet NSMutableArray *data;
    IBOutlet NSTableView *table;
}
-(void) add:(TableRow*)row;
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView;
- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex;
- (void)tableView:(NSTableView *)aTableView sortDescriptorsDidChange:(NSArray *)oldDescriptors;
-(void)clear;
-(void)saveToFile:(NSString*)FileName;
-(void)loadFromFile:(NSString*)FileName;

-(void)removeObjectAtIndex:(NSInteger)index;
-(TableRow*)objectAtIndex:(NSInteger)index;
-(void)replaceObjectAtIndex:(NSInteger)index  withObject:(id)Obj;

@end
