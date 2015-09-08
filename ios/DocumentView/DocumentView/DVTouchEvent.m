//
//  DVTouchEvent.m
//  DocumentView
//
//  Created by ZhangHailong on 15/9/8.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import "DVTouchEvent.h"
#import "DVLayoutElement.h"

@implementation DVTouchEvent

+(id) touchEvent:(NSString *) touchId touchX:(CGFloat) touchX touchY:(CGFloat) touchY eventType:(enum DVTouchEventType) eventType element:(DVElement *) element {
    
    DVTouchEvent * event = [[DVTouchEvent alloc] init];
    
    event.touchId = touchId;
    event.touchX = touchX;
    event.touchY = touchY;
    event.target = element;
    event.eventType = eventType;
    
    return event;
}

-(CGPoint) locationInElement:(DVElement *) element {
    
    if(element == nil || element == self.target) {
        return CGPointMake(_touchX, _touchY);
    }
    
    if([element isKindOfClass:[DVLayoutElement class]]) {
        
        CGPoint p = [self locationInElement:element.parent];
        
        CGRect frame = [(DVLayoutElement *) element frame];
        
        return CGPointMake(p.x - frame.origin.x, p.y - frame.origin.y);
        
    }
    else {
        return [self locationInElement:element.parent];
    }
    
}

@end
