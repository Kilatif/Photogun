//
//  MainViewController.m
//  Photogun
//
//  Created by Vitaly Kolesnikov on 4/9/14.
//  Copyright (c) 2014 Vitaly Kolesnikov. All rights reserved.
//

#import "MainViewController.h"

enum
{
    FilterBrightnessContrast = 0,
    FilterExposureGamma,
    FilterBalanceShadow,
    FilterBalanceMidtones,
    FilterBalanceLights,
    FilterBlur,
    FilterVignette
};

static CGFloat const activeFilterViewHeight = 210;

static  NSString * const valueBrightness = @"valueBrightness";
static  NSString * const valueContrast = @"valueContrast";
static  NSString * const valueSaturation = @"valueSaturation";

static  NSString * const valueRed = @"valueRed";
static  NSString * const valueGreen = @"valueGreen";
static  NSString * const valueBlue = @"valueBlue";

static  NSString * const valueExposure = @"valueExposure";
static  NSString * const valueGamma = @"valueGamma";

static  NSString * const valueBlur = @"valueBlur";

static  NSString * const valueOuterRadius = @"valueOuterRadius";
static  NSString * const valueInterRadius = @"valueInterRadius";
static  NSString * const valueIntensity = @"valueIntensity";


@interface MainViewController ()

@property (nonatomic, strong) ContextOptionsView *shadowsConetxtView;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeActionSheet];
    
    self.imageHisto.alpha = 0.7f;
    self.imageView.delegate = self;
    
    self.videoCapture = [[VideoCapture alloc] init];
    self.videoCapture.delegate = self.imageView;
    self.videoCapture.imageDelegate = self;

    [self.videoCapture startCapture];
}

- (void)initializeActionSheet
{
    self.filtersSelectSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"title.filters", nil)
                                                          delegate:self
                                                 cancelButtonTitle:NSLocalizedString(@"title.cancel", nil)
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:NSLocalizedString(@"title.brightContrast", nil),
                                                                   NSLocalizedString(@"title.expoisGamma", nil),
                                                                   NSLocalizedString(@"title.balanceShadows", nil),
                                                                   NSLocalizedString(@"title.balanceMidtones", nil),
                                                                   NSLocalizedString(@"title.balanceLights", nil),
                                                                   NSLocalizedString(@"title.blur", nil),
                                                                   NSLocalizedString(@"title.vignette", nil),
                                                                   nil];
    
    self.filtersSelectSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
}

#pragma mark - Filters options components

- (NSArray *)componentsForBrightContrastFilter
{
    NSDictionary *brightness = @{[ContextOptionsView COMPONENT_NAME] : valueBrightness,
                                 [ContextOptionsView LEFT_DESCRIPTION_VALUE] : NSLocalizedString(@"option.brightness", nil),
                                 [ContextOptionsView RIGHT_DESCRIPTION_VALUE] : @"",
                                 [ContextOptionsView SLIDER_CURRENT_VALUE] : @([self.imageView getFilterValueWithType:0])};
    
    NSDictionary *contrast = @{[ContextOptionsView COMPONENT_NAME] : valueContrast,
                               [ContextOptionsView LEFT_DESCRIPTION_VALUE] : NSLocalizedString(@"option.contrast", nil),
                               [ContextOptionsView RIGHT_DESCRIPTION_VALUE] : @"",
                               [ContextOptionsView SLIDER_CURRENT_VALUE] : @([self.imageView getFilterValueWithType:1])};
    
    NSDictionary *saturation = @{[ContextOptionsView COMPONENT_NAME] : valueSaturation,
                                 [ContextOptionsView LEFT_DESCRIPTION_VALUE] : NSLocalizedString(@"option.saturation", nil),
                                 [ContextOptionsView RIGHT_DESCRIPTION_VALUE] : @"",
                                 [ContextOptionsView SLIDER_CURRENT_VALUE] : @([self.imageView getFilterValueWithType:2])};
    
    return @[brightness, contrast, saturation];
}

- (NSArray *)componentsForExposureGammaFilter
{
    NSDictionary *exposure = @{[ContextOptionsView COMPONENT_NAME] : valueExposure,
                               [ContextOptionsView LEFT_DESCRIPTION_VALUE] : NSLocalizedString(@"option.exposure", nil),
                               [ContextOptionsView RIGHT_DESCRIPTION_VALUE] : @"",
                               [ContextOptionsView SLIDER_CURRENT_VALUE] : @([self.imageView getFilterValueWithType:3])};
    
    NSDictionary *gamma = @{[ContextOptionsView COMPONENT_NAME] : valueGamma,
                            [ContextOptionsView LEFT_DESCRIPTION_VALUE] : NSLocalizedString(@"option.gammaCorrect", nil),
                            [ContextOptionsView RIGHT_DESCRIPTION_VALUE] : @"",
                            [ContextOptionsView SLIDER_CURRENT_VALUE] : @([self.imageView getFilterValueWithType:4])};
    
    return @[exposure, gamma];
}

