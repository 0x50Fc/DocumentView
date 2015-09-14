//
//  DVElement+Text.m
//  DocumentView
//
//  Created by zhang hailong on 15/9/13.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import "DVElement+Text.h"


static void DVElement_Text_innerText(NSMutableString * text, DVElement * element) {
    
    if(element.firstChild) {
        DVElement * p = element.firstChild;
        while (p) {
            DVElement_Text_innerText(text, p);
            p = p.nextSibling;
        }
    }
    else if(element.textContent) {
        [text appendString:element.textContent];
    }
    
}

@implementation DVElement (Text)


-(NSString *) innerText {

    NSMutableString * text = [NSMutableString stringWithCapacity:32];
    
    DVElement_Text_innerText(text,self);
    
    return text;
    
}

@end
