//
//  ContextOptionsView.m
//  Photogun
//
//  Created by test on 5/23/14.
//  Copyright (c) 2014 Vitaly Kolesnikov. All rights reserved.
//

#import "ContextOptionsView.h"

//one component - it's a one slider + left + right descriptions

static int const defaultTopDescriptionViewHeight = 35;
static int const componentHeight = 52;
static int const sideOffset = 20;
static int const descriptionHeight = 21;

static NSString * const defaultTopDescription = @"Top Description";
static NSString * const defaultLeftDescription = @"Left/Min";
static NSString * const defaultRightDescription = @"Right/Max";


@interface ContextOptionsView()

@property (nonatomic, strong) NSDictionary *sliders;
@property (nonatomic, strong) NSDictionary *rightDescriptions;
@property (nonatomic, strong) NSDictionary *leftDescriptions;

@property (nonatomic, strong) UIView *topDescriptionView;
@property (nonatomic, strong) UILabel *topDescription;

@property (nonatomic, assign) CGRect originFrame;

@end

@implementation ContextOptionsView

#pragma mark - Initialize methods

- (id)initWithFrame:(CGRect)frame andComponents:(NSArray *)componentsInfo 
{
    self = [self initWithFrame:frame];
    if (self)
    {
        int workViewHeight = self.frame.size.height - defaultTopDescriptionViewHeight;
        int midleComponentHeight = ceil(workViewHeight / 2.0);

        midleComponentHeight -= (componentsInfo.count % 2 == 0) ? componentHeight : componentHeight / 2;
        
        int i = 0;
        int startHeight = midleComponentHeight - floor(componentsInfo.count / 2.0) * componentHeight + defaultTopDescriptionViewHeight;
        for (NSDictionary *curComponent in componentsInfo)
        {
            //taking component info
            NSObject *leftDescriptionValue = [curComponent objectForKey:[ContextOptionsView LEFT_DESCRIPTION_VALUE]];
            NSObject *rightDescriptionValue = [curComponent objectForKey:[ContextOptionsView RIGHT_DESCRIPTION_VALUE]];
            
            NSObject *sliderMinColor = [curComponent objectForKey:[ContextOptionsView SLIDER_MIN_COLOR]];
            NSObject *sliderMaxColor = [curComponent objectForKey:[ContextOptionsView SLIDER_MAX_COLOR]];
            
            NSObject *sliderMinValue = [curComponent objectForKey:[ContextOptionsView SLIDER_MIN_VALUE]];
            NSObject *sliderMaxValue = [curComponent objectForKey:[ContextOptionsView SLIDER_MAX_VALUE]];
            NSObject *sliderCurValue = [curComponent objectForKey:[ContextOptionsView SLIDER_CURRENT_VALUE]];
            
            //creating position and size for component
            CGRect leftDescriptionFrame = CGRectMake(sideOffset, startHeight + i * componentHeight,
                                                      self.frame.size.width / 2 - sideOffset, descriptionHeight);
            
            CGRect rightDescriptionFrame = CGRectMake(self.frame.size.width / 2, startHeight + i * componentHeight,
                                                      self.frame.size.width / 2 - sideOffset, descriptionHeight);
            
            CGRect sliderFrame = CGRectMake(sideOffset - 2, startHeight + i * componentHeight + descriptionHeight,
                                            self.frame.size.width - sideOffset * 2 + 4, 31);
            
            NSString *componentName = [curComponent objectForKey:[ContextOptionsView COMPONENT_NAME]];
            
            //creating component objects
            UILabel *leftDescription = [[UILabel alloc] initWithFrame:leftDescriptionFrame];
            UILabel *rightDescription = [[UILabel alloc] initWithFrame:rightDescriptionFrame];
            UISlider *slider = [[UISlider alloc] initWithFrame:sliderFrame];
            
            //seting component objects properties
            [leftDescription setFont:[UIFont systemFontOfSize:14]];
            leftDescription.textColor = [UIColor whiteColor];
            leftDescription.textAlignment = NSTextAlignmentLeft;
            leftDescription.text = defaultLeftDescription;
            
            [rightDescription setFont:[UIFont systemFontOfSize:14]];
            rightDescription.textColor = [UIColor whiteColor];
            rightDescription.textAlignment = NSTextAlignmentRight;
            rightDescription.text = defaultRightDescription;
            
            slider.minimumTrackTintColor = [UIColor colorWithRed:0.14f green:0.14f blue:0.14f alpha:1.0f];
            slider.maximumTrackTintColor = [UIColor whiteColor];
            slider.minimumValue = 0.0f;
            slider.maximumValue = 2.0f;
            slider.value = 1.0f;
            
            if ([leftDescriptionValue isKindOfClass:[NSString class]])
                leftDescription.text = (NSString *)leftDescriptionValue;
            
            if ([rightDescriptionValue isKindOfClass:[NSString class]])
                rightDescription.text = (NSString *)rightDescriptionValue;
            
            if ([sliderMinColor isKindOfClass:[UIColor class]])
                slider.minimumTrackTintColor = (UIColor *)sliderMinColor;
            
            if ([sliderMaxColor isKindOfClass:[UIColor class]])
                slider.maximumTrackTintColor = (UIColor *)sliderMaxColor;
            
            if ([sliderMinValue isKindOfClass:[NSNumber class]])
                slider.minimumValue = ((NSNumber *)sliderMinValue).floatValue;
            
            if ([sliderMaxValue isKindOfClass:[NSNumber class]])
                slider.maximumValue = ((NSNumber *)sliderMaxValue).floatValue;
            
            if ([sliderCurValue isKindOfClass:[NSNumber class]])
                slider.value = ((NSNumber *)sliderCurValue).floatValue;
            
            [self addSubview:leftDescription];
            [self addSubview:rightDescription];
            [self addSubview:slider];
            
            [self.leftDescriptions setValue:leftDescription forKey:componentName];
            [self.rightDescriptions setValue:rightDescription forKey:componentName];
            [self.sliders setValue:slider forKey:componentName];
            
            i++;
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.originFrame = frame;
        self.hidden = NO;
        self.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:1.0f];
        self.alpha = 0.8f;
        
        [self initializeTopDescriptionView];
    }
    
    return self;
}

