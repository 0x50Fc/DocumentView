//
//  DVDocumentView.h
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import <DocumentView/DVEventElement.h>

@interface DVDocumentView : UIScrollView<DVEventDelegate>

@property(nonatomic,strong) DVElement * element;


@end
