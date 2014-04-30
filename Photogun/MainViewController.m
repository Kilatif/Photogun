//
//  MainViewController.m
//  Photogun
//
//  Created by Vitaly Kolesnikov on 4/9/14.
//  Copyright (c) 2014 Vitaly Kolesnikov. All rights reserved.
//

#import "MainViewController.h"
#import "UIImage+Histogram.h"

@interface MainViewController ()

@property (nonatomic, strong) VideoCapture *videoCapture;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.videoCapture = [[VideoCapture alloc] init];
    self.videoCapture.delegate = self.imageView;
    [self.videoCapture startCapture];
}

#pragma mark - UIComponents actions

- (IBAction)but1:(id)sender {

        //[self.imageView loadImageWithImage:image];
    NSArray *histoData = [self.imageView histogramFromGLViewWithType:HistogramGreenChannel];
    [self.imageTest setImage:[UIImage imageWithHistogramData:histoData toSize:self.imageTest.frame.size
                              withColor:[UIColor colorWithRed:0 green:1 blue:0 alpha:1]
                          andBackground:[UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1]]];
}


- (IBAction)but2:(id)sender {

    UIImageWriteToSavedPhotosAlbum(self.imageTest.image, nil, nil, nil);
  //  [self.imageView loadImageWithImage:[UIImage imageNamed:@"test_image2.jpg"]];
}

- (IBAction)colorChanged:(id)sender
{
    [self.imageView setRedValue:self.colorSlider.value];
    
    NSArray *histoData = [self.imageView histogramFromGLViewWithType:HistogramGreenChannel];
    [self.imageTest setImage:[UIImage imageWithHistogramData:histoData toSize:self.imageTest.frame.size
                                                   withColor:[UIColor colorWithRed:0 green:1 blue:0 alpha:1]
                                               andBackground:[UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1]]];
}

- (IBAction)frameFreeze:(UISwitch *)sender
{
    
    if (sender.on) [self.videoCapture startCapture];
    else [self.videoCapture stopCapture];
    
    
}

- (void)setHistogramImageWithData:(NSArray *)histoData
{
    
}

@end
