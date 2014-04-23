//
//  OpenGLView.m
//  HelloOpenGL
//
//  Created by Ray Wenderlich on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OpenGLView.h"

#define SQUARE_SIZE 0
#define SHADER_LOGS 1

static NSString * const VERTEX_SHADER_NAME = @"Default";
static NSString * const FRAGMENT_SHADE_NAME = @"Default";

static NSString * const SHADER_TYPE_FRAGMENT = @"fsh";
static NSString * const SHADER_TYPE_VERTEX = @"vsh";

typedef struct
{
    GLKVector3 posCoord;
    GLKVector2 texCoord;
    GLKVector4 color;
    
} VertexData;

VertexData vertices[] = {
    
    {{0.0f, 0.0f, 0.0f}, {1,1}, {1, 1, 1, 1}},
    {{SQUARE_SIZE, 0.0f, 0.0f}, {1,0}, {1, 1, 1, 1}},
    {{0.0f, SQUARE_SIZE, 0.0f}, {0,1}, {1, 1, 1, 1}},
    {{SQUARE_SIZE, SQUARE_SIZE, 0.0f}, {0,0}, {1, 1, 1, 1}}
    
};

@implementation OpenGLView

@synthesize eaglLayer;
@synthesize context;


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.eaglLayer = (CAEAGLLayer*) self.layer;
        self.eaglLayer.opaque = YES;
        
        self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        [EAGLContext setCurrentContext:self.context];
        
        [self initializeScene];
        [self prepareScene];
    }
    
    return self;
}

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (void)initializeScene
{
    //Generate and bind render buffer
    glGenRenderbuffers(1, &_renderBufferID);
    glBindRenderbuffer(GL_RENDERBUFFER, _renderBufferID);
    
    [self.context renderbufferStorage:GL_RENDERBUFFER fromDrawable:self.eaglLayer];
    
    //Generate and bind frame buffer
    glGenFramebuffers(1, &_frameBufferID);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBufferID);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderBufferID);
}

- (void)prepareScene
{
    glGenBuffers(1, &_vertexBufferID);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    _shaderProgramID = [self createProgramWithVertexShader:@"Default" andFragmentShader:@"Default"];
    glUseProgram(_shaderProgramID);
}

- (void)render
{
    glClearColor(0, 0, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    GLKMatrix4 projection = GLKMatrix4MakeOrtho(0, self.frame.size.width, 0, self.frame.size.height, -10, 10);
    
    GLuint vertPosAttr = glGetAttribLocation(_shaderProgramID, "coord");
    GLuint vertColorAttr = glGetAttribLocation(_shaderProgramID, "color");
    GLuint vertProjection = glGetUniformLocation(_shaderProgramID, "projection");
    GLuint vertTextureCoord = glGetAttribLocation(_shaderProgramID, "tex_coord");
    
    glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, _textureID);

    glUniformMatrix4fv(vertProjection, 1, 0, projection.m);
    
    glEnableVertexAttribArray(vertPosAttr);
    glVertexAttribPointer(vertPosAttr, 3, GL_FLOAT, GL_FALSE, sizeof(VertexData), (GLvoid *) offsetof(VertexData, posCoord));
    
    glEnableVertexAttribArray(vertColorAttr);
    glVertexAttribPointer(vertColorAttr, 4, GL_FLOAT, GL_FALSE, sizeof(VertexData), (GLvoid *) offsetof(VertexData, color));
    
    glEnableVertexAttribArray(vertTextureCoord);
    glVertexAttribPointer(vertTextureCoord, 2, GL_FLOAT, GL_FALSE, sizeof(VertexData), (GLvoid *) offsetof(VertexData, texCoord));
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    glDisableVertexAttribArray(vertColorAttr);
    glDisableVertexAttribArray(vertPosAttr);
  
    glDisableVertexAttribArray(vertTextureCoord);
    
    glDeleteTextures(1, &_textureID);
    
    [self.context presentRenderbuffer:GL_RENDERBUFFER];
}

#pragma mark - Texture Methods

- (GLuint)setupTexture:(NSString *)fileName
{
    CGImageRef imageRef = [UIImage imageNamed:fileName].CGImage;
    return [self setupTextureWithImageRef:imageRef];
}

- (GLuint)setupTextureWithImageRef:(CGImageRef)imageRef
{
    NSError *error;
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:imageRef options:nil error:&error];
    
    glBindTexture(GL_TEXTURE_2D, textureInfo.name);
        
    return textureInfo.name;
}

- (GLuint)setupTextureWithBufferRef:(CVImageBufferRef)bufferRef
{
    CVPixelBufferLockBaseAddress(bufferRef, 0);
	int bufferHeight = CVPixelBufferGetHeight(bufferRef);
	int bufferWidth = CVPixelBufferGetWidth(bufferRef);
    
	// Create a new texture from the camera frame data, display that using the shaders
    
    GLuint resultTexture;
    
	glGenTextures(1, &resultTexture);
	glBindTexture(GL_TEXTURE_2D, resultTexture);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	// This is necessary for non-power-of-two textures
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	
	// Using BGRA extension to pull in video frame data directly
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, bufferWidth, bufferHeight, 0, GL_BGRA, GL_UNSIGNED_BYTE, CVPixelBufferGetBaseAddress(bufferRef));
    
	CVPixelBufferUnlockBaseAddress(bufferRef, 0);
    
    return resultTexture;
}

- (void)loadImageWithName:(NSString *)name
{
    __weak UIImage *image = [UIImage imageNamed:name];
   
    _textureID = [self setupTexture:name];
    
    [self reloadVerticesForImageSize:image.size];
    [self render];
}

