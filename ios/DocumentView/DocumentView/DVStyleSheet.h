//
//  DVStyleSheet.h
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DocumentView/DVStyle.h>

@interface DVStyleSheet : NSObject

@property(nonatomic,assign) NSUInteger version;                 // 版本

-(DVStyle *) selector:(NSArray *) names;                   // 获取样式对象

-(Class) elementClass:(NSArray *) names;                   // 获取节点类

-(void) addStyle:(NSString *) name key:(NSString *) key value:(NSString *) value;

-(void) addStyle:(NSString *)name css:(NSString *)css;

-(void) addCSS:(NSString *) cssContent;

-(void) clear;

-(DVStyle *) style:(NSString *) name;                      

@end
