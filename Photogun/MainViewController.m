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
    
    UIImage *image = [self.imageView getGLFrameImage];
    //[self.imageView loadImageWithImage:image];
    [self.imageTest setImage:image];
}


- (IBAction)but2:(id)sender {

    UIImageWriteToSavedPhotosAlbum(self.imageTest.image, nil, nil, nil);
  //  [self.imageView loadImageWithImage:[UIImage imageNamed:@"test_image2.jpg"]];
}

- (IBAction)colorChanged:(id)sender
{
    [self.imageView setRedValue:self.colorSlider.value];
}

- (IBAction)frameFreeze:(UISwitch *)sender
{
    if (sender.on) [self.videoCapture startCapture];
    else [self.videoCapture stopCapture];
    
    
}

@end
