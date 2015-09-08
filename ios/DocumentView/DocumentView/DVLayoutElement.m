//
//  DVLayoutElement.m
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import "DVLayoutElement.h"
#import "DVElement+Value.h"

@implementation DVLayoutElement


@synthesize frame = _frame;
@synthesize contentSize = _contentSize;
@synthesize layouted = _layouted;
@synthesize layoutSize = _layoutSize;

-(void) setFrame:(CGRect)frame{
    _frame = frame;
    _layouted = YES;
}

-(CGSize) layoutChildren:(UIEdgeInsets) padding{
    
    CGSize size = CGSizeZero;
    CGSize insetSize = CGSizeMake(_frame.size.width - padding.left - padding.right, _frame.size.height - padding.top - padding.bottom);
    
    NSString * layout = [self stringValueForKey:@"layout" defaultValue:nil];
    
    if([layout isEqualToString:@"flow"]){
        
        CGPoint p = CGPointMake(padding.left, padding.top);
        CGFloat lineHeight = 0;
        CGFloat width = padding.left + padding.right;
        CGFloat maxWidth = _frame.size.width;
        
        if(maxWidth == MAXFLOAT){
            maxWidth = [self doubleValueForKey:@"max-width" defaultValue:maxWidth];
        }
        
        DVElement * el = self.firstChild;
        
        while(el) {
            
            if([el isKindOfClass:[DVLayoutElement class]]){
                
                DVLayoutElement * layoutElement = (DVLayoutElement *) el;
                
                UIEdgeInsets margin = [layoutElement margin];
                
                [layoutElement layout:CGSizeMake(insetSize.width - margin.left - margin.right, insetSize.height - margin.top - margin.bottom)];
                
                CGRect r = [layoutElement frame];
                
                if(( p.x + r.size.width + margin.left + margin.right <= maxWidth - padding.right)){
                    
                    r.origin.x = p.x + margin.left;
                    r.origin.y = p.y + margin.top;
                    
                    p.x += r.size.width + margin.left + margin.right;
                    
                    if(lineHeight < r.size.height + margin.top + margin.bottom){
                        lineHeight = r.size.height + margin.top + margin.bottom;
                    }
                    if(width < p.x + padding.right){
                        width = p.x + padding.right;
                    }
                }
                else {
                    p.x = padding.left;
                    p.y += lineHeight;
                    lineHeight = r.size.height + margin.top + margin.bottom;
                    r.origin.x = p.x + margin.left;
                    r.origin.y = p.y + margin.top;
                    p.x += r.size.width + margin.left + margin.right;
                    if(width < p.x + padding.right){
                        width = p.x + padding.right;
                    }
                }
                
                [layoutElement setFrame:r];
                
            }
            else if([el.name isEqual:@"br"]){
                p.x = padding.left;
                p.y += lineHeight;
                lineHeight = 0;
            }
            
            el = el.nextSibling;
        }
        
        size.width = width;
        size.height = p.y + lineHeight + padding.bottom;
    }
    else if([layout isEqualToString:@"flow-x"]){
        
        CGPoint p = CGPointMake(padding.left, padding.top);
        CGFloat lineHeight = 0;
        CGFloat width = padding.left + padding.right;
        CGFloat maxWidth = _frame.size.width;
        
        if(maxWidth == MAXFLOAT){
            maxWidth = [self doubleValueForKey:@"max-width" defaultValue:maxWidth];
        }
        
        DVElement * el = self.firstChild;
        
        while(el) {
        
            if([el isKindOfClass:[DVLayoutElement class]]){
                
                DVLayoutElement * layoutElement = (DVLayoutElement *) el;
                
                UIEdgeInsets margin = [layoutElement margin];
                
                [layoutElement layout:CGSizeMake(insetSize.width - margin.left - margin.right, insetSize.height - margin.top - margin.bottom)];
                
                CGRect r = [layoutElement frame];
                
                r.origin.x = p.x + margin.left;
                r.origin.y = p.y + margin.top;
                
                p.x += r.size.width + margin.left + margin.right;
                
                if(lineHeight < r.size.height + margin.top + margin.bottom){
                    lineHeight = r.size.height + margin.top + margin.bottom;
                }
                if(width < p.x + padding.right){
                    width = p.x + padding.right;
                }
                
                [layoutElement setFrame:r];
                
            }
            else if([el.name isEqual:@"br"]){
                p.x = padding.left;
                p.y += lineHeight;
                lineHeight = 0;
            }
            
            
            el = el.nextSibling;
        }
        
        size.width = width;
        size.height = p.y + lineHeight + padding.bottom;
    }
    else {
        
        size.width = padding.left + padding.right;
        size.height = padding.top + padding.bottom;
        
        DVElement * el = self.firstChild;
        
        while(el) {
        
            if([el isKindOfClass:[DVLayoutElement class]]){
                
                DVLayoutElement * layoutElement = (DVLayoutElement *) el;
                
                [layoutElement layout:CGSizeMake(insetSize.width, insetSize.height)];
                
                CGRect r = [layoutElement frame];
                
                CGFloat left = [el doubleValueForKey:@"left" defaultValue:0 of:insetSize.width];
                
                CGFloat right = [el doubleValueForKey:@"right" defaultValue:MAXFLOAT of:insetSize.width];
                
                CGFloat top = [el doubleValueForKey:@"top" defaultValue:0 of:insetSize.height];
                
                CGFloat bottom = [el doubleValueForKey:@"bottom" defaultValue:MAXFLOAT of:insetSize.height];
                
                if(left == MAXFLOAT){
                    if(right == MAXFLOAT){
                        r.origin.x = padding.left + (insetSize.width - r.size.width) * 0.5;
                    }
                    else{
                        r.origin.x = padding.left + (insetSize.width - r.size.width - right);
                    }
                }
                else {
                    r.origin.x = padding.left + left;
                }
                
                if(top == MAXFLOAT){
                    if(bottom == MAXFLOAT){
                        r.origin.y = padding.top + (insetSize.height - r.size.height) * 0.5;
                    }
                    else {
                        r.origin.y = padding.top + (insetSize.height - r.size.height - bottom);
                    }
                }
                else {
                    r.origin.y = padding.top + top;
                }
                
                if(r.origin.x + r.size.width + padding.right > size.width){
                    size.width = r.origin.x + r.size.width + padding.right;
                }
                
                if(r.origin.y + r.size.height + padding.bottom > size.height ){
                    size.height = r.origin.y + r.size.height +padding.bottom;
                }
                
                [layoutElement setFrame:r];
                
            }
            
            el = el.nextSibling;
        }
        
    }
    
    [self setContentSize:size];
    
    return size;
}