- (NSArray *)componentsForBalanceFilters:(int)valueOffset
{
    NSDictionary *redValue = @{[ContextOptionsView COMPONENT_NAME] : valueRed,
                               [ContextOptionsView LEFT_DESCRIPTION_VALUE] : NSLocalizedString(@"option.azure", nil),
                               [ContextOptionsView RIGHT_DESCRIPTION_VALUE] : NSLocalizedString(@"option.red", nil),
                               [ContextOptionsView SLIDER_MIN_COLOR] : [UIColor colorWithRed:0.78f green:0.0f blue:0.0f alpha:1.0f],
                               [ContextOptionsView SLIDER_MAX_COLOR] : [UIColor colorWithRed:0.0f green:0.78f blue:0.78f alpha:1.0f],
                               [ContextOptionsView SLIDER_CURRENT_VALUE] : @([self.imageView getFilterValueWithType:valueOffset + 0])};
    
    NSDictionary *greenValue = @{[ContextOptionsView COMPONENT_NAME] : valueGreen,
                                 [ContextOptionsView LEFT_DESCRIPTION_VALUE] : NSLocalizedString(@"option.purple", nil),
                                 [ContextOptionsView RIGHT_DESCRIPTION_VALUE] : NSLocalizedString(@"option.green", nil),
                                 [ContextOptionsView SLIDER_MIN_COLOR] : [UIColor colorWithRed:0.0f green:0.78f blue:0.0f alpha:1.0f],
                                 [ContextOptionsView SLIDER_MAX_COLOR] : [UIColor colorWithRed:0.78f green:0.0f blue:0.78f alpha:1.0f],
                                 [ContextOptionsView SLIDER_CURRENT_VALUE] : @([self.imageView getFilterValueWithType:valueOffset + 1])};
    
    NSDictionary *blueValue = @{[ContextOptionsView COMPONENT_NAME] : valueBlue,
                                [ContextOptionsView LEFT_DESCRIPTION_VALUE] : NSLocalizedString(@"option.yellow", nil),
                                [ContextOptionsView RIGHT_DESCRIPTION_VALUE] : NSLocalizedString(@"option.blue", nil),
                                [ContextOptionsView SLIDER_MIN_COLOR] : [UIColor colorWithRed:0.0f green:0.32f blue:1.0f alpha:1.0f],
                                [ContextOptionsView SLIDER_MAX_COLOR] : [UIColor colorWithRed:0.86f green:0.86f blue:0.0f alpha:1.0f],
                                [ContextOptionsView SLIDER_CURRENT_VALUE] : @([self.imageView getFilterValueWithType:valueOffset + 2])};
    
    return @[redValue, greenValue, blueValue];
}

- (NSArray *)componentsForBlurFilter
{
    NSDictionary *blur = @{[ContextOptionsView COMPONENT_NAME] : valueBlur,
                           [ContextOptionsView LEFT_DESCRIPTION_VALUE] : NSLocalizedString(@"option.blur", nil),
                           [ContextOptionsView RIGHT_DESCRIPTION_VALUE] : @"",
                           [ContextOptionsView SLIDER_CURRENT_VALUE] : @([self.imageView getFilterValueWithType:14])};
    
    return @[blur];
}

- (NSArray *)componentsForVignetteFilter
{
    NSDictionary *outerRadius = @{[ContextOptionsView COMPONENT_NAME] : valueOuterRadius,
                                  [ContextOptionsView LEFT_DESCRIPTION_VALUE] : NSLocalizedString(@"option.outerRarius", nil),
                                  [ContextOptionsView RIGHT_DESCRIPTION_VALUE] : @"",
                                  [ContextOptionsView SLIDER_CURRENT_VALUE] : @([self.imageView getFilterValueWithType:15])};
    
    NSDictionary *interRadius = @{[ContextOptionsView COMPONENT_NAME] : valueInterRadius,
                                  [ContextOptionsView LEFT_DESCRIPTION_VALUE] : NSLocalizedString(@"option.interRarius", nil),
                                  [ContextOptionsView RIGHT_DESCRIPTION_VALUE] : @"",
                                  [ContextOptionsView SLIDER_CURRENT_VALUE] : @([self.imageView getFilterValueWithType:16])};
    
    NSDictionary *intensity = @{[ContextOptionsView COMPONENT_NAME] : valueIntensity,
                                [ContextOptionsView LEFT_DESCRIPTION_VALUE] : NSLocalizedString(@"option.intensity", nil),
                                [ContextOptionsView RIGHT_DESCRIPTION_VALUE] : @"",
                                [ContextOptionsView SLIDER_CURRENT_VALUE] : @([self.imageView getFilterValueWithType:17])};
    
    return @[outerRadius, interRadius, intensity];
}

