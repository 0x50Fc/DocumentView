//
//  DVElement+Value.h
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import <DocumentView/DVElement.h>

@interface DVElement (Value)

+(double) dp;

-(NSString *) stringValueForKey:(NSString *) key defaultValue:(NSString *) defaultValue ;

-(double) doubleValueForKey:(NSString *) key defaultValue:(double) defaultValue ;

-(double) doubleValueForKey:(NSString *) key defaultValue:(double) defaultValue of:(double) of;

-(BOOL) booleanValueForKey:(NSString *) key defaultValue:(BOOL) defaultValue ;

-(int) intValueForKey:(NSString *) key defaultValue:(int) defaultValue ;

-(long long) longLongValueForKey:(NSString *) key defaultValue:(long long) defaultValue ;

-(UIColor *) colorValueForKey:(NSString *) key defaultValue:(UIColor *) defaultValue;

-(UIFont *) fontValueForKey:(NSString *) key defaultValue:(UIFont *) defaultValue;

-(UIEdgeInsets) edgeInsetsValueForKey:(NSString *) key defaultValue:(UIEdgeInsets) edgeInsets ;


@end
