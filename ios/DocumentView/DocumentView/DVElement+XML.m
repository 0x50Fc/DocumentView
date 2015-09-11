//
//  DVElement+XML.m
//  DocumentView
//
//  Created by ZhangHailong on 15/9/11.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import "DVElement+XML.h"
#include <libxml/parser.h>
#include <libxml/xmlwriter.h>

static int DVElement_XML_writer_xmlOutputWriteCallback (void * context, const char * buffer,
                                                  int len) {
    
    NSMutableData * data = (__bridge NSMutableData *) context;
    
    [data appendBytes:buffer length:len];
    
    return 0;
}

static int DVElement_XML_writer_xmlOutputCloseCallback (void * context){
    
    return 0;
}

static void DVElement_XML_write(xmlTextWriterPtr ctx, DVElement * element) {
    
    xmlTextWriterStartElement(ctx, (xmlChar *) [element.name UTF8String]);
    
    for (NSString * key in [element keys]) {
        NSString * v = [element attr:key];
        xmlTextWriterStartAttribute(ctx, (xmlChar *) [key UTF8String]);
        xmlTextWriterWriteString(ctx, (xmlChar *) [v UTF8String]);
        xmlTextWriterEndAttribute(ctx);
    }
    
    
    DVElement * p = element.firstChild;
    
    if(p) {
    
        while (p) {
            
            DVElement_XML_write(ctx,p);
            
            p = p.nextSibling;
        }
    }
    else if(element.textContent) {
        xmlTextWriterWriteString(ctx, (xmlChar *) [element.textContent UTF8String]);
    }
    
    xmlTextWriterEndElement(ctx);
    
}

@implementation DVElement (XML)

-(NSString *) innerXML {
    
    NSMutableData * data = [[NSMutableData alloc] initWithCapacity:32];
    
    xmlOutputBufferPtr buffer = xmlOutputBufferCreateIO(DVElement_XML_writer_xmlOutputWriteCallback, DVElement_XML_writer_xmlOutputCloseCallback, (__bridge void *)(data), xmlGetCharEncodingHandler(XML_CHAR_ENCODING_UTF8));
    
    xmlTextWriterPtr ctx = xmlNewTextWriter(buffer);
    
    DVElement * p = self.firstChild;
    
    while (p) {
        
        DVElement_XML_write(ctx,p);

        p = p.nextSibling;
    }

    xmlFreeTextWriter(ctx);
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
}

@end
