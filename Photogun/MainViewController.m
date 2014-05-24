//
//  MainViewController.m
//  Photogun
//
//  Created by Vitaly Kolesnikov on 4/9/14.
//  Copyright (c) 2014 Vitaly Kolesnikov. All rights reserved.
//

#import "MainViewController.h"
#import "ContextOptionsView.h"

@interface MainViewController ()

@property (nonatomic, strong) VideoCapture *videoCapture;
@property (nonatomic, assign) HistogramType histogramType;

@property (nonatomic, strong) ContextOptionsView *shadowsConetxtView;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *redValue = @{[ContextOptionsView COMPONENT_NAME] : @"redValue",
                               [ContextOptionsView LEFT_DESCRIPTION_VALUE] : @"Голубой",
                               [ContextOptionsView RIGHT_DESCRIPTION_VALUE] : @"Красный",
                               [ContextOptionsView SLIDER_MIN_COLOR] : [UIColor colorWithRed:0.78f green:0.0f blue:0.0f alpha:1.0f],
                               [ContextOptionsView SLIDER_MAX_COLOR] : [UIColor colorWithRed:0.0f green:0.78f blue:0.78f alpha:1.0f]};
    
    NSDictionary *greenValue = @{[ContextOptionsView COMPONENT_NAME] : @"greenValue",
                               [ContextOptionsView LEFT_DESCRIPTION_VALUE] : @"Пурпурный",
                               [ContextOptionsView RIGHT_DESCRIPTION_VALUE] : @"Зеленый",
                               [ContextOptionsView SLIDER_MIN_COLOR] : [UIColor colorWithRed:0.78f green:0.0f blue:0.0f alpha:1.0f],
                               [ContextOptionsView SLIDER_MAX_COLOR] : [UIColor colorWithRed:0.0f green:0.78f blue:0.78f alpha:1.0f]};
    
    NSDictionary *blueValue = @{[ContextOptionsView COMPONENT_NAME] : @"blueValue",
                               [ContextOptionsView LEFT_DESCRIPTION_VALUE] : @"Желтый",
                               [ContextOptionsView RIGHT_DESCRIPTION_VALUE] : @"Синий",
                               [ContextOptionsView SLIDER_MIN_COLOR] : [UIColor colorWithRed:0.78f green:0.0f blue:0.0f alpha:1.0f],
                               [ContextOptionsView SLIDER_MAX_COLOR] : [UIColor colorWithRed:0.0f green:0.78f blue:0.78f alpha:1.0f]};
    
    self.shadowsConetxtView = [[ContextOptionsView alloc] initWithFrame:CGRectMake(0, 30, 320, 210)
                                                          andComponents:@[redValue, greenValue, blueValue]];
    [self.view addSubview:self.shadowsConetxtView];
    
   // [self.test setMaximumTrackTintColor:[UIColor redColor]];
    self.imageHisto.alpha = 0.7f;
    self.imageView.delegate = self;
    
    self.videoCapture = [[VideoCapture alloc] init];
    self.videoCapture.delegate = self.imageView;
    self.videoCapture.imageDelegate = self;

    [self.videoCapture startCapture];
}

#pragma mark - UIComponents actions

- (IBAction)testSwitch:(UISwitch *)sender
{
    [self.shadowsConetxtView show:sender.on];
}



/*
- (IBAction)but2:(id)sender {
    [self.videoCapture captureImage];
}

- (IBAction)colorChanged:(id)sender
{
    [self.imageView setFilterValue:self.colorSlider.value withType:self.filterType.text.intValue];
    
    [self.imageTest setHistogramImageWithData:[self.imageView getGLFramePixelData]];
}

- (IBAction)frameFreeze:(UISwitch *)sender
{
    
    if (sender.on) [self.videoCapture startCapture];
    else [self.videoCapture stopCapture];
}

- (IBAction)textReturn:(UITextField *)sender {
    [sender resignFirstResponder];
}*/

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
- (IBAction)testSwipe:(id)sender {
    self.testView.frame = CGRectMake(self.testView.frame.origin.x, 360,
                                     self.testView.frame.size.width, 210);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25f];
    [UIView setAnimationDelay:0.0f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    self.testView.frame = CGRectMake(self.testView.frame.origin.x, 570,
                                     self.testView.frame.size.width, 0);
    
    [UIView commitAnimations];
}

- (IBAction)testTouch:(id)sender
{
    
}

@end
