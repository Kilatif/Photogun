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
    
    [self.imageView loadImageWithName:@"test_image.jpg"];
    //[self loadImageWithName:@"test_image.jpg"];
}


- (IBAction)but2:(id)sender {
    [self.imageView loadImageWithName:@"test_image2.jpg"];
}

- (IBAction)colorChanged:(id)sender {
    NSLog(@">>>>> COLOR VALUE %f: ", self.colorSlider.value);
    
    [self.imageView setRedValue:self.colorSlider.value];
}


@end
