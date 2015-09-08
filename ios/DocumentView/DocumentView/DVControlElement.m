//
//  DVControlElement.m
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import "DVControlElement.h"
#import "DVTouchEvent.h"
#import "DVElement+Value.h"

@implementation DVControlElement

@synthesize highlighted = _highlighted;

-(BOOL) dispatchEvent:(DVEvent *) event {
    
    if([event isKindOfClass:[DVTouchEvent class]]){
        
        if(! [self isEnabled]) {
            return NO;
        }
        
        CGRect frame = [self frame];
        CGPoint p = [(DVTouchEvent *) event locationInElement:self];
        frame.origin = CGPointZero;
        return CGRectContainsPoint(frame, p);
    }
    
    return YES;
}

-(void) sendEvent:(DVEvent *)event {
    
    if([event isKindOfClass:[DVTouchEvent class]]) {
        

        
        
        switch ([(DVTouchEvent *) event eventType]) {
            case DVTouchEventTypeBegin:
            case DVTouchEventTypeMoved:
            {
                CGRect rect = self.frame;
                
                rect.origin = CGPointZero;
                
                CGPoint p = [(DVTouchEvent *) event locationInElement:self];
                
                [self setHighlighted:CGRectContainsPoint(rect, p)];
            }
                break;
                
            default:
                [self setHighlighted:NO];
                break;
        }
        
    }
    
    [super sendEvent:event];
}


-(BOOL) isEnabled{
    return [self booleanValueForKey:@"enabled" defaultValue:YES] || ! [self booleanValueForKey:@"disabled" defaultValue:NO];
}

-(BOOL) isSelected {
    return [self booleanValueForKey:@"selected" defaultValue:NO];
}

-(id) attr:(NSString *) key value:(NSString *) value{
    [super attr:key value:value];
    
    if([key isEqualToString:@"enabled"]
       || [key isEqualToString:@"disabled"]
       || [key isEqualToString:@"selected"]
       || [key isEqualToString:@"class"]
       || [key isEqualToString:@"disabled-class"]
       || [key isEqualToString:@"highlighted-class"]
       || [key isEqualToString:@"selected-class"]){
        self.style = nil;
    }
    
    return self;
}

-(NSString *) className {
    
    if(! [self isEnabled]) {
        
        NSString * v = [self attr:@"disabled-class"];
        
        if(v){
            return v;
        }
    }
    
    if([self isHighlighted]) {
        
        NSString * v = [self attr:@"highlighted-class"];
        
        if(v){
            return v;
        }
        
    }
    
    if([self isSelected]) {
        
        NSString * v = [self attr:@"selected-class"];
        
        if(v){
            return v;
        }
        
    }
    
    return [super className];
}

-(void) setHighlighted:(BOOL)highlighted {
    if(_highlighted != highlighted) {
        _highlighted = highlighted;
        self.style = nil;
    }
}

@end
