//
//  TableRow.h
//  G_CMO
//
//  Created by SR3u on 20.01.14.
//  Copyright (c) 2014 SR3u. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableRow : NSObject
{
    NSString *Name;
    NSString *Address;
}
-(void) setName:(NSString*)str;
-(void) setAddress:(NSString*)str;
-(NSString*) getName;
-(NSString*) getAddress;
-(NSString*) valueForKey:(NSString*)key;
- (void)encodeWithCoder:(NSCoder *)encoder;
- (id)initWithCoder:(NSCoder *)decoder;

@end
