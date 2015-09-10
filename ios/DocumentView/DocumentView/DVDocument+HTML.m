//
//  DVDocument+HTML.m
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import "DVDocument+HTML.h"
#include <libxml/HTMLparser.h>

@interface DVDocument_HTML_parser : NSObject

@property(nonatomic,strong) DVDocument * document;
@property(nonatomic,strong) DVElement * element;
@property(nonatomic,strong) DVElement * current;
@property(nonatomic,strong) NSMutableData * textContent;

@end

@implementation DVDocument_HTML_parser

@synthesize document = _document;
@synthesize element = _element;
@synthesize current = _current;
@synthesize textContent = _textContent;

@end


static void DVDocument_HTML_startElementSAXFunc (void *ctx,
                                                const xmlChar *name,
                                                const xmlChar **atts){
    
    DVDocument_HTML_parser * parser = (__bridge DVDocument_HTML_parser *) ctx;
    
    const xmlChar ** pattrs = atts;
    
    NSMutableDictionary * attrs = [NSMutableDictionary dictionaryWithCapacity:4];
    
    while(pattrs && * pattrs){
        
        NSString * key = [NSString stringWithUTF8String: (char *) * pattrs];
        
        pattrs ++ ;
        
        if( * pattrs){
            
            [attrs setValue:[NSString stringWithUTF8String: (char *) * pattrs] forKey:key];
            
            pattrs ++;
        }
        
    }
    
    DVElement * el = [parser.document elementWithName:[NSString stringWithUTF8String:(char *) name] attributes:attrs elementId:nil];

    if(parser.element == nil) {
        parser.element = el;
    }
    
    if(parser.current == nil) {
        parser.current = el;
    }
    else {
        [parser.current append:el];
        parser.current = el;
    }
}

static void DVDocument_HTML_endElementSAXFunc (void *ctx,
                                              const xmlChar *name){
    
    DVDocument_HTML_parser * parser = (__bridge DVDocument_HTML_parser *) ctx;
    
    NSString * n = [NSString stringWithUTF8String:(char *) name];
    
    if([parser.current.name isEqualToString:n]) {
        
        if(parser.current.firstChild == nil && [parser.textContent length]) {
            parser.current.textContent = [[NSString alloc] initWithData:[parser textContent] encoding:NSUTF8StringEncoding];
        }
        
        [parser.textContent setLength:0];
        
        parser.current = parser.current.parent;
    }
    
}

static void DVDocument_HTML_charactersSAXFunc (void *ctx,
                                              const xmlChar *ch,
                                              int len){
    
    DVDocument_HTML_parser * parser = (__bridge DVDocument_HTML_parser *) ctx;
    
    if(parser.textContent == nil) {
        parser.textContent = [NSMutableData dataWithCapacity:64];
    }
    
    [parser.textContent appendBytes:ch length:len];
    
}

static void DVDocument_HTML_ignorableWhitespaceSAXFunc (void *ctx,
                                                       const xmlChar *ch,
                                                       int len){
    
}

static void DVDocument_HTML_warningSAXFunc (void *ctx,
                                           const char *msg,...) {
    va_list ap;
    
    va_start(ap, msg);
    
    NSLogv([NSString stringWithUTF8String:msg], ap);
    
    va_end(ap);
    
}

static void DVDocument_HTML_errorSAXFunc (void *ctx,
                                         const char *msg,...) {
    
    va_list ap;
    
    va_start(ap, msg);
    
    NSLogv([NSString stringWithUTF8String:msg], ap);
    
    va_end(ap);
    
}

@implementation DVDocument (HTML)

-(DVElement *) elementWithHTMLContent:(NSString *) htmlContent {
    
    htmlSAXHandler handler = {
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        DVDocument_HTML_startElementSAXFunc,
        DVDocument_HTML_endElementSAXFunc,
        NULL,
        DVDocument_HTML_charactersSAXFunc,
        DVDocument_HTML_ignorableWhitespaceSAXFunc,
        NULL,
        NULL,
        DVDocument_HTML_warningSAXFunc,
        DVDocument_HTML_errorSAXFunc,
        DVDocument_HTML_errorSAXFunc,
        NULL,
        NULL,
        NULL,
        XML_SAX2_MAGIC,
        NULL,
        NULL,
        NULL,
        NULL
    };
    
    DVDocument_HTML_parser * parser = [[DVDocument_HTML_parser alloc] init];
    
    parser.document = self;
    
    htmlParserCtxtPtr ctx = htmlCreatePushParserCtxt(& handler, (__bridge void *)(parser), NULL, 0, NULL,XML_CHAR_ENCODING_UTF8);
    
    NSData * data = [htmlContent dataUsingEncoding:NSUTF8StringEncoding];
    
    htmlParseChunk(ctx, [data bytes], (int) [data length], 0);
    
    htmlParseChunk(ctx, NULL, 0, 1);
    
    htmlFreeParserCtxt(ctx);
    
    return [parser element];
}

-(DVElement *) elementWithHTMLFile:(NSString *) htmlFile {
    
    struct _xmlSAXHandler handler = {
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        DVDocument_HTML_startElementSAXFunc,
        DVDocument_HTML_endElementSAXFunc,
        NULL,
        DVDocument_HTML_charactersSAXFunc,
        DVDocument_HTML_ignorableWhitespaceSAXFunc,
        NULL,
        NULL,
        DVDocument_HTML_warningSAXFunc,
        DVDocument_HTML_errorSAXFunc,
        DVDocument_HTML_errorSAXFunc,
        NULL,
        NULL,
        NULL,
        XML_SAX2_MAGIC,
        NULL,
        NULL,
        NULL,
        NULL
    };
    
    DVDocument_HTML_parser * parser = [[DVDocument_HTML_parser alloc] init];
    
    parser.document = self;
    
    htmlParserCtxtPtr ctx = htmlCreatePushParserCtxt(& handler, (__bridge void *)(parser), NULL, 0, NULL,XML_CHAR_ENCODING_UTF8);
    
    char data[20480];
    size_t len;
    
    FILE * fd = fopen([htmlFile UTF8String], "rb");
    
    if(fd){
        
        while( (len = fread(data, 1, sizeof(data), fd)) > 0){
            
            htmlParseChunk(ctx, data, (int)  len, 0);
            
        }
        
        fclose(fd);
    }
    
    htmlParseChunk(ctx, NULL, 0, 1);
    
    htmlFreeParserCtxt(ctx);
    
    return [parser element];
}

@end
