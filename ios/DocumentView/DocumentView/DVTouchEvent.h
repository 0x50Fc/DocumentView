//
//  DVTouchEvent.h
//  DocumentView
//
//  Created by ZhangHailong on 15/9/8.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import <DocumentView/DocumentView.h>

enum DVTouchEventType {
    DVTouchEventTypeBegin,DVTouchEventTypeMoved,DVTouchEventTypeEnded,DVTouchEventTypeCanceled
};

@interface DVTouchEvent : DVEvent

@property(nonatomic,strong) NSString * touchId;
@property(nonatomic,assign) CGFloat touchX;
@property(nonatomic,assign) CGFloat touchY;
@property(nonatomic,assign) enum DVTouchEventType eventType;

+(id) touchEvent:(NSString *) touchId touchX:(CGFloat) touchX touchY:(CGFloat) touchY eventType:(enum DVTouchEventType) eventType element:(DVElement *) element;

-(CGPoint) locationInElement:(DVElement *) element;

@end

