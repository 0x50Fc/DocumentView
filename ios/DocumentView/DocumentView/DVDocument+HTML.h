//
//  DVDocument+HTML.h
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import <DocumentView/DVDocument.h>

@interface DVDocument (HTML)

-(DVElement *) elementWithHTMLContent:(NSString *) htmlContent;

-(DVElement *) elementWithHTMLFile:(NSString *)  htmlFile;

@end
