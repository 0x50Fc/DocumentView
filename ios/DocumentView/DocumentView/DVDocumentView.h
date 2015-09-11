//
//  DVDocumentView.h
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import <DocumentView/DVElement.h>


@interface DVDocumentView : UIScrollView

@property(nonatomic,assign, getter=isAllowLayoutElement) BOOL allowLayoutElement;
@property(nonatomic,strong) DVElement * element;

-(void) reloadData;

-(id) elementObjectWithElement:(DVElement *) element;

-(void) touchesBegan:(UITouch *) touche withEvent:(UIEvent *)event element:(DVElement *) element;

-(void) touchesMoved:(UITouch *) touche withEvent:(UIEvent *)event element:(DVElement *) element;

-(void) touchesEnded:(UITouch *) touche withEvent:(UIEvent *)event element:(DVElement *) element;

-(void) touchesCancelled:(UITouch *) touche withEvent:(UIEvent *)event element:(DVElement *) element;

@end
