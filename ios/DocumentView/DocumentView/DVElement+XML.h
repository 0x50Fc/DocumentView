//
//  DVElement+XML.h
//  DocumentView
//
//  Created by ZhangHailong on 15/9/11.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import <DocumentView/DVElement.h>

@interface DVElement (XML)

@property(nonatomic,readonly) NSString * innerXML;
@property(nonatomic,readonly) NSString * outerXML;

@end