#pragma mark - Delegates methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.activeFilterViewType = buttonIndex;
    NSArray *optionsFilterComponents = nil;
    
    switch (buttonIndex) {
        case FilterBrightnessContrast: optionsFilterComponents = [self componentsForBrightContrastFilter]; break;
        case FilterExposureGamma: optionsFilterComponents = [self componentsForExposureGammaFilter]; break;
        case FilterBalanceShadow: optionsFilterComponents = [self componentsForBalanceFilters:5]; break;
        case FilterBalanceMidtones: optionsFilterComponents = [self componentsForBalanceFilters:8]; break;
        case FilterBalanceLights: optionsFilterComponents = [self componentsForBalanceFilters:11]; break;
        case FilterBlur: optionsFilterComponents = [self componentsForBlurFilter]; break;
        case FilterVignette: optionsFilterComponents = [self componentsForVignetteFilter]; break;
            
        default:
            break;
    }
    
    if (optionsFilterComponents)
    {
        if (self.activeFilterView)
            [self.activeFilterView removeFromSuperview];
        
        self.activeFilterView = [[ContextOptionsView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - activeFilterViewHeight,
                                                                                     self.view.frame.size.width, activeFilterViewHeight)
                                                            andComponents:optionsFilterComponents];

        self.activeFilterView.delegate = self;
        [self.view addSubview:self.activeFilterView];
        [self.activeFilterView show:NO animated:NO];
        [self.activeFilterView show:YES animated:YES];
    }
}

- (void)touchedView:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    
    location.x /= self.imageView.frame.size.width;
    location.y /= self.imageView.frame.size.height;
    
    [self.videoCapture setDeviceFocus:location];
}

- (void)sliderValueChanged:(NSString *)sliderName
{
    UISlider *slider = [self.activeFilterView getSliderWithName:sliderName];
    
    if ([sliderName isEqualToString:valueBrightness])
        [self.imageView setFilterValue:slider.value withType:0];
    
    if ([sliderName isEqualToString:valueContrast])
        [self.imageView setFilterValue:slider.value withType:1];
    
    if ([sliderName isEqualToString:valueSaturation])
        [self.imageView setFilterValue:slider.value withType:2];
    
    if ([sliderName isEqualToString:valueExposure])
        [self.imageView setFilterValue:slider.value withType:3];
    
    if ([sliderName isEqualToString:valueGamma])
        [self.imageView setFilterValue:slider.value withType:4];
    
    if ((self.activeFilterViewType == FilterBalanceShadow) && [sliderName isEqualToString:valueRed])
        [self.imageView setFilterValue:slider.value withType:5];
    
    if ((self.activeFilterViewType == FilterBalanceShadow) && [sliderName isEqualToString:valueGreen])
        [self.imageView setFilterValue:slider.value withType:6];
    
    if ((self.activeFilterViewType == FilterBalanceShadow) && [sliderName isEqualToString:valueBlue])
        [self.imageView setFilterValue:slider.value withType:7];
    
    if ((self.activeFilterViewType == FilterBalanceMidtones) && [sliderName isEqualToString:valueRed])
        [self.imageView setFilterValue:slider.value withType:8];
    
    if ((self.activeFilterViewType == FilterBalanceMidtones) && [sliderName isEqualToString:valueGreen])
        [self.imageView setFilterValue:slider.value withType:9];
    
    if ((self.activeFilterViewType == FilterBalanceMidtones) && [sliderName isEqualToString:valueBlue])
        [self.imageView setFilterValue:slider.value withType:10];
    
    if ((self.activeFilterViewType == FilterBalanceLights) && [sliderName isEqualToString:valueRed])
        [self.imageView setFilterValue:slider.value withType:11];
    
    if ((self.activeFilterViewType == FilterBalanceLights) && [sliderName isEqualToString:valueGreen])
        [self.imageView setFilterValue:slider.value withType:12];
    
    if ((self.activeFilterViewType == FilterBalanceLights) && [sliderName isEqualToString:valueBlue])
        [self.imageView setFilterValue:slider.value withType:13];
    
    if ([sliderName isEqualToString:valueBlur])
        [self.imageView setFilterValue:slider.value withType:14];
    
    if ([sliderName isEqualToString:valueOuterRadius])
        [self.imageView setFilterValue:slider.value withType:15];
    
    if ([sliderName isEqualToString:valueInterRadius])
        [self.imageView setFilterValue:slider.value withType:16];
    
    if ([sliderName isEqualToString:valueIntensity])
        [self.imageView setFilterValue:slider.value withType:17];
}

- (void)imageCaptured:(UIImage *)capturedImage
{
    [self.videoCapture stopCapture];
    [self.imageView loadImageWithImage:capturedImage];
}

#pragma mark - UIComponents actions

- (IBAction)filtersSelectAction:(UIButton *)sender
{
    [self.filtersSelectSheet showInView:self.view];
}

- (IBAction)takePhotoSave:(UIButton *)sender
{
    [self.videoCapture captureImage];
}

@end

