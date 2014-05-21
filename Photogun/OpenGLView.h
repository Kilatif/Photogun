//
//  OpenGLView.h
//  HelloOpenGL
//
//  Created by Ray Wenderlich on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoCapture.h"

typedef enum : NSUInteger {
    HistogramRedChannel,
    HistogramGreenChannel,
    HistogramBlueChannel,
} HistogramType;

@protocol OpenGLViewDelegate;

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
@property (nonatomic, assign) id<OpenGLViewDelegate> delegate;

- (void)loadImageWithName:(NSString *)name;
- (void)loadImageWithImage:(UIImage *)image;

- (NSData *)getGLFramePixelData;
- (UIImage *)getGLFrameImage;
- (NSArray *)histogramFromGLViewWithType:(HistogramType)histogramType;

- (void)setFilterValue:(float)value withType:(int)type;

@end

@protocol OpenGLViewDelegate <NSObject>

- (void)touchedView:(NSSet *)touches withEvent:(UIEvent *)event;

@end
