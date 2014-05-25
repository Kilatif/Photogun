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
#import "ContextOptionsView.h"

@interface MainViewController : UIViewController <OpenGLViewDelegate, ImageCaptureDelegate,
                                                  SliderValueChangedDelegate, UIActionSheetDelegate>


@property (strong, nonatomic) IBOutlet OpenGLView *imageView;
@property (strong, nonatomic) IBOutlet HistogramImageView *imageHisto;

@property (strong, nonatomic) ContextOptionsView *activeFilterView;
@property (nonatomic, strong) UIActionSheet *filtersSelectSheet;
@property (nonatomic, strong) VideoCapture *videoCapture;
@property (nonatomic, assign) HistogramType histogramType;
@property (nonatomic, assign) NSInteger activeFilterViewType;

@end
