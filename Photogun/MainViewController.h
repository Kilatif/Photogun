//
//  MainViewController.h
//  Photogun
//
//  Created by Vitaly Kolesnikov on 4/9/14.
//  Copyright (c) 2014 Vitaly Kolesnikov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <GLKViewDelegate>
{
    GLuint _vertexBufferID;
}

@property (strong, nonatomic) IBOutlet GLKView *imageGLView;

@end
