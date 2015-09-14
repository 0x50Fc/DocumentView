//
//  DVAnimationElement.m
//  DocumentView
//
//  Created by ZhangHailong on 15/9/11.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import "DVAnimationElement.h"
#import "DVElement+Value.h"
#import "DVTransformElement.h"

@implementation DVAnimationElement

-(CABasicAnimation *) animation {
    
    CABasicAnimation * anim = nil;
    
    NSString * name = [self attr:@"name"];
    
    if([name isEqualToString:@"opacity"]) {
        
        anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
        
        anim.fromValue = [NSNumber numberWithDouble:[self doubleValueForKey:@"from" defaultValue:1 of:1.0]];
        anim.toValue = [NSNumber numberWithDouble:[self doubleValueForKey:@"to" defaultValue:1 of:1.0]];
        
    }
    else if([name isEqualToString:@"transform"]) {
        
        anim = [CABasicAnimation animationWithKeyPath:@"transform"];
        
        anim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
 
        DVElement * p = self.firstChild;
        
        while (p) {
            
            if([p.name isEqualToString:@"from"]) {
                
                CATransform3D transform = CATransform3DIdentity;
                
                DVElement * pp = p.firstChild;
                
                while (pp) {
                    
                    if([pp isKindOfClass:[DVTransformElement class]]) {
                        transform = [(DVTransformElement *) pp transform:transform];
                    }
                    
                    pp = pp.nextSibling;
                }
                
                anim.fromValue = [NSValue valueWithCATransform3D:transform];
                
            }
            else if([p.name isEqualToString:@"to"]){
                
                CATransform3D transform = CATransform3DIdentity;
                
                DVElement * pp = p.firstChild;
                
                while (pp) {
                    
                    if([pp isKindOfClass:[DVTransformElement class]]) {
                        transform = [(DVTransformElement *) pp transform:transform];
                    }
                    
                    pp = pp.nextSibling;
                }
                
                anim.toValue = [NSValue valueWithCATransform3D:transform];
                
            }
           
            
            p = p.nextSibling;
        }
        
    }
    
    if(anim) {
        [anim setDuration:[self doubleValueForKey:@"duration" defaultValue:0]];
        [anim setRepeatCount:[self doubleValueForKey:@"repeatCount" defaultValue:0]];
        [anim setAutoreverses:[self booleanValueForKey:@"autoreverses" defaultValue:NO]];
        [anim setBeginTime:CACurrentMediaTime() + [self doubleValueForKey:@"delay" defaultValue:0]];
    }
    
    return anim;
}


@end