- (void)reloadVerticesForImageSize:(CGSize)imageSize
{
    float glViewWidth = self.frame.size.width;
    float glViewHeight = self.frame.size.height;
    
    //Calculate size different between image and glView
    float sizeDiff = (imageSize.width > imageSize.height) ? glViewWidth / imageSize.width : glViewHeight / imageSize.height;
    
    //scaling image size, considering sizeDiff
    float imageWidth = (sizeDiff < 1) ? imageSize.width * sizeDiff : imageSize.width;
    float imageHeight = (sizeDiff < 1) ? imageSize.height * sizeDiff : imageSize.height;
    
    GLKVector2 startPoint = {glViewWidth / 2 - imageWidth / 2, glViewHeight / 2 - imageHeight / 2};
    
     vertices[0].posCoord.x = startPoint.x;
     vertices[0].posCoord.y = startPoint.y;
     
     vertices[1].posCoord.x = startPoint.x + imageWidth;
     vertices[1].posCoord.y = startPoint.y;
     
     vertices[2].posCoord.x = startPoint.x;
     vertices[2].posCoord.y = startPoint.y + imageHeight;
     
     vertices[3].posCoord.x = startPoint.x + imageWidth;
     vertices[3].posCoord.y = startPoint.y + imageHeight;
     
     glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
}

- (void)setRedValue:(float)value
{
    GLuint redValue = glGetUniformLocation(_shaderProgramID, "redValue");
    
    glUniform1f(redValue, value);
}

#pragma mark - Shaders methods

- (GLuint)createProgramWithVertexShader:(NSString *)vertexShaderName andFragmentShader:(NSString *)fragmentShaderName
{
    GLuint vertexShaderID, fragmentShaderID;
    GLuint shaderProgram = 0;
    
    vertexShaderID = [self createShader:@"Default" forType:GL_VERTEX_SHADER];
    fragmentShaderID = [self createShader:@"Default" forType:GL_FRAGMENT_SHADER];
    
    shaderProgram = glCreateProgram();
    
    glAttachShader(shaderProgram, vertexShaderID);
    glAttachShader(shaderProgram, fragmentShaderID);
    
    glLinkProgram(shaderProgram);
    if (![self isProgramLinked:shaderProgram])
    {
        return 0;
    }
    
    return shaderProgram;
}

- (GLuint)createShader:(NSString *)shaderName forType:(GLuint)shaderType
{
    GLuint result = 0;
    NSString *shaderFileType = (shaderType == GL_VERTEX_SHADER) ? SHADER_TYPE_VERTEX : SHADER_TYPE_FRAGMENT;
    NSString *shaderFileName = [[NSBundle mainBundle] pathForResource:@"Default" ofType:shaderFileType];
    
    const GLchar *shaderSource = (GLchar *)[[NSString stringWithContentsOfFile:shaderFileName encoding:NSUTF8StringEncoding error:nil] UTF8String];
    
    result = glCreateShader(shaderType);
    glShaderSource(result, 1, &shaderSource, nil);
    glCompileShader(result);
    
    if (![self isShaderCompiled:result])
    {
        if (SHADER_LOGS)
            NSLog(@"ERROR: Shader '%@.%@' don't created!", shaderName, shaderFileType);
        
        result = 0;
    }
    
    return result;
}

- (BOOL)isProgramLinked:(GLuint)progID
{
    BOOL result = YES;
    
    int infoLogLen = 0;
    int charsWritten = 0;
    char *infoLog;
    
    glGetProgramiv(progID, GL_INFO_LOG_LENGTH, &infoLogLen);
    if (infoLogLen > 1)
    {
        result = NO;
        
        infoLog = (char *)malloc(infoLogLen);
        if (!infoLog)
        {
            if (SHADER_LOGS)
                NSLog(@"ERROR : Can't create shader log buffer");
            
            return result;
        }
        
        glGetProgramInfoLog(progID, infoLogLen, &charsWritten, infoLog);
        if (SHADER_LOGS)
            NSLog(@"SHADER PROG LOG : %s", infoLog);
        
        free(infoLog);
    }
    
    return result;
}

- (BOOL)isShaderCompiled:(GLuint)shaderID
{
    BOOL result = YES;
    
    int infoLogLen = 0;
    int charsWritten = 0;
    char *infoLog;
    
    glGetShaderiv(shaderID, GL_INFO_LOG_LENGTH, &infoLogLen);
    if (infoLogLen > 1)
    {
        result = NO;
        
        infoLog = (char *)malloc(infoLogLen);
        if (!infoLog)
        {
            if (SHADER_LOGS)
                NSLog(@"ERROR : Can't create shader log buffer");
            
            return result;
        }
        
        glGetShaderInfoLog(shaderID, infoLogLen, &charsWritten, infoLog);
        if (SHADER_LOGS)
            NSLog(@"SHADER LOG : %s", infoLog);
        
        free(infoLog);
    }
    
    return result;
}

#pragma mark - VideoCaptureDelegate

- (void)processNewCameraFrame:(CVImageBufferRef)cameraFrame
{
    int bufferHeight = CVPixelBufferGetHeight(cameraFrame);
	int bufferWidth = CVPixelBufferGetWidth(cameraFrame);
	
    [self reloadVerticesForImageSize:CGSizeMake(bufferHeight, bufferWidth)];
    _textureID = [self setupTextureWithBufferRef:cameraFrame];
    
    [self render];
}

@end
