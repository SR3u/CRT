//
//  NSMutableArray_NSMutableArray_TableRowExt.h
//  CRT
//
//  Created by Sergey Rump on 30.03.15.
//
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (TableRow)

-(void) setName:(NSString*)str;
-(void) setAddress:(NSString*)str;

-(NSString*) getName;
-(NSString*) getAddress;

@end
