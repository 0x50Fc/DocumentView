//
//  DVControlElement.h
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import <DocumentView/DVLayoutElement.h>

@interface DVControlElement : DVLayoutElement

@property(nonatomic,readonly,getter = isEnabled) BOOL enabled;
@property(nonatomic,assign,getter = isHighlighted) BOOL highlighted;
@property(nonatomic,readonly,getter = isSelected) BOOL selected;

@end
