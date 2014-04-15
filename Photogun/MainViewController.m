//
//  MainViewController.m
//  Photogun
//
//  Created by Vitaly Kolesnikov on 4/9/14.
//  Copyright (c) 2014 Vitaly Kolesnikov. All rights reserved.
//

#import "MainViewController.h"

typedef struct
{
    GLKVector3 posCoord;
    GLKVector2 texCoord;
    
} VertexData;

#define SQUARE_SIZE 80.0f

VertexData vertices[] = {
    
    {{0.0f, 0.0f, 0.0f}, {1,1}},
    {{0.0f, 0.0f, 0.0f}, {0,1}},
    {{0.0f, 0.0f, 0.0f}, {1,0}},
    {{0.0f, 0.0f, 0.0f}, {1,0}},
    {{0.0f, 0.0f, 0.0f}, {0,1}},
    {{0.0f, 0.0f, 0.0f}, {0,0}}
    
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
    
    vertices[1].posCoord.x = vertices[4].posCoord.x = startPoint.x + imageWidth;
    vertices[1].posCoord.y = vertices[4].posCoord.y = startPoint.y;
    
    vertices[2].posCoord.x = vertices[3].posCoord.x = startPoint.x;
    vertices[2].posCoord.y = vertices[3].posCoord.y = startPoint.y + imageHeight;
    
    vertices[5].posCoord.x = startPoint.x + imageWidth;
    vertices[5].posCoord.y = startPoint.y + imageHeight;
    
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
}

#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    [self.baseEffect prepareToDraw];
    
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

- (IBAction)but1:(id)sender {
    
    [self loadImageWithName:@"test_image.jpg"];
}


- (IBAction)but2:(id)sender {
    [self loadImageWithName:@"test_image2.jpg"];
}


@end
