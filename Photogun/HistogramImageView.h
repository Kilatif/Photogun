//
//  HistogramImageView.h
//  Photogun
//
//  Created by test on 4/30/14.
//  Copyright (c) 2014 Vitaly Kolesnikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenGLView.h"

@interface HistogramImageView : UIImageView

@property (nonatomic, assign) HistogramType histogramType;
@property (nonatomic, strong) UIColor *histogramBackColor;

- (void)setHistogramImageWithData:(NSData *)data;

@end
