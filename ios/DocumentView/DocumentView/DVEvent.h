//
//  DVEvent.h
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

// 事件
@class DVElement;

@interface DVEvent : NSObject

@property(nonatomic,strong) NSString * name;            // 事件名称
@property(nonatomic,strong) DVElement * element;        // 节点
@property(nonatomic,assign) BOOL cancelBubble;          // 取消向上级节点发送事件

@end

enum DVTouchEventType {
    DVTouchEventTypeBegin,DVTouchEventTypeMove,DVTouchEventTypeEnd,DVTouchEventTypeCanceled
};

@interface DVTouchEvent : DVEvent

@property(nonatomic,strong) NSString * touchId;
@property(nonatomic,assign) CGFloat touchX;
@property(nonatomic,assign) CGFloat touchY;
@property(nonatomic,assign) enum DVTouchEventType eventType;

+(id) touchEvent:(NSString *) touchId touchX:(CGFloat) touchX touchY:(CGFloat) touchY eventType:(enum DVTouchEventType) eventType element:(DVElement *) element;

-(CGPoint) locationInElement:(DVElement *) element;

@end