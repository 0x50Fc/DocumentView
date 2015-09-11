//
//  DVElement.h
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import <DocumentView/DVEvent.h>

// 节点

@class DVDocument;
@class DVStyle;
@class DVElement;

enum DVElementEventType {
    DVElementEventTypeAppend
    ,DVElementEventTypeBefore
    ,DVElementEventTypeAfter
    ,DVElementEventTypeRemove
};

// 节点事件 element
@interface DVElementEvent : DVEvent

@property(nonatomic,assign) enum DVElementEventType eventType;
@property(nonatomic,strong) DVElement * element;

+(id) elementEvent:(DVElement *) target eventType:(enum DVElementEventType) eventType element:(DVElement *) element;

@end

@interface DVActionEvent : DVEvent

@property(nonatomic,strong) NSString * action;

+(id) actionEvent:(NSString *) action element:(DVElement *) element;

@end

@interface DVElement : DVEventDispatcher<NSCoding,NSCopying>

@property(nonatomic,strong) NSString * elementId;               // 节点ID
@property(nonatomic,strong) NSString * name;           // 节点名
@property(nonatomic,strong) NSString * textContent;             // 文本内容
@property(nonatomic,copy,readonly) NSArray * keys;              // 属性键值
@property(nonatomic,strong) DVStyle * style;           // 样式
@property(nonatomic,weak) DVDocument * document;       // 文档
@property(nonatomic,weak,readonly) DVElement * parent;          // 父级节点
@property(nonatomic,strong,readonly) DVElement * nextSibling;   // 下级兄弟节点
@property(nonatomic,weak,readonly) DVElement * prevSibling;     // 上级级兄弟节点
@property(nonatomic,strong,readonly) DVElement * firstChild;    // 第一个子节点
@property(nonatomic,strong,readonly) DVElement * lastChild;     // 最后一个子节点
@property(nonatomic,copy,readonly) NSArray * children;          // 所有子节点
@property(nonatomic,strong,readonly) NSString * className;      // 样式类名

// 创建节点
-(id) initWithName:(NSString *) name attributes:(NSDictionary *) attributes;

// 创建节点
+(id) elementWithName:(NSString *) name attributes:(NSDictionary *) attributes;

// 获取属性
-(NSString *) attr:(NSString *) key;

// 设置属性 value==nil 时删除属性
-(id) attr:(NSString *) key value:(NSString *) value;

// 添加子节点 element
-(id) append:(DVElement *) element;

// 作为子节点添加到 element
-(id) appendTo:(DVElement *) element;

// 将 element 添加到当前节点上面
-(id) before:(DVElement *) element;

// 将当前节点添加到 element 上面
-(id) beforeTo:(DVElement *) element;

// 将 element 添加到当前节点下面
-(id) after:(DVElement *) element;

// 将当前节点添加到 element 下面
-(id) afterTo:(DVElement *) element;

// 从父级节点中移除
-(id) remove;

-(id) elementByClass:(Class) elementClass;

-(NSArray *) elementsByClass:(Class) elementClass;

+(DVElement *) dispatchEvent:(DVEvent *) event element:(DVElement *) element;

+(void) sendEvent:(DVEvent *)event element:(DVElement *) element;


@end
