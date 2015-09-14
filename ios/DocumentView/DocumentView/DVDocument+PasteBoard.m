//
//  DVDocument+PasteBoard.m
//  DocumentView
//
//  Created by zhang hailong on 15/9/13.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import "DVDocument+PasteBoard.h"
#import "DVDocument+XML.h"
#import <MobileCoreServices/UTCoreTypes.h>


@implementation DVDocument (PasteBoard)


-(DVElement *) elementWithPasteBoard:(UIPasteboard *) pasteboard {
    
    NSString * xmlContent = [pasteboard valueForPasteboardType:(NSString *) kUTTypeXML];
    
    if(xmlContent) {
        return [self elementWithXMLContent:xmlContent];
    }
    else {
        
        NSString * textContent = [pasteboard string];
        
        if(textContent) {
            DVElement * el = [self elementWithName:@"text" attributes:nil elementId:nil];
            el.textContent = textContent;
            return el;
        }
    }
    
    return nil;
}

@end
