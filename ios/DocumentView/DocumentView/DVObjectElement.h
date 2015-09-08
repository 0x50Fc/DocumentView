//
//  DVObjectElement.h
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import <DocumentView/DVControlElement.h>

// 重新绑定对象 object

@interface DVObjectEvent : DVEvent

+(id) objectEvent:(DVElement *) element;

@end

@interface DVObjectElement : DVControlElement

@property(nonatomic,readonly) Class objectClass;
@property(nonatomic,readonly,getter= isDetachChildren) BOOL detachChildren;  // 托管子节点

@end

@interface NSObject (DVObjectElement)

-(void) setObjectElement:(DVObjectElement *) element;

@end