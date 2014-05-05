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

- (void)test:(int)n a:(float)a
{
    float sum = 100;
    
    float d = (sum - a * (2 * n + 1))/(n*n);
    
    for(int i = 0; i < n; i++)
    {
        float curVal = d * i + a;
        NSLog(@"%0.4f ", curVal / 100);
    }
    
    float state = d * n + a;
    NSLog(@"%0.4f ", state / 100);
    
    for(int i = 0; i < n; i++)
    {
        float curVal = d * (n - i - 1) + a;
        NSLog(@"%0.4f ", curVal / 100);
    }
}


- (IBAction)but2:(id)sender {

    [self.imageView setFilterValue:self.colorSlider.value withType:self.filterType.text.intValue];
   // [self.imageTest setHistogramImageWithData:[self.imageView getGLFramePixelData]];
    
    //UIImageWriteToSavedPhotosAlbum([self.imageView getGLFrameImage], nil, nil, nil);
  //  [self.imageView loadImageWithImage:[UIImage imageNamed:@"test_image2.jpg"]];
}

- (IBAction)colorChanged:(id)sender
{
    [self.imageView setFilterValue:self.colorSlider.value withType:self.filterType.text.intValue];
    
    //[self.imageTest setHistogramImageWithData:[self.imageView getGLFramePixelData]];
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

- (IBAction)textReturn:(UITextField *)sender {
    [sender resignFirstResponder];
}

@end
