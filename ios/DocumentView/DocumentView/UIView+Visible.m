//
//  UIView+Visible.m
//  DocumentView
//
//  Created by ZhangHailong on 15/9/11.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import "UIView+Visible.h"

@implementation UIView (Visible)

-(BOOL) isViewVisible {
    
    if([self isHidden]) {
        return NO;
    }
    
    if(self.window == nil) {
        return NO;
    }
    
    if(self.alpha == 0) {
        return NO;
    }
    
    CGRect r = [self convertRect:self.frame toView:self.window];

    CGRect f = self.window.bounds;
    
    f.origin = CGPointZero;
    
    return CGRectIntersectsRect(r, f);
}

@end
