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
    self.imageView.delegate = self;
    
    self.videoCapture = [[VideoCapture alloc] init];
    self.videoCapture.delegate = self.imageView;
    self.videoCapture.imageDelegate = self;

    [self.videoCapture startCapture];
}

#pragma mark - UIComponents actions

- (IBAction)but2:(id)sender {
    [self.videoCapture captureImage];
}

- (IBAction)colorChanged:(id)sender
{
    [self.imageView setFilterValue:self.colorSlider.value withType:self.filterType.text.intValue];
    
    [self.imageTest setHistogramImageWithData:[self.imageView getGLFramePixelData]];
    //[self.imageTest setImage:[self.imageView getGLFrameImage]];
}

- (IBAction)frameFreeze:(UISwitch *)sender
{
    
    if (sender.on) [self.videoCapture startCapture];
    else [self.videoCapture stopCapture];
}

- (IBAction)textReturn:(UITextField *)sender {
    [sender resignFirstResponder];
}

- (void)touchedView:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    
    location.x /= self.imageView.frame.size.width;
    location.y /= self.imageView.frame.size.height;
    
    [self.videoCapture setDeviceFocus:location];
}

- (void)imageCaptured:(UIImage *)capturedImage
{
    [self.videoCapture stopCapture];
    [self.imageView loadImageWithImage:capturedImage];
}

@end
