//
//  DVObjectElement.m
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import "DVObjectElement.h"
#import "DVElement+Value.h"

@implementation DVObjectElement

-(Class) objectClass {
    NSString * v = [self stringValueForKey:@"object-class" defaultValue:nil];
    if([v length]) {
        return NSClassFromString(v);
    }
    return nil;
}

-(void) bindObject:(id)object {
    [object setObjectElement:self];
}

-(BOOL) isDetachChildren {
    return NO;
}

@end


@implementation NSObject (DVObjectElement)

-(void) setObjectElement:(DVObjectElement *)element {
    
}

@end
