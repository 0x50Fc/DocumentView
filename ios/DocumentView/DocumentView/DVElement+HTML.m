//
//  DVElement+HTML.m
//  DocumentView
//
//  Created by ZhangHailong on 15/9/11.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import "DVElement+HTML.h"
#include <libxml/parser.h>
#include <libxml/xmlwriter.h>

static int DVElement_HTML_writer_xmlOutputWriteCallback (void * context, const char * buffer,
                                                        int len) {
    
    NSMutableData * data = (__bridge NSMutableData *) context;
    
    [data appendBytes:buffer length:len];
    
    return 0;
}

static int DVElement_HTML_writer_xmlOutputCloseCallback (void * context){
    
    return 0;
}

static void DVElement_HTML_write(xmlTextWriterPtr ctx, DVElement * element) {
    
    xmlTextWriterStartElement(ctx, (xmlChar *) [element.name UTF8String]);
    
    for (NSString * key in [element keys]) {
        NSString * v = [element attr:key];
        xmlTextWriterStartAttribute(ctx, (xmlChar *) [key UTF8String]);
        xmlTextWriterWriteRaw(ctx, (xmlChar *) [v UTF8String]);
        xmlTextWriterEndAttribute(ctx);
    }
    
    
    DVElement * p = element.firstChild;
    
    if(p) {
        
        while (p) {
            
            DVElement_HTML_write(ctx,p);
            
            p = p.nextSibling;
        }
    }
    else if(element.textContent) {
        xmlTextWriterWriteRaw(ctx, (xmlChar *) [element.textContent UTF8String]);
        xmlTextWriterEndAttribute(ctx);
    }
    
    xmlTextWriterEndElement(ctx);
    
}


@implementation DVElement (HTML)

-(NSString *) innerHTML {
    
    NSMutableData * data = [[NSMutableData alloc] initWithCapacity:32];
    
    xmlOutputBufferPtr buffer = xmlOutputBufferCreateIO(DVElement_HTML_writer_xmlOutputWriteCallback, DVElement_HTML_writer_xmlOutputCloseCallback, (__bridge void *)(data), xmlGetCharEncodingHandler(XML_CHAR_ENCODING_UTF8));
    
    xmlTextWriterPtr ctx = xmlNewTextWriter(buffer);
    
    DVElement * p = self.firstChild;
    
    while (p) {
        
        DVElement_HTML_write(ctx,p);
        
        p = p.nextSibling;
    }
    
    xmlTextWriterFlush(ctx);
    
    xmlFreeTextWriter(ctx);
    
    xmlOutputBufferClose(buffer);
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
}

@end
