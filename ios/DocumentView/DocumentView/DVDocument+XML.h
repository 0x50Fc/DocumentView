//
//  DVDocument+XML.h
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import <DocumentView/DVDocument.h>

@interface DVDocument (XML)

-(DVElement *) elementWithXMLContent:(NSString *) xmlContent;

-(DVElement *) elementWithXMLFile:(NSString *) xmlFile;

@end
