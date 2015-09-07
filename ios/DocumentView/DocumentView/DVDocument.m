//
//  DVDocument.m
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import "DVDocument.h"

@interface DVDocument() {
    unsigned long long _elementId;
}

@end

@implementation DVDocument

@synthesize styleSheet = _styleSheet;

-(NSString *) newElementId {
    return [NSString stringWithFormat:@"e%llu", ++ _elementId];
}

-(DVStyleSheet *) styleSheet {
    if(_styleSheet == nil) {
        _styleSheet = [[DVStyleSheet alloc] init];
    }
    return _styleSheet;
}

@end