-(CGSize) layout:(CGSize) size{
    
    _layoutSize = size;
    
    [self setFrame:CGRectMake(0, 0
                              , [self doubleValueForKey:@"width" defaultValue:0 of:size.width]
                              , [self doubleValueForKey:@"height" defaultValue:0 of:size.height])];
    
    UIEdgeInsets padding = [self padding];
    
    
    if(_frame.size.width == MAXFLOAT || _frame.size.height == MAXFLOAT){
        
        CGSize contentSize = [self layoutChildren:padding];
        
        if(_frame.size.width == MAXFLOAT){
            
            _frame.size.width = contentSize.width;
            
            CGFloat max = [self doubleValueForKey:@"max-width" defaultValue:_frame.size.width of:size.width];
            CGFloat min = [self doubleValueForKey:@"min-width" defaultValue:_frame.size.width of:size.width];
            
            if(_frame.size.width > max){
                _frame.size.width = max;
            }
            if(_frame.size.width < min){
                _frame.size.width = min;
            }
        }
        
        if(_frame.size.height == MAXFLOAT){
            
            _frame.size.height = contentSize.height;
            
            CGFloat max = [self doubleValueForKey:@"max-height" defaultValue:_frame.size.height of:size.height];
            CGFloat min = [self doubleValueForKey:@"min-height" defaultValue:_frame.size.height of:size.height];
            
            if(_frame.size.height > max){
                _frame.size.height = max;
            }
            if(_frame.size.height < min){
                _frame.size.height = min;
            }
        }
        
        return contentSize;
        
    }
    else {
        return [self layoutChildren:padding];
    }
    
}

-(CGSize) layout{
    return [self layoutChildren:self.padding];
}

-(UIEdgeInsets) padding{
    
    CGFloat v = [self doubleValueForKey:@"padding" defaultValue:0 of:_frame.size.width];
    
    return UIEdgeInsetsMake(
                            [self doubleValueForKey:@"padding-top" defaultValue:v of:_frame.size.height]
                            , [self doubleValueForKey:@"padding-left" defaultValue:v of:_frame.size.width]
                            , [self doubleValueForKey:@"padding-bottom" defaultValue:v of:_frame.size.height]
                            , [self doubleValueForKey:@"padding-right" defaultValue:v of:_frame.size.width]);
    
}

-(UIEdgeInsets) margin{
    
    CGFloat v = [self doubleValueForKey:@"margin" defaultValue:0 of:_frame.size.width];
    
    return UIEdgeInsetsMake(
                            [self doubleValueForKey:@"margin-top" defaultValue:v of:_frame.size.height]
                            , [self doubleValueForKey:@"margin-left" defaultValue:v of:_frame.size.width]
                            , [self doubleValueForKey:@"margin-bottom" defaultValue:v of:_frame.size.height]
                            , [self doubleValueForKey:@"margin-right" defaultValue:v of:_frame.size.width]);
    
}

-(void) sendEvent:(DVEvent *)event {
    
    if([event isKindOfClass:[DVElementEvent class]]) {
        _layouted = NO;
    }
    
    [super sendEvent:event];
}

@end
