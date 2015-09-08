//
//  DVDocument.h
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <DocumentView/DVElement.h>
#import <DocumentView/DVStyleSheet.h>

// 文档
@interface DVDocument : DVEventDispatcher

@property(nonatomic,strong,readonly) DVStyleSheet * styleSheet;      // 样式表
@property(nonatomic,strong) DVElement * rootElement;                 // 根节点

-(NSString *) newElementId; // 生成新节点ID

@end
