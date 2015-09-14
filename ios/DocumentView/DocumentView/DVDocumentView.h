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

-(DVElement *) touchesBegan:(UITouch *) touche;

-(DVElement *) touchesMoved:(UITouch *) touche;

-(DVElement *) touchesEnded:(UITouch *) touche;

-(DVElement *) touchesCancelled:(UITouch *) touche;

@end
