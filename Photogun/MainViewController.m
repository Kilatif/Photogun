//
//  MainViewController.m
//  Photogun
//
//  Created by Vitaly Kolesnikov on 4/9/14.
//  Copyright (c) 2014 Vitaly Kolesnikov. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, strong) GLKBaseEffect *baseEffect;

@property (nonatomic, assign) BOOL firstImageLoad;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIComponents actions

- (IBAction)but1:(id)sender {
    
    [self.imageView loadImageWithName:@"test_image.jpg"];
    //[self loadImageWithName:@"test_image.jpg"];
}


- (IBAction)but2:(id)sender {
    [self.imageView loadImageWithName:@"test_image2.jpg"];
}

@end
