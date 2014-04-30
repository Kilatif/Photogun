//
//  UIImage+Histogram.m
//  Photogun
//
//  Created by test on 4/30/14.
//  Copyright (c) 2014 Vitaly Kolesnikov. All rights reserved.
//

#import "UIImage+Histogram.h"

@implementation UIImage (Histogram)

+(UIImage *)imageWithHistogramData:(NSArray *)histoData toSize:(CGSize)histoSize
                         withColor:(UIColor *)color andBackground:(UIColor *)backColor
{
    UIGraphicsBeginImageContext(histoSize);
        
    CGContextRef bufContext = UIGraphicsGetCurrentContext();
    int width = histoSize.width;
    int height = histoSize.height;
    
    CGContextSetFillColorWithColor(bufContext, backColor.CGColor);
    CGContextFillRect(bufContext, CGRectMake(0, 0, width, height));
    CGContextSetStrokeColorWithColor(bufContext, color.CGColor);
    CGContextSetLineWidth(bufContext, histoSize.width / 256);
    
    for (int i = 0; i < 256; i++)
    {
        GLfloat curData = ((NSNumber *)histoData[i]).floatValue;
        
        CGContextMoveToPoint(bufContext, i, height);
        CGContextAddLineToPoint(bufContext, i, height - curData * height);
        CGContextStrokePath(bufContext);
    };
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
