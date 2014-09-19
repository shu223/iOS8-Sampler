//
//  RubyAnnotationLabel.m
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/09/19.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//
//  Thanks to:
//  http://nshipster.com/ios8/
//  http://dev.classmethod.jp/references/ios8-ctrubyannotationref/


#import "RubyAnnotationLabel.h"
@import CoreText;


@interface RubyAnnotationLabel ()
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *furigana;
@end


@implementation RubyAnnotationLabel

- (void)drawRect:(CGRect)rect {

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    CGAffineTransform transform = CGAffineTransformMakeScale(1, -1);
    transform = CGAffineTransformTranslate(transform, 0, - self.bounds.size.height);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    CGContextTranslateCTM(ctx, 0, ([self bounds]).size.height );
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    CTLineRef line = CTLineCreateWithAttributedString([self attributedStringRef]);
    
    // centering
    CGRect lineBounds = CTLineGetBoundsWithOptions(line, 0);
    CGContextSetTextPosition(context,
                             self.center.x - lineBounds.size.width / 2,
                             self.center.y - lineBounds.size.height / 2);

    CTLineDraw(line, context);
    
    CFRelease(line);
}


// =============================================================================
#pragma mark - Private

// create CFAttributedStringRef
- (CFAttributedStringRef)attributedStringRef {
    
    // Ruby Annotation
    CFStringRef furiganaRef[kCTRubyPositionCount] = {
        (__bridge CFStringRef) self.furigana, NULL, NULL, NULL
    };
    CTRubyAnnotationRef ruby = CTRubyAnnotationCreate(kCTRubyAlignmentAuto, kCTRubyOverhangAuto, 0.5, furiganaRef);
    
    // Font
    CTFontRef font = CTFontCreateWithName(CFSTR("HiraMinProN-W6"), 50, NULL);
    
    
    CFStringRef keys[] = { kCTFontAttributeName, kCTRubyAnnotationAttributeName};
    CFTypeRef values[] = { font, ruby};
    
    CFDictionaryRef attr = CFDictionaryCreate(NULL,
                                              (const void **)&keys,
                                              (const void **)&values,
                                              sizeof(keys) / sizeof(keys[0]),
                                              &kCFTypeDictionaryKeyCallBacks,
                                              &kCFTypeDictionaryValueCallBacks);
    
    CFAttributedStringRef attributes = CFAttributedStringCreate(NULL, (__bridge CFStringRef)self.text, attr);
    CFRelease(attr);
    
    return attributes;
}


// =============================================================================
#pragma mark - Public

- (void)setText:(NSString *)text withFurigana:(NSString *)furigana {

    self.text = text;
    self.furigana = furigana;
    
    [self setNeedsDisplay];
}

@end
