//
//  MainViewController.h
//  Photogun
//
//  Created by Vitaly Kolesnikov on 4/9/14.
//  Copyright (c) 2014 Vitaly Kolesnikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenGLView.h"
#import "VideoCapture.h"
#import "HistogramImageView.h"

@interface MainViewController : UIViewController <OpenGLViewDelegate, ImageCaptureDelegate>

@property (strong, nonatomic) IBOutlet OpenGLView *imageView;
@property (strong, nonatomic) IBOutlet UISlider *colorSlider;
@property (strong, nonatomic) IBOutlet HistogramImageView *imageTest;
@property (strong, nonatomic) IBOutlet UITextField *filterType;

@end
