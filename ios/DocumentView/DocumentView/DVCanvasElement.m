//
//  DVCanvasElement.m
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import "DVCanvasElement.h"
#import "DVElement+Value.h"
#import "DVTransformElement.h"
#import "DVAnimationElement.h"

@implementation CALayer (DVObjectElement)

-(void) setObjectElement:(DVCanvasElement *)element changedTypes:(DVObjectElementChangedType)changedTypes {
    
    self.borderColor = [[element borderColor] CGColor];
    self.borderWidth = [element borderWidth];
    self.masksToBounds = [element clips];
    self.cornerRadius = [element borderRadius];
    self.backgroundColor = [[element backgroundColor] CGColor];
    self.opacity = [self opacity];
    
    if(element.contents) {
        self.contents = [element contents];
    }

    if([element isNeedsDisplay]) {
        [self setNeedsDisplay];
    }
    
    if(changedTypes & DVObjectElementChangedAnimation) {
        
        [self removeAllAnimations];
        
        DVElement * p = element.firstChild;
        
        while (p) {
            
            if([p isKindOfClass:[DVAnimationElement class]]) {
                CABasicAnimation * anim = [(DVAnimationElement *) p animation];
                
                if(anim) {
                    [self addAnimation:anim forKey:anim.keyPath];
                }
            }
            
            p = p.nextSibling;
        }
        
    }
    
    if(changedTypes & DVObjectElementChangedTransform) {
        
        CATransform3D transform = CATransform3DIdentity;
        
        DVElement * p = element.firstChild;
        
        while (p) {
            
            if([p isKindOfClass:[DVTransformElement class]]) {
                transform = [(DVTransformElement *) p transform:transform];
            }
            
            p = p.nextSibling;
        }
        
        self.transform = transform;
        
    }
    
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

-(double) opacity {
    return [self doubleValueForKey:@"opacity" defaultValue:1 of:1.0];
}

-(id) attr:(NSString *) key value:(NSString *) value{
    [super attr:key value:value];
    
    if([key isEqualToString:@"hidden"]
       || [key isEqualToString:@"visabled"]
       || [key isEqualToString:@"border-radius"]
       || [key isEqualToString:@"background-color"]
       || [key isEqualToString:@"border-color"]
       || [key isEqualToString:@"border-width"]
       || [key isEqualToString:@"clips"]){
        [DVElement sendEvent:[DVObjectEvent objectEvent:self changedTypes:DVObjectElementChangedCanvas] element:self];
    }
    return self;
}

-(void) drawInContext:(CGContextRef) context{
    
}

-(void) drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    [self drawInContext:ctx];
}

-(BOOL) isNeedsDisplay {
    return YES;
}

-(BOOL) clips {
    return [self booleanValueForKey:@"clips" defaultValue:NO];
}

@end
