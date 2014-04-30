//
//  UIImage+Histogram.h
//  Photogun
//
//  Created by test on 4/30/14.
//  Copyright (c) 2014 Vitaly Kolesnikov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Histogram)

+(UIImage *)imageWithHistogramData:(NSArray *)histoData toSize:(CGSize)histoSize
                         withColor:(UIColor *)color andBackground:(UIColor *)backColor;

@end
