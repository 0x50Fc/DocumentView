//
//  DVStyleSheet.m
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import "DVStyleSheet.h"

@interface DVStyleSheet() {
    NSMutableDictionary * _styles;
}

@end

@implementation DVStyleSheet

-(void) addStyle:(NSString *) name key:(NSString *) key value:(NSString *) value {
    
    if(_styles == nil){
        _styles = [[NSMutableDictionary alloc] initWithCapacity:4];
    }
    
    NSMutableDictionary * style = [_styles valueForKey:name];
    
    if(style == nil) {
        style = [NSMutableDictionary dictionaryWithCapacity:4];
        [_styles setValue:style forKey:name];
    }
    
    [style setValue:value forKey:key];
    
    _version ++;
}

-(void) addStyle:(NSString *)name css:(NSString *)css {
    
    NSArray * items = [css componentsSeparatedByString:@";"];
    
    for (NSString * item in items) {
        NSArray * kv = [item componentsSeparatedByString:@":"];
        NSString * key = [[kv objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString * value = [kv count] > 1 ?[[kv objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : @"";
        if([key length]) {
            [self addStyle:name key:key value:value];
        }
    }
    
}

-(void) addCSS:(NSString *) cssContent {
    
    NSArray * items = [cssContent componentsSeparatedByString:@"}"];
    
    for (NSString * item in items) {
        
        NSArray * nv = [item componentsSeparatedByString:@"{"];
        
        NSString * name = [[nv objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString * value = [nv count] > 1 ? [[nv objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : @"";
        
        for (NSString * na in [name componentsSeparatedByString:@" "]) {
            if([na length]) {
                [self addStyle:na css:value];
            }
        }
        
    }
    
}

-(void) clear {
    [_styles removeAllObjects];
    _version ++;
}

-(DVStyle *) selector:(NSArray *) names {
    
    DVStyle * style = [[DVStyle alloc] init];
    
    style.version = _version;
   
    for(NSString * n in names) {
        NSDictionary * data = [_styles valueForKey:n];
        for (NSString * key in [data allKeys]) {
            [style attr:key value:[data valueForKey:key] important:YES];
        }
    }

    return style;
}

-(Class) elementClass:(NSArray *) names {
    
    for(NSString * n in names) {
        NSDictionary * data = [_styles valueForKey:n];
        NSString * v = [data valueForKey:@"element-class"];
        if(v) {
            return NSClassFromString(v);
        }
    }
    
    return nil;
}

@end
