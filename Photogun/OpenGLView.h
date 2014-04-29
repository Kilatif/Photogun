//
//  OpenGLView.h
//  HelloOpenGL
//
//  Created by Ray Wenderlich on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoCapture.h"

@interface OpenGLView : UIView <VideoCaptureDelegate> {
    
    GLuint _renderBufferID;
    GLuint _frameBufferID;
    GLuint _vertexBufferID;
    
    GLuint _shaderProgramID;
    GLuint _textureID;
    
    GLuint _videoFrameTexture;

}

@property (nonatomic, assign) CAEAGLLayer *eaglLayer;
@property (nonatomic, strong) EAGLContext *context;

- (void)loadImageWithName:(NSString *)name;
- (void)loadImageWithImage:(UIImage *)image;

- (void)setRedValue:(float)value;
- (UIImage *)getGLFrameImage;

@end
