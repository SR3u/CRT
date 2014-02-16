//
//  TableRow.m
//  G_CMO
//
//  Created by SR3u on 20.01.14.
//  Copyright (c) 2014 SR3u. All rights reserved.
//

#import "TableRow.h"

@implementation TableRow
-(void) setName:(NSString*)str
{
    Name=[NSString stringWithString:str];
}
-(void) setAddress:(NSString*)str
{
    Address=[NSString stringWithString:str];
    //[self setValue:Event forKey:@"calevent"];
}
-(NSString*) getName
{
    return Name;
}
-(NSString*) getAddress
{
    return Address;
}
-(id) valueForKey:(NSString*)key
{
    if([key isEqualTo:@"servername"])
    {
        return [self getName];
    }
    if([key isEqualTo:@"serveraddress"])
    {
        return [self getAddress];
    }
    return NULL;
}
@end
