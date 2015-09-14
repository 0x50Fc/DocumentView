//
//  DVObjectElement.h
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import <DocumentView/DVControlElement.h>

// 重新绑定对象 object

typedef NSUInteger DVObjectElementChangedType;

enum {
    DVObjectElementChangedCanvas = 1 << 0,
    DVObjectElementChangedAnimation = 1 << 1,
    DVObjectElementChangedTransform = 1 << 2,
};

@interface DVObjectEvent : DVEvent

@property(nonatomic,assign) DVObjectElementChangedType changedTypes;

+(id) objectEvent:(DVElement *) element changedTypes:(DVObjectElementChangedType) changedTypes;

@end

@interface DVObjectElement : DVControlElement

@property(nonatomic,readonly) Class objectClass;
@property(nonatomic,readonly,getter = isDetachChildren) BOOL detachChildren;  // 托管子节点
@property(nonatomic,readonly) NSString * reuse;                             // 重用 nil 时不重用

@end

@interface NSObject (DVObjectElement)

-(void) setObjectElement:(DVObjectElement *) element changedTypes:(DVObjectElementChangedType) changedTypes;

@end