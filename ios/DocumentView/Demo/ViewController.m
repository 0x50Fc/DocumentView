//
//  ViewController.m
//  Demo
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import "ViewController.h"

#import <DocumentView/DocumentView.h>

@interface ViewController ()

@property(nonatomic,strong) DVDocument * document;
@property (strong, nonatomic) IBOutlet DVDocumentView *documentView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.document = [[DVDocument alloc] init];
    
    [_document.styleSheet addCSS:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ios" ofType:@"css"] encoding:NSUTF8StringEncoding error:nil]];
    
    [_document setRootElement:[_document elementWithXMLFile:[[NSBundle mainBundle] pathForResource:@"demo" ofType:@"xml"]]];
    
    
    [_documentView setElement:_document.rootElement];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
