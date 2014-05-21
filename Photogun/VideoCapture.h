//
//  VideoCapture.h
//  Photogun
//
//  Created by Vitaly Kolesnikov on 4/22/14.
//  Copyright (c) 2014 Vitaly Kolesnikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol VideoCaptureDelegate;
@protocol ImageCaptureDelegate;

@interface VideoCapture : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, readonly) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, assign) id<VideoCaptureDelegate> delegate;
@property (nonatomic, assign) id<ImageCaptureDelegate> imageDelegate;

- (void)startCapture;
- (void)stopCapture;
- (void)setDeviceFocus:(CGPoint)focus;
- (void)captureImage;

@end

@protocol ImageCaptureDelegate

- (void)imageCaptured:(UIImage *)capturedImage;

@end

@protocol VideoCaptureDelegate

@property (nonatomic, assign) BOOL isFrameFreeze;

- (void)processNewCameraFrame:(CVImageBufferRef)cameraFrame;

@end
