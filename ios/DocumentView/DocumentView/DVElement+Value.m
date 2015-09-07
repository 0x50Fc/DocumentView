//
//  DVElement+Value.m
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import "DVElement+Value.h"
#import <DocumentView/DVStyle.h>

@implementation DVElement (Value)

+(double) dp {
    
    static double dp = 0;
    
    if(dp == 0){
        
        CGSize size = [[UIScreen mainScreen] bounds].size;
        
        if(size.width >= 768 ){
            dp = size.width / 768.0;
        }
        else {
            dp = size.width / 320.0;
        }
    }
    
    return dp;
}

-(NSString *) stringValueForKey:(NSString *) key defaultValue:(NSString *) defaultValue {
    
    NSString * v = [self attr:key];
    
    if(v == nil) {
        v = [self.style attr:key];
    }
    
    if(v ){
        return v;
    }
    
    return defaultValue;
}

-(double) doubleValueForKey:(NSString *) key defaultValue:(double) defaultValue {
    
    NSString * v = [self stringValueForKey:key defaultValue:nil];
    
    if(v ){
        
        if([v hasSuffix:@"dp"]){
            return [v doubleValue] * [DVElement dp];
        }
        
        return [v doubleValue];
    }
    
    return defaultValue;
}

-(double) doubleValueForKey:(NSString *) key defaultValue:(double) defaultValue of:(double) of{
    
    NSString * v = [self stringValueForKey:key defaultValue:nil];
    
    if(v){
        
        if([v isEqualToString:@"auto"]){
            return MAXFLOAT;
        }
        
        NSUInteger length = [v length];
        
        NSRange r = [v rangeOfString:@"%"];
        
        if(r.location != NSNotFound){
            
            if(r.location + r.length == length){
                return [v doubleValue] * of * 0.01;
            }
            else if([v hasPrefix:@"dp"]){
                return [[v substringToIndex:r.location] doubleValue] * of * 0.01 + [[v substringFromIndex:r.location + r.length] doubleValue] * [DVElement dp];
            }
            else {
                return [[v substringToIndex:r.location] doubleValue] * of * 0.01 + [[v substringFromIndex:r.location + r.length] doubleValue];
            }
            
        }
        else if([v hasSuffix:@"dp"]){
            return [v doubleValue] * [DVElement dp];
        }
        else {
            return [v doubleValue];
        }
        
    }
    
    return defaultValue;
}

-(BOOL) booleanValueForKey:(NSString *) key defaultValue:(BOOL) defaultValue {
    
    NSString * v = [self stringValueForKey:key defaultValue:nil];
    
    if(v ){
        
        if([v isEqualToString:@""] || [v isEqualToString:@"0"] || [v isEqualToString:@"false"]){
            return NO;
        }
        
        return YES;
    }
    
    return defaultValue;
    
}

-(int) intValueForKey:(NSString *) key defaultValue:(int) defaultValue {
    
    NSString * v = [self stringValueForKey:key defaultValue:nil];
    
    if(v ){
        
        return [v intValue];
    }
    
    return defaultValue;
    
}

-(long long) longLongValueForKey:(NSString *) key defaultValue:(long long) defaultValue {
    
    NSString * v = [self stringValueForKey:key defaultValue:nil];
    
    if(v ){
        
        return [v longLongValue];
    }
    
    return defaultValue;
}

-(UIColor *) colorValueForKey:(NSString *) key defaultValue:(UIColor *) defaultValue{
    
    NSString * v = [self stringValueForKey:key defaultValue:nil];
    
    if(v){
        
        if([v isEqualToString:@"clear"]){
            return [UIColor clearColor];
        }
        
        if([v hasPrefix:@"#"]){
            
            int r=0,g=0,b=0,a=0x0ff;
            
            NSArray * vs = [v componentsSeparatedByString:@" "];
            
            if([vs count] > 0){
                v = [vs objectAtIndex:0];
                
                if([v length] > 7){
                    sscanf([v UTF8String], "#%02x%02x%02x%02x", & a, & r,& g,& b);
                }
                else if([v length] > 4){
                    sscanf([v UTF8String], "#%02x%02x%02x", & r, & g, & b);
                }
                else {
                    sscanf([v UTF8String], "#%1x%1x%1x", & r, & g, & b);
                    r = (r << 4) | r;
                    g = (g << 4) | g;
                    b = (b << 4) | b;
                }
            }
            
            if([vs count] > 1){
                v = [vs objectAtIndex:1];
                a = [v doubleValue] * 0x0ff;
            }
            
            return [UIColor colorWithRed:(double) r / 255.0 green:(double) g / 255.0 blue:(double) b / 255.0 alpha:(double) a / 255.0];
        }
        
        return defaultValue;
    }
    
    return defaultValue;
}

-(UIFont *) fontValueForKey:(NSString *) key defaultValue:(UIFont *) defaultValue{
    
    NSString * v = [self stringValueForKey:key defaultValue:nil];
    
    if(v){
        
        NSArray * vs = [v componentsSeparatedByString:@" "];
        
        if([vs count] > 1) {
            
            v = [vs objectAtIndex:0];
            
            if([v isEqualToString:@"bold"]){
                return [UIFont boldSystemFontOfSize:[[vs objectAtIndex:1] doubleValue]];
            }
            else if([v isEqualToString:@"italic"]){
                return [UIFont italicSystemFontOfSize:[[vs objectAtIndex:1] doubleValue]];
            }
            else {
                return [UIFont fontWithName:v size:[[vs objectAtIndex:1] doubleValue]];
            }
            
        }
        else if([vs count] > 0){
            
            v = [vs objectAtIndex:0];
            
            if([v isEqualToString:@"bold"]){
                return [UIFont boldSystemFontOfSize:14];
            }
            else if([v isEqualToString:@"italicS"]){
                return [UIFont italicSystemFontOfSize:14];
            }
            else {
                return [UIFont systemFontOfSize:[v doubleValue]];
            }
        }
        
    }
    
    return defaultValue;
}

-(UIEdgeInsets) edgeInsetsValueForKey:(NSString *) key defaultValue:(UIEdgeInsets) edgeInsets {
    double top = 0,left = 0,bottom = 0,right = 0;
    NSString * v = [self stringValueForKey:key defaultValue:nil];
    if(v){
        sscanf([v UTF8String], "%lf %lf %lf %lf",& top,& left,& bottom,& right);
    }
    return UIEdgeInsetsMake(top, left, bottom, right);
}
@end
