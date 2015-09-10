//
//  DVEvent.h
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

// 事件
@class DVEventDispatcher;

@interface DVEvent : NSObject

@property(nonatomic,strong) NSString * name;            // 事件名称
@property(nonatomic,strong) DVEventDispatcher * target; // 目标
@property(nonatomic,assign) BOOL cancelBubble;          // 取消向上级节点发送事件

+(id) eventWithName:(NSString *) name target:(DVEventDispatcher *) target;

@end


typedef BOOL (^ DVEventFunction )(DVEvent * event);

@interface NSObject(DVEvent)

-(BOOL) dispatcher:(DVEventDispatcher *) dispatcher event:(DVEvent *) event;

@end


@interface DVEventDispatcher : NSObject

-(BOOL) dispatchEvent:(DVEvent *) event;        // 分配事件从父亲到子 返回 NO 表示中止分发

-(void) sendEvent:(DVEvent *) event;            // 发送事件从子到父

-(void) bind:(NSString *) name fn:(DVEventFunction) fn;     // 绑定事件

-(void) unbind:(NSString *) name fn:(DVEventFunction) fn;   // 解绑事件

-(void) bind:(NSString *) name delegate:(id) delegate;     // 绑定事件

-(void) unbind:(NSString *) name delegate:(id) delegate;   // 解绑事件

@end