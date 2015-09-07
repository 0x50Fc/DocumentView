//
//  DVEventElement.h
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import <DocumentView/DVElement.h>
#import <DocumentView/DVEvent.h>

// 事件节点

// 属性变化后触发 attr

@class DVEventElement;

@interface DVAttributeEvent : DVEvent

@property(nonatomic,strong) NSString * key;         // 变化的属性键值
@property(nonatomic,strong) NSString * value;       // 变化前的值

+(id) attributeEvent:(DVEventElement *) element key : (NSString *) key value:(NSString *) value;

@end

typedef BOOL (^ DVEventFunction )(DVEvent * event);

@protocol DVEventDelegate <NSObject>

@optional

-(void) element:(DVElement *) element event:(DVEvent *) event;

@end

@interface DVEventElement : DVElement

-(BOOL) dispatchEvent:(DVEvent *) event;        // 分配事件从父亲到子 返回 NO 表示中止分发

-(void) sendEvent:(DVEvent *) event;            // 发送事件从子到父

-(void) bind:(NSString *) name fn:(DVEventFunction) fn;     // 绑定事件

-(void) unbind:(NSString *) name fn:(DVEventFunction) fn;   // 解绑事件

-(void) bind:(NSString *) name delegate:(id<DVEventDelegate>) delegate;     // 绑定事件

-(void) unbind:(NSString *) name delegate:(id<DVEventDelegate>) delegate;   // 解绑事件

+(DVElement *) dispatchEvent:(DVEvent *) event element:(DVElement *) element;

+(void) sendEvent:(DVEvent *)event element:(DVElement *) element;

@end
