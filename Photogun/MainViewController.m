//
//  MainViewController.m
//  Photogun
//
//  Created by Vitaly Kolesnikov on 4/9/14.
//  Copyright (c) 2014 Vitaly Kolesnikov. All rights reserved.
//

#import "MainViewController.h"

#define SQUARE_SIZE 80
#define SHADER_LOGS 1

static NSString * const VERTEX_SHADER_NAME = @"Default";
static NSString * const FRAGMENT_SHADE_NAME = @"Default";

static NSString * const SHADER_TYPE_FRAGMENT = @"fsh";
static NSString * const SHADER_TYPE_VERTEX = @"vsh";

typedef struct
{
    GLKVector3 posCoord;
    GLKVector2 texCoord;
    GLKVector4 colors;
    
} VertexData;

VertexData vertices[] = {
    
    {{0.0f, 0.0f, 0.0f}, {1,1}, {0, 1, 1, 1}},
    {{SQUARE_SIZE, 0.0f, 0.0f}, {0,1}, {0, 1, 1, 1}},
    {{0.0f, SQUARE_SIZE, 0.0f}, {1,0}, {0, 1, 1, 1}},
    {{SQUARE_SIZE, SQUARE_SIZE, 0.0f}, {0,0}, {0, 1, 1, 1}}
    
};

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
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.imageGLView.delegate = self;
    self.imageGLView.context = self.context;
    self.firstImageLoad = YES;
    
    [EAGLContext setCurrentContext:self.context];
    
    [self prepareScene];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareScene
{
    
    self.baseEffect.transform.projectionMatrix = GLKMatrix4MakeOrtho(0, self.imageGLView.frame.size.width, 0, self.imageGLView.frame.size.height, -10, 10);
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    
    glGenBuffers(1, &_vertexBufferID);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(VertexData), (GLvoid *) offsetof(VertexData, posCoord));
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(VertexData), (GLvoid *) offsetof(VertexData, texCoord));
}

- (void)loadImageWithName:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    CGImageRef imageReference = [image CGImage];

    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:imageReference
                                                               options:nil
                                                                 error:NULL];
    
    self.firstImageLoad = NO;
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
    
    [self reloadVerticesForImage:image];
    [self.imageGLView display];
}

- (void)reloadVerticesForImage:(UIImage *)image
{
    float glViewWidth = self.imageGLView.frame.size.width;
    float glViewHeight = self.imageGLView.frame.size.height;

    //Calculate size different between image and glView
    float sizeDiff = (image.size.width > image.size.height) ? glViewWidth / image.size.width : glViewHeight / image.size.height;
    
    //scaling image size, considering sizeDiff
    float imageWidth = (sizeDiff < 1) ? image.size.width * sizeDiff : image.size.width;
    float imageHeight = (sizeDiff < 1) ? image.size.height * sizeDiff : image.size.height;
  
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

#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    [self.baseEffect prepareToDraw];
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

#pragma mark - Shader methods

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

#pragma mark - UIComponents actions

- (IBAction)but1:(id)sender {
    
    [self loadImageWithName:@"test_image.jpg"];
}


- (IBAction)but2:(id)sender {
    [self loadImageWithName:@"test_image2.jpg"];
}

@end
