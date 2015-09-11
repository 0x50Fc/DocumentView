//
//  DVDocument.m
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import "DVDocument.h"

@interface DVDocument() {
    unsigned long long _elementId;
    NSMutableDictionary * _elementsById;
}

@end

@implementation DVDocument

@synthesize styleSheet = _styleSheet;

-(NSString *) newElementId {
    return [NSString stringWithFormat:@"e%llu", ++ _elementId];
}

-(DVStyleSheet *) styleSheet {
    if(_styleSheet == nil) {
        _styleSheet = [[DVStyleSheet alloc] init];
    }
    return _styleSheet;
}

// 创建节点
-(id) elementWithName:(NSString *) name attributes:(NSDictionary *) attributes elementId:(NSString *)elementId {
    
    Class elementClass = [self.styleSheet elementClass:[NSArray arrayWithObjects:@"*",name, nil]];
    
    if(elementClass == nil) {
        elementClass = [DVElement class];
    }
    
    if(elementId == nil){
        elementId = [self newElementId];
    }
    
    DVElement * el = [[elementClass alloc] initWithName:name attributes:attributes];
    
    el.elementId = elementId;
    
    if(_elementsById == nil) {
        _elementsById = [[NSMutableDictionary alloc] initWithCapacity:4];
    }
    
    [_elementsById setValue:el forKey:el.elementId];
    
    return el;
}

-(void) setRootElement:(DVElement *)rootElement {
    
    if(_rootElement != rootElement) {
        
        [_rootElement setDocument:nil];
        _rootElement = rootElement;
        [_rootElement setDocument:self];
        
        [self sendEvent:[DVEvent eventWithName:@"root" target:self]];
        
    }
    
}

-(DVElement *) elementById:(NSString *) elementId {
    return [_elementsById valueForKey:elementId];
}

@end
