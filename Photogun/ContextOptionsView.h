//
//  ContextOptionsView.h
//  Photogun
//
//  Created by test on 5/23/14.
//  Copyright (c) 2014 Vitaly Kolesnikov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContextOptionsView : UIView

- (id)initWithFrame:(CGRect)frame andComponents:(NSArray *)componentsInfo;

+ (NSString *)COMPONENT_NAME;

+ (NSString *)RIGHT_DESCRIPTION_VALUE;
+ (NSString *)LEFT_DESCRIPTION_VALUE;

+ (NSString *)SLIDER_MIN_COLOR;
+ (NSString *)SLIDER_MAX_COLOR;

+ (NSString *)SLIDER_MIN_VALUE;
+ (NSString *)SLIDER_MAX_VALUE;

+ (NSString *)SLIDER_CURRENT_VALUE;

@end
