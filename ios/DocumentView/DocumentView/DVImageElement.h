//
//  DVImageElement.h
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import <DocumentView/DVCanvasElement.h>

@interface DVImageElement : DVCanvasElement

@property(nonatomic,readonly,getter=isLoading) BOOL loading;
@property(nonatomic,strong,readonly) NSString * src;
@property(nonatomic,strong) UIImage * image;

@end
