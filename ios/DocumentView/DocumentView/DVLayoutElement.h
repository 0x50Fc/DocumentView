//
//  DVLayoutElement.h
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import <DocumentView/DVEventElement.h>


@class DVLayoutElement;


// 布局节点
@interface DVLayoutElement : DVEventElement

@property(nonatomic,assign) CGRect frame;
@property(nonatomic,assign) CGSize contentSize;
@property(nonatomic,readonly) UIEdgeInsets padding;
@property(nonatomic,readonly) UIEdgeInsets margin;
@property(nonatomic,readonly,getter=isLayouted) BOOL layouted;
@property(nonatomic,assign) CGSize layoutSize;

-(CGSize) layoutChildren:(UIEdgeInsets) padding;

-(CGSize) layout:(CGSize) size;

-(CGSize) layout;

@end
