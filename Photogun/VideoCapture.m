//
//  VideoCapture.m
//  Photogun
//
//  Created by Vitaly Kolesnikov on 4/22/14.
//  Copyright (c) 2014 Vitaly Kolesnikov. All rights reserved.
//

#import "VideoCapture.h"
#import <ImageIO/CGImageProperties.h>


#define VIDEO_CAPTURE_LOGS 1

@interface VideoCapture()

@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoOutput;
@property (nonatomic, strong) AVCaptureDevice *videoDevice;

@property (nonatomic, strong) AVCaptureStillImageOutput *imageOutput;
@property (nonatomic, assign) BOOL isImageCapturing;

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
        
        self.videoDevice = backFacingCamera;
        self.captureSession = [[AVCaptureSession alloc] init];
        self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:backFacingCamera error:nil];
        
        if ([self.captureSession canAddInput:self.videoInput])
            [self.captureSession addInput:self.videoInput];
        else
            if (VIDEO_CAPTURE_LOGS)  NSLog(@">>VIDEO CAPTURE: Can't add video input<<");
        
        [self videoPreviewLayer];
        
        self.imageOutput = [[AVCaptureStillImageOutput alloc] init];
        [self.imageOutput setOutputSettings:@{AVVideoCodecKey : AVVideoCodecJPEG}];
        
        if ([self.captureSession canAddOutput:self.imageOutput])
            [self.captureSession addOutput:self.imageOutput];
        else
            if (VIDEO_CAPTURE_LOGS)  NSLog(@">>VIDEO CAPTURE: Can't add image output<<");
        
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
    {
        [self.captureSession startRunning];
        self.delegate.isFrameFreeze = NO;
    };
}

- (void)stopCapture
{
    if ([self.captureSession isRunning])
    {
        [self.captureSession stopRunning];
        self.delegate.isFrameFreeze = YES;
    }
}

- (void)setDeviceFocus:(CGPoint)focus
{
    if ([self.videoDevice lockForConfiguration:nil])
    {
        if (self.videoDevice.focusPointOfInterestSupported)
        {
            self.videoDevice.focusPointOfInterest = focus;
            [self.videoDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        }
        else
            NSLog(@"VIDEO_CAPTURE ERROR: Focus point is not supported for this device");
        
        if (self.videoDevice.exposurePointOfInterestSupported)
        {
            self.videoDevice.exposurePointOfInterest = focus;
            [self.videoDevice setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
        }
        else
            NSLog(@"VIDEO_CAPTURE ERROR: Exposure point is not supported for this device");
    }
    else
        NSLog(@"VIDEO_CAPTURE ERROR: Cannot lock device for configuration");
    
    [self.videoDevice unlockForConfiguration];
}

- (void)captureImage
{
    self.isImageCapturing = YES;
    
    [self.captureSession beginConfiguration];
    [self.captureSession setSessionPreset:AVCaptureSessionPresetPhoto];
    [self.captureSession commitConfiguration];
    
    //perform selector after delay need
    //When we are capturing an image, we are changing resolution
    //And when  resolution was changed, focus and exposure takes time to change in custom state
    [self performSelector:@selector(capturing) withObject:nil afterDelay:1.0];
}

- (void)capturing
{
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.imageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    __unsafe_unretained VideoCapture *bself = self;
    [self.imageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:
     ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
         
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *image = [[UIImage alloc] initWithData:imageData];
         if (self.imageDelegate)
             [self.imageDelegate imageCaptured:image];
         
         [bself.captureSession beginConfiguration];
         [bself.captureSession setSessionPreset:AVCaptureSessionPreset640x480];
         [bself.captureSession commitConfiguration];
         
         self.isImageCapturing = NO;
     }];
}


#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    if (!self.isImageCapturing)
    {
        CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        [self.delegate processNewCameraFrame:pixelBuffer];
    }
}

@end
