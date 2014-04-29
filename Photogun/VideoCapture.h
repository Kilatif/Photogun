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

@interface VideoCapture : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, readonly) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, assign) id<VideoCaptureDelegate> delegate;

- (void)startCapture;
- (void)stopCapture;

@end

@protocol VideoCaptureDelegate

@property (nonatomic, assign) BOOL isFrameFreeze;

- (void)processNewCameraFrame:(CVImageBufferRef)cameraFrame;

@end
