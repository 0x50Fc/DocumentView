//
//  DVEvent.m
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import "DVEvent.h"
#import "DVLayoutElement.h"

@implementation NSObject(DVEvent)

-(BOOL) dispatcher:(DVEventDispatcher *)dispatcher event:(DVEvent *)event {
    return YES;
}

@end

@implementation DVEvent

+(id) eventWithName:(NSString *) name target:(DVEventDispatcher *) target {
    DVEvent * event = [[self alloc] init];
    event.name = name;
    event.target = target;
    return event;
}

@end

@interface DVEventFunctionObject : NSObject

@property(nonatomic,strong) NSString * name;
@property(nonatomic,copy) DVEventFunction fn;
@property(nonatomic,weak) id delegate;

@end

@implementation DVEventFunctionObject

@end

@interface DVEventDispatcher() {
    NSMutableArray * _functionObjects;
}

@end


@implementation DVEventDispatcher

-(BOOL) dispatchEvent:(DVEvent *) event {
    return YES;
}

-(void) sendEvent:(DVEvent *) event {
    
    if(_functionObjects && event.name ){
        
        for (DVEventFunctionObject * fn in [NSArray arrayWithArray:_functionObjects]) {
            
            if([fn.name hasPrefix:event.name]) {
                
                if(fn.fn) {
                    if( ! fn.fn(event) ) {
                        break;
                    }
                }
                else if(fn.delegate) {
                    if( ! [fn.delegate dispatcher:self event:event] ) {
                        break;
                    }
                }
            }
            
        }
    }
}

-(void) bind:(NSString *) name fn:(DVEventFunction) fn {
    
    DVEventFunctionObject * object = [[DVEventFunctionObject alloc] init];
    object.name = name;
    object.fn = fn;
    
    if(_functionObjects == nil) {
        _functionObjects = [[NSMutableArray alloc] initWithCapacity:4];
    }
    
    [_functionObjects addObject:object];
    
}

-(void) unbind:(NSString *) name fn:(DVEventFunction) fn {
    
    if(name == nil && fn == nil) {
        [_functionObjects removeAllObjects];
    }
    else {
        
        NSInteger i = 0;
        
        while(i < [_functionObjects count]) {
            
            DVEventFunctionObject * object = [_functionObjects objectAtIndex:i];
            
            if((name == nil || [object.name hasPrefix:name]) && (fn == nil || fn == object.fn)) {
                [_functionObjects removeObjectAtIndex:i];
                continue;
            }
            
            i ++;
        }
        
    }
}

-(void) bind:(NSString *) name delegate:(id) delegate {
    
    DVEventFunctionObject * object = [[DVEventFunctionObject alloc] init];
    object.name = name;
    object.delegate = delegate;
    
    if(_functionObjects == nil) {
        _functionObjects = [[NSMutableArray alloc] initWithCapacity:4];
    }
    
    [_functionObjects addObject:object];
    
}

-(void) unbind:(NSString *) name delegate:(id) delegate {
    
    if(name == nil && delegate == nil) {
        [_functionObjects removeAllObjects];
    }
    else {
        
        NSInteger i = 0;
        
        while(i < [_functionObjects count]) {
            
            DVEventFunctionObject * object = [_functionObjects objectAtIndex:i];
            
            if((name == nil || [object.name hasPrefix:name]) && (delegate == nil || delegate == object.delegate)) {
                [_functionObjects removeObjectAtIndex:i];
                continue;
            }
            
            i ++;
        }
        
    }
}


@end


