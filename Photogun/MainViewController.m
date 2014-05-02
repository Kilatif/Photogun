//
//  MainViewController.m
//  Photogun
//
//  Created by Vitaly Kolesnikov on 4/9/14.
//  Copyright (c) 2014 Vitaly Kolesnikov. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property (nonatomic, strong) VideoCapture *videoCapture;
@property (nonatomic, assign) HistogramType histogramType;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageTest.alpha = 0.7f;
    
    self.videoCapture = [[VideoCapture alloc] init];
    self.videoCapture.delegate = self.imageView;
    [self.videoCapture startCapture];
}

#pragma mark - UIComponents actions

- (IBAction)but1:(id)sender {

        //[self.imageView loadImageWithImage:image];
   
}


- (IBAction)but2:(id)sender {

    UIImageWriteToSavedPhotosAlbum([self.imageView getGLFrameImage], nil, nil, nil);
  //  [self.imageView loadImageWithImage:[UIImage imageNamed:@"test_image2.jpg"]];
}

- (IBAction)colorChanged:(id)sender
{
    [self.imageView setRedValue:self.colorSlider.value];
    
    [self.imageTest setHistogramImageWithData:[self.imageView getGLFramePixelData]];
    //[self.imageTest setImage:[self.imageView getGLFrameImage]];
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
