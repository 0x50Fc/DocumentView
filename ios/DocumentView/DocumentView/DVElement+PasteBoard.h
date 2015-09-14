//
//  DVElement+PasteBoard.h
//  DocumentView
//
//  Created by zhang hailong on 15/9/13.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import <DocumentView/DVElement.h>

@interface DVElement (PasteBoard)

-(void) copyToPasteBoard:(UIPasteboard *) pasteboard;

@end
