//
//  DVCanvasElement.m
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import "DVCanvasElement.h"
#import "DVElement+Value.h"


@implementation CALayer (DVObjectElement)

-(void) setObjectElement:(DVCanvasElement *)element {
    self.borderColor = [[element borderColor] CGColor];
    self.borderWidth = [element borderWidth];
    self.masksToBounds = self.borderWidth > 0;
    self.cornerRadius = [element borderRadius];
    self.backgroundColor = [[element backgroundColor] CGColor];
}

@end

@implementation DVCanvasEvent

+(id) canvasEvent:(DVElement *)element {
    
    DVCanvasEvent * event = [[DVCanvasEvent alloc] init];
    
    event.name = @"canvas";
    event.element = element;
    
    return event;
}

@end

@implementation DVCanvasElement

-(Class) objectClass{
    
    Class v = [super objectClass];
    
    if(v != [CALayer class] && ! [v isSubclassOfClass:[CALayer class]]) {
        return [CALayer class];
    }
    
    return v;
}

-(BOOL) isHidden{
    return [self booleanValueForKey:@"hidden" defaultValue:NO] || ! [self booleanValueForKey:@"visable" defaultValue:YES];
}

-(double) borderRadius{
    return [self doubleValueForKey:@"border-radius" defaultValue:0];
}

-(UIColor *) backgroundColor {
    return [self colorValueForKey:@"background-color" defaultValue:nil];
}

-(UIColor *) borderColor{
    return [self colorValueForKey:@"border-color" defaultValue:nil];
}

-(double) borderWidth{
    return [self doubleValueForKey:@"border-width" defaultValue:0];
}

-(id) attr:(NSString *) key value:(NSString *) value{
    [super attr:key value:value];
    
    if([key isEqualToString:@"hidden"]
       || [key isEqualToString:@"visabled"]
       || [key isEqualToString:@"border-radius"]
       || [key isEqualToString:@"background-color"]
       || [key isEqualToString:@"border-color"]
       || [key isEqualToString:@"border-width"]){
        [DVEventElement sendEvent:[DVCanvasEvent canvasEvent:self] element:self];
    }
    return self;
}

-(void) drawInContext:(CGContextRef) context{
    
}

-(void) drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    [self drawInContext:ctx];
}


@end
