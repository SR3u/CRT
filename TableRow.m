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
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.getName forKey:@"servername"];
    [encoder encodeObject:self.getAddress forKey:@"serveraddress"];
}
- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    [self setName:[decoder decodeObjectForKey:@"servername"]];
    [self setAddress:[decoder decodeObjectForKey:@"serveraddress"]];
    return self;
}

@end
