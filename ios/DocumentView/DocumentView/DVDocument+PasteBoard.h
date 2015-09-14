//
//  DVDocument+PasteBoard.h
//  DocumentView
//
//  Created by zhang hailong on 15/9/13.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import <DocumentView/DVDocument.h>

@interface DVDocument (PasteBoard)

-(DVElement *) elementWithPasteBoard:(UIPasteboard *) pasteboard;

@end
