//
//  DVDocumentView.m
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import "DVDocumentView.h"
#import "DVCanvasElement.h"
#import "DVTouchEvent.h"
#import "DVElement+Value.h"

@interface DVDocumentViewReuseObject : NSObject

@property(nonatomic,strong) NSString * reuse;
@property(nonatomic,assign) Class objectClass;
@property(nonatomic,strong) id object;

-(void) hide;

-(void) show;

@end

@implementation DVDocumentViewReuseObject

-(void) hide {
    if([_object isKindOfClass:[CALayer class]]) {
        [(CALayer *) _object setDelegate:nil];
        [(CALayer *) _object setHidden:YES];
    }
    else if([_object isKindOfClass:[DVDocumentView class]]) {
        [(DVDocumentView *) _object setElement:nil];
        [(DVDocumentView *) _object setHidden:YES];
    }
    else if([_object isKindOfClass:[UIView class]]) {
        [(DVDocumentView *) _object setHidden:YES];
    }
}

-(void) show {
    if([_object isKindOfClass:[CALayer class]]) {
        [(CALayer *) _object setHidden:NO];
    }
    else if([_object isKindOfClass:[DVDocumentView class]]) {
        [(DVDocumentView *) _object setHidden:NO];
    }
    else if([_object isKindOfClass:[UIView class]]) {
        [(DVDocumentView *) _object setHidden:NO];
    }
}

@end


@interface DVDocumentView() {
    NSMutableArray * _dequeueReuseObjects;
    NSMutableDictionary * _elementObjects;
    DVLayoutElement * _layoutElement;
    NSMutableDictionary * _touchElements;
}

@end

@implementation DVDocumentView

-(id) init {
    if ((self = [super init])) {
        
    }
    return self;
}
-(void) dealloc{
    [_element unbind:nil delegate:self];
}

-(void) setElement:(DVElement *)element {
    
    if(_element != element) {
        
        if(_dequeueReuseObjects == nil) {
            _dequeueReuseObjects = [[NSMutableArray alloc] initWithCapacity:4];
        }
        
        for (DVDocumentViewReuseObject * object in [_elementObjects allValues]) {
            [_dequeueReuseObjects addObject:object];
            [object hide];
        }
        
        [_elementObjects removeAllObjects];
        
        [_element unbind:nil delegate:self];
        _element = element;
        [_element bind:@"object" delegate:self];
        [_element bind:@"element" delegate:self];
        
        _layoutElement = [element elementByClass:[DVLayoutElement class]];
        
        if(! [_layoutElement isLayouted] && _allowLayoutElement) {
            [_layoutElement layout:self.bounds.size];
        }
        
        [self setContentSize:_layoutElement.contentSize];
        
        [self reloadData];
        
    }

}

