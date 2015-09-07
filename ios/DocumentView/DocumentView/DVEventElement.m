//
//  DVEventElement.m
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import "DVEventElement.h"

@interface DVEventFunctionObject : NSObject

@property(nonatomic,strong) NSString * name;
@property(nonatomic,copy) DVEventFunction fn;
@property(nonatomic,weak) id delegate;

@end

@implementation DVEventFunctionObject

@end

@interface DVEventElement() {
    NSMutableArray * _functionObjects;
}

@end

@implementation DVEventElement

-(BOOL) dispatchEvent:(DVEvent *) event {
    return YES;
}

-(void) sendEvent:(DVEvent *) event {
    
    if(_functionObjects ){
        
        for (DVEventFunctionObject * fn in [NSArray arrayWithArray:_functionObjects]) {
            
            if([fn.name hasPrefix:event.name]) {
                
                if( ! fn.fn(event) ) {
                    break;
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

-(void) bind:(NSString *) name delegate:(id<DVEventDelegate>) delegate {
    
    DVEventFunctionObject * object = [[DVEventFunctionObject alloc] init];
    object.name = name;
    object.delegate = delegate;
    
    if(_functionObjects == nil) {
        _functionObjects = [[NSMutableArray alloc] initWithCapacity:4];
    }
    
    [_functionObjects addObject:object];

}

-(void) unbind:(NSString *) name delegate:(id<DVEventDelegate>) delegate {
    
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

+(DVElement *) dispatchEvent:(DVEvent *) event element:(DVElement *) element {
    
    if([element isKindOfClass:[DVEventElement class]]) {
        
        if([(DVEventElement *) element dispatchEvent:event]) {
           
            DVElement * p = element.lastChild, * r;
            
            while (p) {
                
                r = [DVEventElement dispatchEvent:event element:p];
                
                if(r) {
                    return r;
                }
                
                p = p.prevSibling;
            }
            
        }
        
        return element;
    }
    else {
        
        DVElement * p = element.lastChild, * r;
        
        while (p) {
            
            r = [DVEventElement dispatchEvent:event element:p];
            
            if(r) {
                return r;
            }
            
            p = p.prevSibling;
        }

    }
    
    return nil;
}


+(void) sendEvent:(DVEvent *) event element:(DVElement *) element {
    
    if([element isKindOfClass:[DVEventElement class]]) {
        
        [(DVEventElement *) element sendEvent:event];
        
    }
    
    if(element.parent && ! event.cancelBubble){
        [DVEventElement sendEvent:event element:element.parent];
    }
    
}

-(id) attr:(NSString *) key value:(NSString *) value {
    
    NSString * v = [self attr:key];
    
    if(v != value && ! [v isEqualToString:value]) {
        
        [super attr:key value:value];
        
        DVAttributeEvent * event = [DVAttributeEvent attributeEvent:self key:key value:v];
        
        [DVEventElement dispatchEvent:event element:self];
        [DVEventElement sendEvent:event element:self];
    }
    else {
        [super attr:key value:value];
    }
    
    return self;
}

@end

@implementation DVAttributeEvent

@synthesize key = _key;
@synthesize value = _value;

+(id) attributeEvent:(DVEventElement *)element key:(NSString *)key value:(NSString *)value {
    DVAttributeEvent * event = [[DVAttributeEvent alloc] init];
    event.name = @"attribute";
    event.element = element;
    event.key = key;
    event.value = value;
    return event;
}

@end
