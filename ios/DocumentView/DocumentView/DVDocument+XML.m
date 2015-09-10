//
//  DVDocument+XML.m
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import "DVDocument+XML.h"

#include <libxml/parser.h>

@interface DVDocument_XML_parser : NSObject

@property(nonatomic,strong) DVDocument * document;
@property(nonatomic,strong) DVElement * element;
@property(nonatomic,strong) DVElement * current;
@property(nonatomic,strong) NSMutableData * textContent;

@end

@implementation DVDocument_XML_parser

@synthesize document = _document;
@synthesize element = _element;
@synthesize current = _current;
@synthesize textContent = _textContent;

@end


static void DVDocument_XML_startElementSAXFunc (void *ctx,
                                         const xmlChar *name,
                                         const xmlChar **atts){
    
    DVDocument_XML_parser * parser = (__bridge DVDocument_XML_parser *) ctx;
    
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
    
    [parser.textContent setLength:0];
}

static void DVDocument_XML_endElementSAXFunc (void *ctx,
                                       const xmlChar *name){
    
    DVDocument_XML_parser * parser = (__bridge DVDocument_XML_parser *) ctx;
    
    NSString * n = [NSString stringWithUTF8String:(char *) name];
    
    if([parser.current.name isEqualToString:n]) {
        
        if(parser.current.firstChild == nil && [parser.textContent length]) {
            parser.current.textContent = [[NSString alloc] initWithData:[parser textContent] encoding:NSUTF8StringEncoding];
        }
        
        [parser.textContent setLength:0];
        
        parser.current = parser.current.parent;
    }


}

static void DVDocument_XML_charactersSAXFunc (void *ctx,
                                       const xmlChar *ch,
                                       int len){
    
    DVDocument_XML_parser * parser = (__bridge DVDocument_XML_parser *) ctx;
    
    if(parser.textContent == nil) {
        parser.textContent = [NSMutableData dataWithCapacity:64];
    }
    
    [parser.textContent appendBytes:ch length:len];
    
}

static void DVDocument_XML_ignorableWhitespaceSAXFunc (void *ctx,
                                                const xmlChar *ch,
                                                int len){
    
}

static void DVDocument_XML_warningSAXFunc (void *ctx,
                                    const char *msg,...) {
    va_list ap;
    
    va_start(ap, msg);
    
    NSLogv([NSString stringWithUTF8String:msg], ap);
    
    va_end(ap);
    
}

static void DVDocument_XML_errorSAXFunc (void *ctx,
                                  const char *msg,...) {
    
    va_list ap;
    
    va_start(ap, msg);
    
    NSLogv([NSString stringWithUTF8String:msg], ap);
    
    va_end(ap);
    
}

@implementation DVDocument (XML)

-(DVElement *) elementWithXMLContent:(NSString *) xmlContent {
    
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
        DVDocument_XML_startElementSAXFunc,
        DVDocument_XML_endElementSAXFunc,
        NULL,
        DVDocument_XML_charactersSAXFunc,
        DVDocument_XML_ignorableWhitespaceSAXFunc,
        NULL,
        NULL,
        DVDocument_XML_warningSAXFunc,
        DVDocument_XML_errorSAXFunc,
        DVDocument_XML_errorSAXFunc,
        NULL,
        NULL,
        NULL,
        XML_SAX2_MAGIC,
        NULL,
        NULL,
        NULL,
        NULL
    };
    
    DVDocument_XML_parser * parser = [[DVDocument_XML_parser alloc] init];
    
    parser.document = self;

    xmlParserCtxtPtr ctx = xmlCreatePushParserCtxt(& handler, (__bridge void *)(parser), NULL, 0, NULL);
    
    NSData * data = [xmlContent dataUsingEncoding:NSUTF8StringEncoding];
    
    xmlParseChunk(ctx, [data bytes], (int) [data length], 0);
    
    xmlParseChunk(ctx, NULL, 0, 1);
    
    xmlFreeParserCtxt(ctx);
    
    return [parser element];
}

-(DVElement *) elementWithXMLFile:(NSString *) xmlFile {
    
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
        DVDocument_XML_startElementSAXFunc,
        DVDocument_XML_endElementSAXFunc,
        NULL,
        DVDocument_XML_charactersSAXFunc,
        DVDocument_XML_ignorableWhitespaceSAXFunc,
        NULL,
        NULL,
        DVDocument_XML_warningSAXFunc,
        DVDocument_XML_errorSAXFunc,
        DVDocument_XML_errorSAXFunc,
        NULL,
        NULL,
        NULL,
        XML_SAX2_MAGIC,
        NULL,
        NULL,
        NULL,
        NULL
    };
    
    DVDocument_XML_parser * parser = [[DVDocument_XML_parser alloc] init];
    
    parser.document = self;
    
    xmlParserCtxtPtr ctx = xmlCreatePushParserCtxt(& handler, (__bridge void *)(parser), NULL, 0, NULL);
    
    char data[20480];
    size_t len;
    
    FILE * fd = fopen([xmlFile UTF8String], "rb");
    
    if(fd){
        
        while( (len = fread(data, 1, sizeof(data), fd)) > 0){
            
            xmlParseChunk(ctx, data, (int)  len, 0);
            
        }
        
        fclose(fd);
    }
    
    xmlParseChunk(ctx, NULL, 0, 1);
    
    xmlFreeParserCtxt(ctx);
    
    return [parser element];
}

@end