-(void) reloadData {
    
    NSMutableSet * keySet = [NSMutableSet setWithArray:[_elementObjects allKeys]];
    
    DVElement * p = _element.firstChild;
    
    CGRect rect = self.bounds;
    
    rect.origin = self.contentOffset;
    
    while (p) {
        
        if([p isKindOfClass:[DVObjectElement class]] && [(DVObjectElement *)p reuse] == nil) {
            [self reloadData:p keySet:keySet];
        }
        else if([p isKindOfClass:[DVLayoutElement class]]) {
            
            CGRect frame = [(DVLayoutElement *) p frame];
            
            if(CGRectIntersectsRect(rect, frame)) {
                [self reloadData:p keySet:keySet];
            }
        }
        else {
            [self reloadData:p keySet:keySet];
        }
        
        p = p.nextSibling;
    }

    for (NSString * key in keySet) {
        DVDocumentViewReuseObject * object = [_elementObjects objectForKey:key];
        [_dequeueReuseObjects addObject:object];
        [object hide];
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

-(void) setContentOffset:(CGPoint)contentOffset {
    [super setContentOffset:contentOffset];
    
    [self reloadData];
    
}

-(DVDocumentViewReuseObject *) reuseObjectClass:(Class) objectClass reuse:(NSString *) reuse {
    
    NSInteger i = 0;
    
    while (i < [_dequeueReuseObjects count]) {
        
        DVDocumentViewReuseObject * object = [_dequeueReuseObjects objectAtIndex:i];
        
        if((reuse == object.reuse || [reuse isEqualToString:object.reuse]) && object.objectClass == objectClass ) {
            
            [object show];
            
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
        NSString * reuse = [(DVObjectElement *) element reuse];
        
        DVDocumentViewReuseObject * object = [_elementObjects objectForKey:elementId];
        
        if(object == nil) {
            
            Class objectClass = [(DVObjectElement *) element objectClass];
            
            object = [self reuseObjectClass:objectClass reuse:reuse];
            
            if(object == nil) {
                
                object = [[DVDocumentViewReuseObject alloc] init];
                object.objectClass = objectClass;
                object.reuse = reuse;
                
                if(object.objectClass == [UIView class] || [object.objectClass isSubclassOfClass:[UIView class]]) {
                    object.object = [[object.objectClass alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
                }
                else {
                    object.object = [[object.objectClass alloc] init];
                }
                
            }
            
            if(_elementObjects == nil){
                _elementObjects = [[NSMutableDictionary alloc] initWithCapacity:4];
            }
            
            [_elementObjects setObject:object forKey:elementId];
            
            if([object.object isKindOfClass:[CALayer class]]) {
            
                CALayer * layer = (CALayer *) object.object;
                
                layer.contentsScale = [[UIScreen mainScreen] scale];
                
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
                
                if(layer.superlayer != player) {
                    [player addSublayer:layer];
                }
            
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
                
                [view setFrame:frame];
                
                if(view.superview != pview) {
                    [pview addSubview:view];
                }
                
            }
            
            [object.object setObjectElement:(DVObjectElement *) element changedTypes:DVObjectElementChangedCanvas | DVObjectElementChangedAnimation | DVObjectElementChangedTransform ];
            
            if([object.object isKindOfClass:[DVDocumentView class]]) {
                [(DVDocumentView *)object.object setElement:element];
            }

            [DVElement sendEvent:[DVActionEvent actionEvent:@"visible" element:element] element:element];
            
        }
        
        return [object object];
    }
    
    return nil;
}

-(BOOL) dispatcher:(DVEventDispatcher *)dispatcher event:(DVEvent *)event {
    
    if([event isKindOfClass:[DVObjectEvent class]] && event.target != _element) {
        
        DVDocumentViewReuseObject * object = [_elementObjects valueForKey:[(DVElement *) event.target elementId]];
        
        [object.object setObjectElement:(DVObjectElement *) event.target changedTypes:[(DVObjectEvent *)event changedTypes]];
        
        event.cancelBubble = YES;
        
    }
    
    if([event isKindOfClass:[DVElementEvent class]]) {
        
        [_layoutElement layout];
        
        [self reloadData];
        
        event.cancelBubble = YES;
    }
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch * touch in touches) {
        
        [self touchesBegan:touch];
        
    }
    
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    for (UITouch * touch in touches) {
        [self touchesMoved:touch];
    }
    
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch * touch in touches) {
        
        [self touchesEnded:touch];
        
    }
    
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
    for (UITouch * touch in touches) {
        
        [self touchesCancelled:touch];
        
    }
    
    [super touchesCancelled:touches withEvent:event];
}


-(void) setObjectElement:(DVObjectElement *)element changedTypes:(DVObjectElementChangedType)changedTypes{
    [super setObjectElement:element changedTypes:changedTypes];
    self.pagingEnabled = [element booleanValueForKey:@"view-paging-enabled" defaultValue:NO];
    self.scrollEnabled = [element booleanValueForKey:@"view-scroll-enabled" defaultValue:NO];
    self.bounces = [element booleanValueForKey:@"view-bounces-enabled" defaultValue:NO];
    self.scrollsToTop = [element booleanValueForKey:@"view-scrolls-to-top" defaultValue:NO];
}

-(void) sizeToFit {
    
    CGRect r = [self frame];
    
    CGRect f = [_layoutElement frame];
    CGSize size = [_layoutElement contentSize];
    
    size.width = MAX(size.width, f.size.width);
    size.height = MAX(size.height, f.size.height);
    
    r.size = size;
    
    [self setFrame:r];
    
}

-(void) setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    if(_allowLayoutElement) {
        if(! [_layoutElement isLayouted]
           || !CGSizeEqualToSize(_layoutElement.layoutSize, self.bounds.size)) {
            [_layoutElement layout:self.bounds.size];
            [self setContentSize:_layoutElement.contentSize];
        }
    }
    
}

-(void) setBounds:(CGRect)bounds{
    [super setBounds:bounds];
    
    if(_allowLayoutElement) {
        if(! [_layoutElement isLayouted]
           || !CGSizeEqualToSize(_layoutElement.layoutSize, self.bounds.size)) {
            [_layoutElement layout:self.bounds.size];
            [self setContentSize:_layoutElement.contentSize];
        }
    }
}

-(DVDocumentView *) documentViewWithElement:(DVElement *) element {
    
    if(element == nil) {
        return nil;
    }
    
    if(element == _element) {
        return self;
    }
    
    DVDocumentViewReuseObject * reuseObject = [_elementObjects objectForKey:element.elementId];
    
    if([[reuseObject object] isKindOfClass:[DVDocumentView class]]) {
        return [reuseObject object];
    }
    
    return [self documentViewWithElement: element.parent ];
    
}

-(id) elementObjectWithElement:(DVElement *) element {
    
    if(element == _element) {
        return self;
    }
    
    DVDocumentView * documentView = [self documentViewWithElement: element];
    
    while(documentView) {
        
        DVDocumentView * docView = [documentView documentViewWithElement:element];
        
        if(docView == documentView) {
            
            if(documentView.element == element) {
                return documentView;
            }
            
            return [[documentView->_elementObjects valueForKey:element.elementId] object];
        }
        else {
            documentView = docView;
        }
        
        
    }
    
    return nil;
}

-(DVElement *) touchesBegan:(UITouch *) touche {
    
    NSString * touchId = [NSString stringWithFormat:@"0x%lx",(long) touche];
    
    CGPoint p = [touche locationInView:self];
    
    DVTouchEvent * e = [DVTouchEvent touchEvent:touchId touchX:p.x touchY:p.y eventType:DVTouchEventTypeBegin element:_element];
    
    DVElement * el = [DVElement dispatchEvent:e element:_element];
    
    if(el) {
        
        e.object = [[_elementObjects valueForKey:el.elementId] object];
        
        if(_touchElements  == nil) {
            _touchElements = [[NSMutableDictionary alloc] initWithCapacity:4];
        }
        
        [_touchElements setValue:el forKey:touchId];
        
        [DVElement sendEvent:e element:el];
       
    }
    
    return el;
}

-(DVElement *) touchesMoved:(UITouch *) touche {
    
    NSString * touchId = [NSString stringWithFormat:@"0x%lx",(long) touche];
    
    DVElement * el = [_touchElements objectForKey:touchId];
    
    if(el) {
        
        CGPoint p = [touche locationInView:self];
        
        DVTouchEvent * e = [DVTouchEvent touchEvent:touchId touchX:p.x touchY:p.y eventType:DVTouchEventTypeMoved element:_element];
        
        e.object = [[_elementObjects valueForKey:el.elementId] object];
        
        [DVElement sendEvent:e element:el];
        
    }

    return el;
}

-(DVElement *) touchesEnded:(UITouch *) touche {
    
    NSString * touchId = [NSString stringWithFormat:@"0x%lx",(long) touche];
    
    DVElement * el = [_touchElements objectForKey:touchId];
    
    if(el) {
        
        CGPoint p = [touche locationInView:self];
        
        DVTouchEvent * e = [DVTouchEvent touchEvent:touchId touchX:p.x touchY:p.y eventType:DVTouchEventTypeEnded element:_element];
        
        e.object = [[_elementObjects valueForKey:el.elementId] object];
        
        [DVElement sendEvent:e element:el];
        
    }

    return el;
}

-(DVElement *) touchesCancelled:(UITouch *) touche {
    
    NSString * touchId = [NSString stringWithFormat:@"0x%lx",(long) touche];
    
    DVElement * el = [_touchElements objectForKey:touchId];
    
    if(el) {
        
        CGPoint p = [touche locationInView:self];
        
        DVTouchEvent * e = [DVTouchEvent touchEvent:touchId touchX:p.x touchY:p.y eventType:DVTouchEventTypeCanceled element:_element];
        
        e.object = [[_elementObjects valueForKey:el.elementId] object];
        
        [DVElement sendEvent:e element:el];
        
    }
    
    return el;
}

@end
