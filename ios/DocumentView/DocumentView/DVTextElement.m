//
//  DVTextElement.m
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import "DVTextElement.h"
#import "DVImageElement.h"
#import "VTRich.h"
#import "DVElement+Value.h"
#import "NSString+TextLength.h"
#import "VTRichImageElement.h"
#import "VTRichLinkElement.h"


@interface DVTextElement() {

}

@property(nonatomic,readonly) VTRich * rich;

@end

@implementation DVTextElement

@synthesize rich = _rich;

-(void) elementToRichElement:(DVElement *) element rich:(VTRich *) rich attributes:(NSDictionary *) attributes{
    
    NSString * text = [element textContent];
    NSString * name = [element name];
    
    NSString * maxLength = [element stringValueForKey:@"max-length" defaultValue:nil];
    
    if(maxLength){
        
        NSInteger length = [text textIndexOfLength:[maxLength intValue]];
        
        if(length < [text length]){
            text = [[text substringToIndex:length] stringByAppendingFormat:@"..."];
        }
    }
    
    NSMutableDictionary * attr = [NSMutableDictionary dictionaryWithDictionary:attributes];
    
    UIFont * font = [element fontValueForKey:@"font" defaultValue:nil];
    
    if(font == nil){
        font = [UIFont systemFontOfSize:[element doubleValueForKey:@"font-size" defaultValue:14]];
    }
    
    if(font){
        CTFontRef f = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize + rich.incFontSize, nil);
        [attr setValue:(__bridge id)f forKey:(id)kCTFontAttributeName];
        CFRelease(f);
    }
    
    UIColor * textColor = [element colorValueForKey:@"color" defaultValue:nil];
    
    if(textColor){
        [attr setValue:(id) textColor.CGColor forKey:(id)kCTForegroundColorAttributeName];
    }
    
    UIColor * bgColor = [element colorValueForKey:@"background-color" defaultValue:nil];
    
    if(bgColor){
        [attr setValue:(id) bgColor.CGColor forKey:(id)VTBackgroundColorAttributeName];
    }
    
    if([element.name isEqualToString:@"br"]){
        if(![rich isNewLine]){
            [rich appendText:@"\n" attributes:attr];
        }
    }
    else if([element isKindOfClass:[DVImageElement class]]){
        
        VTRichImageElement * img = [[VTRichImageElement alloc] init];
        
        [img setUserInfo:element];
        
        [img setImage:[(DVImageElement *)element image]];
        
        CGSize size = img.image.size;
        CGFloat dr = size.width ? size.height / size.width : 0;
        CGRect r = self.frame;
        
        NSString * width = [element stringValueForKey:@"width" defaultValue:nil];
        NSString * height = [element stringValueForKey:@"height" defaultValue:nil];
        
        if(width && ![width isEqualToString:@"auto"]){
            if([width hasSuffix:@"%"]){
                size.width = [width floatValue] * r.size.width / 100.0;
            }
            else{
                size.width = [width floatValue];
            }
        }
        
        if(height && ![height isEqualToString:@"auto"]){
            if([height hasSuffix:@"%"]){
                size.height = [height floatValue] * r.size.height / 100.0;
            }
            else{
                size.height = [height floatValue];
            }
        }
        else if(dr){
            size.height = size.width * dr;
        }
        
        [img setSize:size];
        
        [rich appendElement:img];
        
    }
    else if([name isEqualToString:@"a"] && [text length]){
        VTRichLinkElement * link = [[VTRichLinkElement alloc] init];
        [link setUserInfo:element];
        [link setHref:[element stringValueForKey:@"href" defaultValue:nil]];
        [rich appendElement:link text:text attributes:attr];
    }
    else{
        
        if([name isEqualToString:@"p"] || [name isEqualToString:@"div"]){
            if(![rich isNewLine]){
                [rich appendText:@"\n" attributes:attr];
            }
        }
        
        if([text length]){
            
            if(! [self willAppendText:text attributes:attr rich:rich]){
                [rich appendText:text attributes:attr];
            }
            
        }
        
        DVElement * p = element.firstChild;
        
        while (p) {
            
            [self elementToRichElement:p rich:rich attributes:attr];

            p = p.nextSibling;
        }
        
        if([name isEqualToString:@"p"] || [name isEqualToString:@"div"]){
            if(![rich isNewLine]){
                [rich appendText:@"\n" attributes:attr];
            }
        }
    }
}

-(BOOL) willAppendText:(NSString *)text attributes:(NSDictionary *)attributes rich:(VTRich *) rich{
    return NO;
}

-(VTRich *) rich{
    if(_rich == nil){
        
        _rich = [[VTRich alloc] init];
        
        _rich.font = [self fontValueForKey:@"font" defaultValue:[UIFont systemFontOfSize:[self doubleValueForKey:@"font-size" defaultValue:14]]];
        _rich.textColor = [self colorValueForKey:@"color" defaultValue:[UIColor blackColor]];
        _rich.linesSpacing = [self doubleValueForKey:@"line-spacing" defaultValue:2];
        _rich.charsetsSpacing = [self doubleValueForKey:@"charset-spacing" defaultValue:0];
        _rich.firstLineHeadIndent = [self doubleValueForKey:@"indent" defaultValue:0];
        _rich.paragraphSpacing = [self doubleValueForKey:@"paragraph-spacing" defaultValue:0];
        
        NSString * align = [self stringValueForKey:@"text-align" defaultValue:nil];
        
        if([align isEqualToString:@"left"]){
            _rich.textAlignment = kCTTextAlignmentLeft;
        }
        else if([align isEqualToString:@"right"]){
            _rich.textAlignment = kCTTextAlignmentRight;
        }
        else if([align isEqualToString:@"center"]){
            _rich.textAlignment = kCTTextAlignmentCenter;
        }
        else if([align isEqualToString:@"natural"]){
            _rich.textAlignment = kCTTextAlignmentNatural;
        }
        
        
        NSMutableDictionary * attr = [NSMutableDictionary dictionaryWithCapacity:4];
        
        CTFontRef font = CTFontCreateWithName((CFStringRef)_rich.font.fontName, _rich.font.pointSize + _rich.incFontSize, nil);
        [attr setValue:(__bridge id)font forKey:(id)kCTFontAttributeName];
        
        CFRelease(font);
        
        [attr setValue:(id)_rich.textColor.CGColor forKey:(id)kCTForegroundColorAttributeName];
        
        [self elementToRichElement:self rich:_rich attributes:attr];
        
    }
    return _rich;
}

-(void) drawInContext:(CGContextRef) context{
    
    CGSize size = self.frame.size;
    
    CGContextSetTextMatrix(context , CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    [self.rich drawContext:context withSize:size];

}


-(CGSize) layoutChildren:(UIEdgeInsets)padding{
    
    CGRect r = [self frame];
    
    if(r.size.width == MAXFLOAT || r.size.height == MAXFLOAT){
        
        CGSize s = [self.rich contentSizeWithSize:r.size];
        
        if(r.size.width == MAXFLOAT){
            r.size.width = s.width;
        }
        
        if(r.size.height == MAXFLOAT){
            r.size.height = s.height;
        }
        
        [self setFrame:r];
        
    }
    
    return r.size;
}

-(BOOL) isDetachChildren {
    return YES;
}

@end
