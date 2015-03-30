//
//  NSMutableArray_NSMutableArray_TableRowExt.m
//  CRT
//
//  Created by Sergey Rump on 30.03.15.
//
//

#import "NSMutableDictionary+TableRowExt.h"
@implementation NSMutableDictionary (TableRow)

-(void) setName:(NSString*)str
{
    [self setObject:str forKey:@"servername"];
    [self setValue:str forKey:@"servername"];
}
-(void) setAddress:(NSString*)str
{
    [self setObject:str forKey:@"serveradress"];
    [self setValue:str forKey:@"serveradress"];
}

-(NSString*) getName
{
    return [self objectForKey:@"servername"];
}
-(NSString*) getAddress
{
    return [self objectForKey:@"serveradress"];
}
@end;