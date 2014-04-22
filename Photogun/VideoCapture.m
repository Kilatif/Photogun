//
//  VideoCapture.m
//  Photogun
//
//  Created by Vitaly Kolesnikov on 4/22/14.
//  Copyright (c) 2014 Vitaly Kolesnikov. All rights reserved.
//

#import "VideoCapture.h"

#define VIDEO_CAPTURE_LOGS 1

@interface VideoCapture()

@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoOutput;

@end

@implementation VideoCapture

@synthesize captureSession;
@synthesize videoInput;
@synthesize videoOutput;
@synthesize videoPreviewLayer;
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self)
    {
        //get back-facing device
        AVCaptureDevice *backFacingCamera = nil;
        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *device in devices)
        {
            if (device.position == AVCaptureDevicePositionBack)
            {
                backFacingCamera = device;
                break;
            }
        }
        
        self.captureSession = [[AVCaptureSession alloc] init];
        self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:backFacingCamera error:nil];
        
        if ([self.captureSession canAddInput:self.videoInput])
            [self.captureSession addInput:self.videoInput];
        else
            if (VIDEO_CAPTURE_LOGS)  NSLog(@">>VIDEO CAPTURE: Can't add video input<<");
        
        [self videoPreviewLayer];
        
        self.videoOutput = [[AVCaptureVideoDataOutput alloc] init];
        [self.videoOutput setAlwaysDiscardsLateVideoFrames:YES];
        [self.videoOutput setVideoSettings:@{((id)kCVPixelBufferPixelFormatTypeKey) : @(kCVPixelFormatType_32BGRA)}];
        [self.videoOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
        
        if ([self.captureSession canAddOutput:self.videoOutput])
            [self.captureSession addOutput:self.videoOutput];
        else
            if (VIDEO_CAPTURE_LOGS)  NSLog(@">>VIDEO CAPTURE: Can't add video output<<");
        
        
        [self.captureSession setSessionPreset:AVCaptureSessionPreset640x480];
    }
    
    return self;
}

- (AVCaptureVideoPreviewLayer *)videoPreviewLayer
{
    if (videoPreviewLayer == nil)
    {
        videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
        [videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    }
    
    return videoPreviewLayer;
}

- (void)startCapture
{
    if (![self.captureSession isRunning] && self.delegate)
        [self.captureSession startRunning];
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    [self.delegate processNewCameraFrame:pixelBuffer];
}

@end
