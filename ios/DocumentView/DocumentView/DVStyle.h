//
//  DVStyle.h
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

// 样式

@interface DVStyle : NSObject

@property(nonatomic,assign) NSUInteger version;                 // 版本
@property(nonatomic,strong) DVStyle * parent;                   // 父级样式
@property(nonatomic,copy,readonly) NSArray * keys;              // 属性键值
@property(nonatomic,copy) NSString * innerCSS;                  // css 属性

// 获取属性
-(NSString *) attr:(NSString *) key;

// 设置属性 value==nil 时删除属性
-(id) attr:(NSString *) key value:(NSString *) value;

// 设置属性 value==nil 时删除属性 important == YES 强制覆盖原属性
-(id) attr:(NSString *) key value:(NSString *) value important:(BOOL) important;


@end
