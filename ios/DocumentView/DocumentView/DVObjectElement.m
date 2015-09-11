//
//  DVObjectElement.m
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import "DVObjectElement.h"
#import "DVElement+Value.h"

@implementation DVObjectEvent

+(id) objectEvent:(DVElement *) element changedTypes:(DVObjectElementChangedType)changedTypes {
    
    DVObjectEvent * event = [[DVObjectEvent alloc] init];
    
    event.name = @"object";
    event.target = element;
    event.changedTypes = changedTypes;
    
    return event;
}

@end
@implementation DVObjectElement

-(Class) objectClass {
    NSString * v = [self stringValueForKey:@"object-class" defaultValue:nil];
    if([v length]) {
        return NSClassFromString(v);
    }
    return nil;
}

-(BOOL) isDetachChildren {
    return [self booleanValueForKey:@"object-detach-children" defaultValue:NO];
}

-(void) setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [DVElement sendEvent:[DVObjectEvent objectEvent:self changedTypes:DVObjectElementChangedCanvas] element:self];
}

-(id) attr:(NSString *) key value:(NSString *) value{
    [super attr:key value:value];
    
    if([key isEqualToString:@"enabled"]
       || [key isEqualToString:@"disabled"]
       || [key isEqualToString:@"selected"]
       || [key isEqualToString:@"class"]
       || [key isEqualToString:@"disabled-class"]
       || [key isEqualToString:@"highlighted-class"]
       || [key isEqualToString:@"selected-class"]){
        [DVElement sendEvent:[DVObjectEvent objectEvent:self changedTypes:DVObjectElementChangedCanvas] element:self];
    }
    
    return self;
}

-(void) setFrame:(CGRect)frame {
    CGRect r = [self frame];
    [super setFrame:frame];
    
    if(! CGRectEqualToRect(r, frame)) {
        [DVElement sendEvent:[DVObjectEvent objectEvent:self changedTypes:DVObjectElementChangedCanvas] element:self];
    }
}

-(NSString *) reuse {
    
    NSString * v = [self stringValueForKey:@"reuse" defaultValue:nil];
    
    if([v isEqualToString:@""]) {
        return nil;
    }
    
    return v;
}

@end


@implementation NSObject (DVObjectElement)

-(void) setObjectElement:(DVObjectElement *)element changedTypes:(DVObjectElementChangedType)changedTypes {
    
}

@end
