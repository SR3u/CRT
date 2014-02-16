//
//  TableData.m
//  G_CMO
//
//  Created by SR3u on 20.01.14.
//  Copyright (c) 2014 SR3u. All rights reserved.
//

#import "TableData.h"


@implementation TableData
-(void) add:(TableRow*)row
{
    [data addObject:row];
    [table reloadData];
    //NSLog(@"%@",data);
}
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [data count];
}
- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex;
{
    TableRow *r=[data objectAtIndex:rowIndex];
    NSString *identifier=[aTableColumn identifier];
    if([identifier isEqualTo:@"servername"])
    {
        return [r getName];
    }
    if([identifier isEqualTo:@"serveraddress"])
    {
        return [r getAddress];
    }
    return NULL;
    //return [r valueForKey:identifier];
}
- (void)tableView:(NSTableView *)aTableView sortDescriptorsDidChange:(NSArray *)oldDescriptors
{
    [data sortUsingDescriptors:[aTableView sortDescriptors]];
    [aTableView reloadData];
}

-(void)clear
{
    [data removeAllObjects];
}

-(void)saveToFile:(NSString*)FileName
{
    [data writeToFile:FileName atomically:YES];
}
-(void)loadFromFile:(NSString*)FileName
{
    data=[data initWithContentsOfFile:FileName];
}
@end
