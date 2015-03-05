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
    if (data==nil)
    {
        return 0;
    }
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
   // NSLog(@"%i",[data writeToFile:FileName atomically:NO]);
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey: @"nokey" ascending: YES];
    [table setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey: @"servername" ascending: YES];
    [table setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSData *Data = [NSKeyedArchiver archivedDataWithRootObject:data];
    [Data writeToFile:FileName options:NSDataWritingAtomic error:nil];
}
-(void)loadFromFile:(NSString*)FileName
{
    data=[NSKeyedUnarchiver unarchiveObjectWithFile:FileName];
    if (data == nil)
    {
        data=[NSMutableArray array];
    }
}

-(void)replaceObjectAtIndex:(NSInteger)index  withObject:(id)Obj
{
    if (index<0)
        return;
    [data replaceObjectAtIndex:index withObject:Obj];
}
-(TableRow*)objectAtIndex:(NSInteger)index
{
    if (index<0)
        return nil;
    return [data objectAtIndex:index];
}
-(void)removeObjectAtIndex:(NSInteger)index
{
    if (index<0)
        return;
    [data removeObjectAtIndex:index];
    [table reloadData];
}

@end
