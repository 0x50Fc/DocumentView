//
//  DVControlElement.m
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import "DVControlElement.h"

@implementation DVControlElement

-(BOOL) dispatchEvent:(DVEvent *) event {
    
    if([event isKindOfClass:[DVTouchEvent class]]){
        CGRect frame = [self frame];
        CGPoint p = [(DVTouchEvent *) event locationInElement:self];
        frame.origin = CGPointZero;
        return CGRectContainsPoint(frame, p);
    }
    
    return YES;
}

@end
