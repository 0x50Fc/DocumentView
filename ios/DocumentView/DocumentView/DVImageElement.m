//
//  DVImageElement.m
//  DocumentView
//
//  Created by ZhangHailong on 15/9/7.
//  Copyright (c) 2015年 hailong.org. All rights reserved.
//

#import "DVImageElement.h"
#import "DVElement+Value.h"

@interface DVImageElement() {

}

@end

@implementation DVImageElement

@synthesize image = _image;

-(id) attr:(NSString *) key value:(NSString *) value{
    [super attr:key value:value];
    
    if([key isEqualToString:@"src"]){
        self.image = nil;
        [DVElement sendEvent:[DVObjectEvent objectEvent:self changedTypes:DVObjectElementChangedCanvas] element:self];
    }
    
    return self;
}

-(NSString *) src {
    return [self stringValueForKey:@"src" defaultValue:nil];
}

-(UIImage *) image {
 
    if(_image == nil && _loading == NO) {
        
        NSString * src = [self src];
        
        if([src length]) {
            
            if([src hasPrefix:@"@"]) {
                self.image = [UIImage imageNamed:[src substringFromIndex:1]];
            }
            else if([src hasPrefix:@"http://"] || [src hasPrefix:@"https://"]) {
                
            }
            else {
                
                NSFileManager * fileManager = [NSFileManager defaultManager];
                
                if([fileManager fileExistsAtPath:src isDirectory:nil]) {
                    
                    _loading = YES;
                    
                    NSString * source = [NSString stringWithString:src];
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                        UIImage * image = [UIImage imageNamed:source];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                           
                            if(_loading && [source isEqualToString:self.src]) {
                                
                                self.image = image;
                                
                                [DVElement sendEvent:[DVObjectEvent objectEvent:self changedTypes:DVObjectElementChangedCanvas] element:self];
                            }
                            
                        });
                    });
                }
            }
            
        }
        
    }
    
    return _image;
}

-(void) setImage:(UIImage *)image {
    _image = image;
    _loading = NO;
}

-(CGSize) layoutChildren:(UIEdgeInsets)padding{
    
    CGRect r = [self frame];
    
    if(r.size.width == MAXFLOAT || r.size.height == MAXFLOAT){
        
        UIImage * image = [self image];
        
        if(image) {
        
            if(r.size.width == MAXFLOAT && r.size.height != MAXFLOAT) {
                r.size.width = r.size.height * image.size.width / image.size.height;
                
                double v = [self doubleValueForKey:@"max-width" defaultValue:INT32_MAX];
                r.size.width = MIN(r.size.width, v);
                
                v = [self doubleValueForKey:@"min-width" defaultValue:0];
                r.size.width = MAX(r.size.width, v);
            }
            else if(r.size.height == MAXFLOAT && r.size.width != MAXFLOAT) {
                
                r.size.height = r.size.width * image.size.height / image.size.width;
                
                double v = [self doubleValueForKey:@"max-height" defaultValue:INT32_MAX];
                r.size.height = MIN(r.size.height, v);
                
                v = [self doubleValueForKey:@"min-height" defaultValue:0];
                r.size.height = MAX(r.size.height, v);
            }
            else {
                
                r.size.width = image.size.width;
                
                double v = [self doubleValueForKey:@"max-width" defaultValue:INT32_MAX];
                r.size.width = MIN(r.size.width, v);
                
                v = [self doubleValueForKey:@"min-width" defaultValue:0];
                r.size.width = MAX(r.size.width, v);

                r.size.height = image.size.height;
                
                v = [self doubleValueForKey:@"max-height" defaultValue:INT32_MAX];
                r.size.height = MIN(r.size.height, v);
                
                v = [self doubleValueForKey:@"min-height" defaultValue:0];
                r.size.height = MAX(r.size.height, v);

            }
        }
        else {
            
            if(r.size.width) {
                r.size.width = [self doubleValueForKey:@"min-width" defaultValue:16];
            }
            
            if(r.size.height) {
                r.size.height = [self doubleValueForKey:@"min-height" defaultValue:16];
            }
            
        }
        
        [self setFrame:r];
        
    }
    
    return r.size;
}

-(id) contents {
    return (id) [[self image] CGImage];
}

-(BOOL) isNeedsDisplay {
    return NO;
}

@end
