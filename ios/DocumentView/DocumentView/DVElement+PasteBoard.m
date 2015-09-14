//
//  DVElement+PasteBoard.m
//  DocumentView
//
//  Created by zhang hailong on 15/9/13.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import "DVElement+PasteBoard.h"
#import "DVElement+XML.h"
#import "DVElement+Text.h"

#import <MobileCoreServices/UTCoreTypes.h>

@implementation DVElement (PasteBoard)

-(void) copyToPasteBoard:(UIPasteboard *) pasteboard {
    
    [pasteboard setItems:@[@{(NSString *) kUTTypeXML : [self outerXML]
                             , (NSString *) kUTTypePlainText : [self innerText] }]];
    
    
}

@end
