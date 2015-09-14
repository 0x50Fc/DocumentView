//
//  DVTransformElement.m
//  DocumentView
//
//  Created by ZhangHailong on 15/9/11.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import "DVTransformElement.h"
#import "DVElement+Value.h"

@implementation DVTransformElement


-(CATransform3D) transform:(CATransform3D) from {
    
    if([self.name isEqualToString:@"translate"]) {
        return CATransform3DTranslate(from, [self doubleValueForKey:@"x" defaultValue:0 of:1.0]
                                      , [self doubleValueForKey:@"y" defaultValue:0 of:1.0]
                                      , [self doubleValueForKey:@"z" defaultValue:0 of:1.0]);
    }
    
    if([self.name isEqualToString:@"scale"]) {
        return CATransform3DScale(from, [self doubleValueForKey:@"x" defaultValue:1 of:1.0]
                                      , [self doubleValueForKey:@"y" defaultValue:1 of:1.0]
                                      , [self doubleValueForKey:@"z" defaultValue:1 of:1.0]);
    }
    
    if([self.name isEqualToString:@"rotate"]) {
        return CATransform3DRotate(from, [self doubleValueForKey:@"angle" defaultValue:0 of:360]
                                   ,[self doubleValueForKey:@"x" defaultValue:1 of:1.0]
                                  , [self doubleValueForKey:@"y" defaultValue:1 of:1.0]
                                  , [self doubleValueForKey:@"z" defaultValue:1 of:1.0]);
    }
    
    return from;
}


@end
