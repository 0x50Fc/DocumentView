//
//  DVViewElement.m
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import "DVViewElement.h"
#import "DVElement+Value.h"
#import "DVTransformElement.h"
#import "DVAnimationElement.h"

@implementation UIView (DVObjectElement)

-(void) setObjectElement:(DVViewElement *)element changedTypes:(DVObjectElementChangedType)changedTypes{
    
    self.layer.borderColor = [[element borderColor] CGColor];
    self.layer.borderWidth = [element borderWidth];
    self.layer.cornerRadius = [element borderRadius];
    self.backgroundColor = [element backgroundColor];
    self.clipsToBounds = [element clips];
    
    if(changedTypes & DVObjectElementChangedAnimation) {
        
        [self.layer removeAllAnimations];
        
        DVElement * p = element.firstChild;
        
        while (p) {
            
            if([p isKindOfClass:[DVAnimationElement class]]) {
                CABasicAnimation * anim = [(DVAnimationElement *) p animation];
                
                if(anim) {
                    [self.layer addAnimation:anim forKey:anim.keyPath];
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
        
        self.layer.transform = transform;
        
    }
}

@end


@implementation DVViewElement

-(Class) objectClass{
    
    Class v = [super objectClass];
    
    if(v != [UIView class] && ! [v isSubclassOfClass:[UIView class]]) {
        return [UIView class];
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

-(BOOL) clips {
    return [self booleanValueForKey:@"clips" defaultValue:YES];
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

@end
