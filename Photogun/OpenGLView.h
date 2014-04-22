//
//  OpenGLView.h
//  HelloOpenGL
//
//  Created by Ray Wenderlich on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OpenGLView : UIView {
    
    GLuint _renderBufferID;
    GLuint _frameBufferID;
    GLuint _vertexBufferID;
    
    GLuint _shaderProgramID;
    GLuint _textureID;

}

@property (nonatomic, assign) CAEAGLLayer *eaglLayer;
@property (nonatomic, strong) EAGLContext *context;

- (void)loadImageWithName:(NSString *)name;
- (void)loadImageWithBuffer:(CVImageBufferRef)buffer;

@end
