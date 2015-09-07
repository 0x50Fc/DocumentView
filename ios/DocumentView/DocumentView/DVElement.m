//
//  DVElement.m
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import "DVElement.h"
#import "DVDocument.h"
#import "DVStyle.h"

@interface DVElement() {
    NSMutableDictionary * _attributes;
}

@end

@implementation DVElement

@synthesize style = _style;
@synthesize document = _document;

- (void) encodeWithCoder:(NSCoder *)aCoder {

    [aCoder encodeObject:self.elementId forKey:@"elementId"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.textContent forKey:@"textContent"];
    [aCoder encodeObject:_attributes forKey:@"attributes"];
    [aCoder encodeObject:[self children] forKey:@"children"];
    
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    
    if((self = [super init])) {
        
        self.elementId = [aDecoder decodeObjectForKey:@"elementId"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.textContent = [aDecoder decodeObjectForKey:@"textContent"];
        _attributes = [aDecoder decodeObjectForKey:@"attributes"];
        
        NSArray * children = [aDecoder decodeObjectForKey:@"children"];
        
        for (DVElement * el in children) {
            [self append:el];
        }
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    
    DVElement * el = [[[self class] alloc] initWithName: self.name attributes:_attributes];
    
    el.textContent = self.textContent;
    
    DVElement * p = self.firstChild;
    
    while (p) {
        
        [el append:[p copyWithZone:zone]];
        
        p = p.nextSibling;
    }
    
    return el;
}


// 创建节点
-(id) initWithName:(NSString *) name attributes:(NSDictionary *) attributes {
    
    if((self = [super init])) {
        
        self.name = name;

        if(attributes) {
            _attributes = [[NSMutableDictionary alloc] initWithDictionary:attributes];
        }
        
    }
    
    return self;
}


// 创建节点
+(id) elementWithName:(NSString *) name attributes:(NSDictionary *) attributes {
    return [[self alloc] initWithName: name attributes:attributes];
}

// 获取属性
-(NSString *) attr:(NSString *) key {
    return [_attributes valueForKey:key];
}

// 设置属性 value==nil 时删除属性
-(id) attr:(NSString *) key value:(NSString *) value {
    
    if([@"style" isEqualToString:key]) {
        _style = nil;
    }
    else if([@"class" isEqualToString:key]) {
        _style.parent = nil;
    }
    
    if(value == nil) {
        [_attributes removeObjectForKey:key];
    }
    else {
        if(_attributes == nil) {
            _attributes = [[NSMutableDictionary alloc] initWithCapacity:4];
        }
        [_attributes setValue:value forKey:key];
    }
    
    return self;
    
}

-(NSArray *) keys {
    return [_attributes allKeys];
}

-(NSArray *) children {
    
    NSMutableArray * children = [NSMutableArray arrayWithCapacity:4];
    
    DVElement * p = self.firstChild;
    
    while (p) {
        
        [children addObject:p];
        
        p = p.nextSibling;
    }
    
    return children;
}

// 添加子节点 element
-(id) append:(DVElement *) element {
    
    if(element == nil) {
        return self;
    }
    
    [element remove];
    
    if(_lastChild) {
        _lastChild->_nextSibling = element;
        element->_prevSibling = _lastChild;
        _lastChild = element;
    }
    else {
        _firstChild = element;
        _lastChild = element;
    }
    
    element->_document = _document;
    element->_parent = self;
    
    return self;
}

// 作为子节点添加到 element
-(id) appendTo:(DVElement *) element {
    
    if(element == nil) {
        return self;
    }
    
    [element append:self];
    
    return self;
}

// 将 element 添加到当前节点上面
-(id) before:(DVElement *) element {
    
    if(element == nil) {
        return self;
    }
    
    [element remove];
    
    if(_parent) {
        
        element->_document = _document;
        element->_parent = _parent;

        if(_prevSibling) {
            _prevSibling->_nextSibling = element;
            element->_prevSibling = _prevSibling;
            element->_nextSibling = self;
            _prevSibling = element;
        }
        else {
            _parent->_firstChild = element;
            element->_nextSibling = self;
            _prevSibling = element;
        }
        
    }
    
    return self;
}

// 将当前节点添加到 element 上面
-(id) beforeTo:(DVElement *) element {
    
    if(element == nil) {
        return self;
    }
    
    [element before:self];
    
    return self;
}

// 将 element 添加到当前节点下面
-(id) after:(DVElement *) element {
    
    if(element == nil) {
        return self;
    }
    
    [element remove];

    if(_parent) {
        
        element->_document = _document;
        element->_parent = _parent;
        
        if(_nextSibling) {
            element->_nextSibling = _nextSibling;
            element->_prevSibling = self;
            _nextSibling->_prevSibling = element;
            _nextSibling = element;
        }
        else {
            _parent->_lastChild = element;
            element->_prevSibling = self;
            _nextSibling = element;
        }
        
    }

    return self;
}

// 将当前节点添加到 element 下面
-(id) afterTo:(DVElement *) element {
    
    if(element == nil) {
        return self;
    }
    
    [element after:self];

    return self;
}

// 从父级节点中移除
-(id) remove {
    
    if(_prevSibling) {
        
        _prevSibling->_nextSibling = _nextSibling;
        
        if(_nextSibling){
            _nextSibling->_prevSibling = _prevSibling;
        }
        else if(_parent) {
            _parent->_lastChild = _prevSibling;
        }
        
    }
    else if(_parent) {
        _parent->_firstChild = _nextSibling;
        if(_nextSibling) {
            _nextSibling->_prevSibling = nil;
        }
        else {
            _parent->_lastChild = _nextSibling;
        }
    }
    
    _parent = nil;
    _nextSibling = nil;
    _prevSibling = nil;
    _document = nil;
    _style.parent = nil;
    
    return self;
}

-(DVStyle *) style {
    
    if(_style == nil) {
        _style = [[DVStyle alloc] init];
        _style.innerCSS = [self attr:@"style"];
    }
    
    if(_document
        && (_style.parent == nil || _style.parent.version != _document.styleSheet.version) ) {
        
        NSString * class = [self attr:@"class"];
        
        _style.parent = [_document.styleSheet selector:[NSString stringWithFormat:@"* %@ .%@", self.name, class ? class:@""]];
        
    }
    
    return _style;
}

-(id) elementByClass:(Class) elementClass{
    
    if([self isKindOfClass:elementClass]) {
        return self;
    }
    
    DVElement * p = self.firstChild, * r;
    
    while(p) {
        
        r = [p elementByClass:elementClass];
        
        if(r) {
            return r;
        }
        
        p = p.nextSibling;
    }
    
    return nil;
}

-(NSString *) elementId {
    
    if(_elementId == nil && _document != nil) {
        _elementId = [_document newElementId];
    }
    
    return _elementId;
}

@end
