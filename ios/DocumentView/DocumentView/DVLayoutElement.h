//
//  DVLayoutElement.h
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import <DocumentView/DVElement.h>


@class DVLayoutElement;

enum DVLayoutEventType {
    DVLayoutEventTypeSizeChanged
};

// 布局节点事件 layout
@interface DVLayoutEvent : DVEvent

@property(nonatomic,assign) enum DVLayoutEventType eventType;

+(id) layoutEvent:(DVElement *) target eventType:(enum DVLayoutEventType) eventType;

@end

// 布局节点
@interface DVLayoutElement : DVElement

@property(nonatomic,assign) CGRect frame;
@property(nonatomic,assign) CGSize contentSize;
@property(nonatomic,readonly) UIEdgeInsets padding;
@property(nonatomic,readonly) UIEdgeInsets margin;
@property(nonatomic,readonly,getter=isLayouted) BOOL layouted;
@property(nonatomic,readonly,getter=isLayouting) BOOL layouting;
@property(nonatomic,assign) CGSize layoutSize;

-(CGSize) layoutChildren:(UIEdgeInsets) padding;

-(CGSize) layout:(CGSize) size;

-(CGSize) layout;

@end
