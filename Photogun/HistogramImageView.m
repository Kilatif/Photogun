//
//  HistogramImageView.m
//  Photogun
//
//  Created by test on 4/30/14.
//  Copyright (c) 2014 Vitaly Kolesnikov. All rights reserved.
//

#import "HistogramImageView.h"

@interface HistogramImageView()

@property (nonatomic, strong) NSData *imageData;

@end

@implementation HistogramImageView

@synthesize imageData;
@synthesize histogramBackColor;
@synthesize histogramType;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.histogramBackColor = [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f];
        self.histogramType = HistogramRedChannel;
    }
    return self;
}

- (void)setHistogramImageWithData:(NSData *)data
{
    self.imageData = data;
    UIImage *image = [self histogramImageFromImageData:data];
    [self setImage:image];
}

- (UIImage *)histogramImageFromImageData:(NSData *)data
{
    NSArray *histoData = [self histogramFromData:data];
    
    UIGraphicsBeginImageContext(self.frame.size);
    
    UIColor *lineColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    if (self.histogramType == HistogramRedChannel)
        lineColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    if (self.histogramType == HistogramGreenChannel)
        lineColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:1];
    if (self.histogramType == HistogramBlueChannel)
        lineColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:1];
    
    CGContextRef bufContext = UIGraphicsGetCurrentContext();
    int width = self.frame.size.width;
    int height = self.frame.size.height;
    
    CGContextSetFillColorWithColor(bufContext, self.histogramBackColor.CGColor);
    CGContextFillRect(bufContext, CGRectMake(0, 0, width, height));
    CGContextSetStrokeColorWithColor(bufContext, lineColor.CGColor);
    CGContextSetLineWidth(bufContext, width / 256);
    
    for (int i = 0; i < 256; i++)
    {
        GLfloat curData = ((NSNumber *)histoData[i]).floatValue;
        
        CGContextMoveToPoint(bufContext, i, height);
        CGContextAddLineToPoint(bufContext, i, height - curData * height);
        CGContextStrokePath(bufContext);
    };
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;

}

- (NSArray *)histogramFromData:(NSData *)pixelData
{
    NSMutableArray *arrayResult = [NSMutableArray array];
    GLfloat *result = (GLfloat *)malloc(256 * sizeof(GLfloat));
    GLubyte *pixelDataBuffer = (GLubyte *)[pixelData bytes];
    
    for (int i = 0; i < 256; i++)
    result[i] = 0;
    
    for (int i = 0; i < pixelData.length / 4; i ++)
        result[pixelDataBuffer[i * 4 + self.histogramType]]++;
    
    for (int i = 0; i < 256; i++)
    {
        result[i] /= 1000;
        [arrayResult addObject:@(result[i])];
    }
    
    free(result);
    
    return arrayResult;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.histogramType++;
    if (self.histogramType > HistogramBlueChannel)
        self.histogramType = HistogramRedChannel;
    
    [self setHistogramImageWithData:self.imageData];
}

@end
