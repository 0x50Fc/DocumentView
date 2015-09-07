//
//  DVStyle.m
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import "DVStyle.h"

@interface DVStyle() {
    NSMutableDictionary * _attributes;
}

@end

@implementation DVStyle

@synthesize version = _version;
@synthesize parent = _parent;

// 获取属性
-(NSString *) attr:(NSString *) key {
    NSString * v =  [_attributes valueForKey:key];
    if(v == nil && _parent != nil){
        return [_parent attr:key];
    }
    return v;
}

// 设置属性 value==nil 时删除属性
-(id) attr:(NSString *) key value:(NSString *) value {
    return [self attr:key value:value important:NO];
}

// 设置属性 value==nil 时删除属性 important == YES 强制覆盖原属性
-(id) attr:(NSString *) key value:(NSString *) value important:(BOOL) important {
    if(important) {
        if(value) {
            if(_attributes == nil) {
                _attributes = [[NSMutableDictionary alloc] initWithCapacity:4];
            }
            [_attributes setValue:value forKey:key];
        }
        else {
            [_attributes removeObjectForKey:key];
        }
    }
    else {
        
        if(value) {
            
            NSString * v = [_attributes valueForKey:key];
            
            if(v == nil) {
                
                if(_attributes == nil) {
                    _attributes = [[NSMutableDictionary alloc] initWithCapacity:4];
                }
                
                [_attributes setValue:value forKey:key];
            }
        }
        else {
            [_attributes removeObjectForKey:key];
        }

    }
    
    return self;
}


-(NSArray *) keys {
    return [_attributes allKeys];
}

-(NSString *) innerCSS {
    
    NSMutableString * css = [NSMutableString stringWithCapacity:32];
    
    for (NSString * key in [_attributes allKeys]) {
        [css appendFormat:@"%@: %@; ", key,[_attributes valueForKey:key]];
    }
    
    return css;
}

-(void) setInnerCSS:(NSString *)innerCSS {
    
    [_attributes removeAllObjects];
    
    NSArray * items = [innerCSS componentsSeparatedByString:@";"];
    
    for (NSString * item in items) {
        NSArray * kv = [item componentsSeparatedByString:@":"];
        NSString * key = [[kv objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString * value = [kv count] > 1 ?[[kv objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : @"";
        [self attr:key value:value];
    }
    
}

@end
