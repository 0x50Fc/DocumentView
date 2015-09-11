//
//  DVCanvasElement.h
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import <DocumentView/DVObjectElement.h>


@interface DVCanvasElement : DVObjectElement

@property(nonatomic,readonly,getter=isHidden) BOOL hidden;
@property(nonatomic,readonly) double borderRadius;
@property(nonatomic,readonly) UIColor * backgroundColor;
@property(nonatomic,readonly) UIColor * borderColor;
@property(nonatomic,readonly) double borderWidth;
@property(nonatomic,readonly,getter=isNeedsDisplay) BOOL needsDisplay;
@property(nonatomic,readonly) id contents;
@property(nonatomic,readonly) BOOL clips;
@property(nonatomic,readonly) double opacity;

-(void) drawInContext:(CGContextRef) context;

@end

@interface CALayer (DVObjectElement)

@end