- (void)initializeTopDescriptionView
{
    self.topDescriptionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, defaultTopDescriptionViewHeight)];
    self.topDescriptionView.backgroundColor = [UIColor colorWithRed:0.25f green:0.25f blue:0.25f alpha:1.0f];
    
    self.topDescription = [[UILabel alloc] initWithFrame:self.topDescriptionView.bounds];
    self.topDescription.textColor = [UIColor lightGrayColor];
    self.topDescription.textAlignment = NSTextAlignmentCenter;
    self.topDescription.text = defaultTopDescription;
    [self.topDescription setFont:[UIFont systemFontOfSize:15]];
    
    [self.topDescriptionView addSubview:self.topDescription];
    [self addSubview:self.topDescriptionView];
}

#pragma mark - Constants for using in other classes

+ (NSString *)COMPONENT_NAME
{
    return @"componentName";
}

+ (NSString *)RIGHT_DESCRIPTION_VALUE
{
    return @"rightDescriptionValue";
}

+ (NSString *)LEFT_DESCRIPTION_VALUE
{
    return @"leftDescriptionValue";
}

+ (NSString *)SLIDER_MIN_COLOR
{
    return @"sliderMinColor";
}

+ (NSString *)SLIDER_MAX_COLOR
{
    return @"sliderMaxColor";
}

+ (NSString *)SLIDER_MIN_VALUE
{
    return @"sliderMinValue";
}

+ (NSString *)SLIDER_MAX_VALUE
{
    return @"sliderMaxValue";
}

+ (NSString *)SLIDER_CURRENT_VALUE
{
    return @"sliderCurrentValue";
}

@end
