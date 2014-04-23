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

@interface MainViewController : UIViewController

@property (strong, nonatomic) IBOutlet OpenGLView *imageView;
@property (strong, nonatomic) IBOutlet UISlider *colorSlider;

@end
