//
//  DVDocumentView.m
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import "DVDocumentView.h"
#import "DVCanvasElement.h"

@interface DVDocumentViewReuseObject : NSObject

@property(nonatomic,strong) NSString * reuse;
@property(nonatomic,assign) Class objectClass;
@property(nonatomic,strong) id object;

-(void) remove;

@end

@implementation DVDocumentViewReuseObject

-(void) remove {
    if([_object isKindOfClass:[CALayer class]]) {
        [(CALayer *) _object setDelegate:nil];
        [(CALayer *) _object removeFromSuperlayer];
    }
    else if([_object isKindOfClass:[DVDocumentView class]]) {
        [(DVDocumentView *) _object setElement:nil];
        [(DVDocumentView *) _object removeFromSuperview];
    }
    else if([_object isKindOfClass:[UIView class]]) {
        [(DVDocumentView *) _object removeFromSuperview];
    }
}

@end


@interface DVDocumentView() {
    NSMutableArray * _dequeueReuseObjects;
    NSMutableDictionary * _elementObjects;
    DVEventElement * _eventElement;
    DVLayoutElement * _layoutElement;
}

@end

@implementation DVDocumentView

-(void) dealloc{
    [_eventElement unbind:nil delegate:self];
}

-(void) setElement:(DVElement *)element {
    
    if(_element != element) {
        
        if(_dequeueReuseObjects == nil) {
            _dequeueReuseObjects = [[NSMutableArray alloc] initWithCapacity:4];
        }
        
        for (DVDocumentViewReuseObject * object in [_elementObjects allValues]) {
            [_dequeueReuseObjects addObject:object];
            [object remove];
        }
        
        [_elementObjects removeAllObjects];
        
        [_eventElement unbind:nil delegate:self];
        _element = element;
        _eventElement = [element elementByClass:[DVEventElement class]];
        _layoutElement = [element elementByClass:[DVLayoutElement class]];
        
        if(! [_layoutElement isLayouted]) {
            [_layoutElement layout:self.bounds.size];
        }
        
        [self setContentSize:_layoutElement.contentSize];
        
        [self reloadData];
        
    }

}

-(void) reloadData {
    
    NSMutableSet * keySet = [NSMutableSet setWithArray:[_elementObjects allKeys]];
    
    [self reloadData:_element keySet:keySet];
    
    for (NSString * key in keySet) {
        DVDocumentViewReuseObject * object = [_elementObjects objectForKey:key];
        [_dequeueReuseObjects addObject:object];
        [object remove];
        [_elementObjects removeObjectForKey:key];
    }
}

-(void) reloadData:(DVElement *) element keySet:(NSMutableSet *)keySet {
    
    NSString * key = [element elementId];
    
    [keySet removeObject:key];
    
    id object = [self elementObject:element];
    
    if([element isKindOfClass:[DVObjectElement class]] && [(DVObjectElement *) element isDetachChildren]) {
        return;
    }
    
    if([object isKindOfClass:[DVDocumentView class]]) {
        
        return;
    }
    
    DVElement * p = element.firstChild;
    
    while(p) {
        
        [self reloadData:p keySet:keySet];
        
        p = p.nextSibling;
    }
}

-(DVDocumentViewReuseObject *) reuseObjectElementClass:(Class) elementClass reuse:(NSString *) reuse {
    
    NSInteger i = 0;
    
    while (i < [_dequeueReuseObjects count]) {
        
        DVDocumentViewReuseObject * object = [_dequeueReuseObjects objectAtIndex:i];
        
        if((reuse == object.reuse || [reuse isEqualToString:object.reuse]) && object.class == [CALayer class] ) {
            
            [_dequeueReuseObjects removeObjectAtIndex:i];
            
            return object;
        }
        i ++;
    }
   
    
    return nil;
}

-(id) elementObject:(DVElement *) element {
    
    if([element isKindOfClass:[DVObjectElement class]]) {
        
        NSString * elementId = [element elementId];
        NSString * reuse = [element attr:@"reuse"];
        
        DVDocumentViewReuseObject * object = [_elementObjects objectForKey:elementId];
        
        if(object == nil) {
            
            object = [self reuseObjectElementClass:[CALayer class] reuse:reuse];
            
            if(object == nil) {
                object = [[DVDocumentViewReuseObject alloc] init];
                object.objectClass = [(DVObjectElement *) element objectClass];
                object.reuse = [element attr:@"reuse"];
                object.object = [CALayer layer];
            }
            
            if(_elementObjects == nil){
                _elementObjects = [[NSMutableDictionary alloc] initWithCapacity:4];
            }
            
            [_elementObjects setObject:object forKey:elementId];
            
            [object.object setObjectElement:(DVObjectElement *) element];

            if([object.object isKindOfClass:[CALayer class]]) {
            
                CALayer * layer = (CALayer *) object.object;
                
                CALayer * player = self.layer;
                CGRect frame = [(DVLayoutElement *) element frame];
                
                if(element == _layoutElement) {
                    frame.origin = CGPointZero;
                }
                else {
                    
                    DVElement * p = element.parent;
                    
                    while (p && p != _layoutElement) {
                        
                        id object = [self elementObject:p];
                        
                        if([object isKindOfClass:[CALayer class]]) {
                            player = (CALayer *) object;
                            break;
                        }
                        else if([object isKindOfClass:[UIView class]]) {
                            player = [(UIView *) object layer];
                            break;
                        }
                        else if([p isKindOfClass:[DVLayoutElement class]]) {
                            CGRect r = [(DVLayoutElement *) p frame];
                            frame.origin.x += r.origin.x;
                            frame.origin.y += r.origin.y;
                        }
                        
                        p = p.parent;
                    }
                }
                
                layer.delegate = element;
                layer.frame = frame;
                
                [player addSublayer:layer];
                
                [layer setNeedsDisplay];
            }
            
            if([object.object isKindOfClass:[UIView class]]) {
                
                UIView * view = (UIView *) object.object;
                
                UIView * pview = self;
                
                CGRect frame = [(DVLayoutElement *) element frame];
                
                if(element == _layoutElement) {
                    frame.origin = CGPointZero;
                }
                else {
                    
                    DVElement * p = element.parent;
                    
                    while (p && p != _layoutElement) {
                        
                        id object = [self elementObject:p];
                        
                        if([object isKindOfClass:[UIView class]]) {
                            pview = (UIView *) object;
                            break;
                        }
                        else if([p isKindOfClass:[DVLayoutElement class]]) {
                            CGRect r = [(DVLayoutElement *) p frame];
                            frame.origin.x += r.origin.x;
                            frame.origin.y += r.origin.y;
                        }
                        
                        p = p.parent;
                    }
                }
                
                [pview addSubview:view];
                
            }
            
            if([object.object isKindOfClass:[DVDocumentView class]]) {
                [(DVDocumentView *)object.object setElement:element];
            }
            
        }
        
        return [object object];
    }
    
    return nil;
}

@end
