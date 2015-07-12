//
//  WTViewController.m
//  Watao
//
//  Created by 连 承亮 on 14-2-27.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import "WTPotteryViewController.h"
#import "WTAppDelegate.h"

@implementation WTPotteryViewController

- (void)viewDidLoad
{
    WTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    _pottery = appDelegate.pottery;
    _pad = appDelegate.pad;
    _background = appDelegate.background;
    _shadow = appDelegate.shadow;
    //load objects from the appDelegate
    _scale = GLKVector3Make(1.0f, 1.0f, 1.0f);//set the scale of the view
    _transition = GLKVector3Make(0.0f, -1.0f, -4.0f);
    _perspective = 65.0f;
    //set parameters
    
    [super viewDidLoad];
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    //initial the context with openGLES2.0
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    //set the context to this view
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    //set the depth buffer for the view
    self.preferredFramesPerSecond = 60;
    //set the FPS to 60
//    view.drawableMultisample = GLKViewDrawableMultisample4X;
    //Enable multisampling
    [self setupGL];
    //set up OpenGL
    [_background setupTexture:@"japanBackground.jpg"];
    [_pad setupTexture:@"table.png"];
    [_pottery setupTexture:@"t3.jpg"];
    [_shadow setupTexture:@"shadow.png"];
    //load texture must be done after context is being set
}

-(void)viewDidDisappear:(BOOL)animated{
    [self tearDownGL];
    _pottery = nil;
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)dealloc
{    
    [self tearDownGL];
    _pottery = nil;
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }

    // Dispose of any resources that can be recreated.
}

/**
 * initial the shader and pass the VAO data into it
 **/

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    //set context as the current context
    [self loadShaders];
    
    glEnable(GL_DEPTH_TEST);
    
    /////////////////////////////////
    [self setupGLfor:VERTEX_ARRAY_POTTERY :VERTEX_BUFFER_POTTERY :INDEX_BUFFER_POTTERY :_pottery];
    //setUp the state of the pottery    
    /////////////////////////////////
    //set up the vertex array objects
    [self setupGLfor:VERTEX_ARRAY_PAD :VERTEX_BUFFER_PAD :INDEX_BUFFER_PAD :_pad];
    //setUp the state of the pad
    /////////////////////////////////
    [self setupGLfor:VERTEX_ARRAY_BACKGROUND :VERTEX_BUFFER_BACKGROUND :INDEX_BUFFER_BACKGROUND :_background];
    //set up the background
    /////////////////////////////////
    [self setupGLfor:VERTEX_ARRAY_SHADOW :VERTEX_BUFFER_SHADOW :INDEX_BUFFER_SHADOW :_shadow];
    //set up the shadow

}


-(void)setupGLfor: (GLint)vertexArrayID
                 :(GLint)vertexBufferID
                 :(GLint)indexBufferID
                 :(WTMeshObject *)object{
    glGenVertexArraysOES(1, &vertexArraies[vertexArrayID]);
    glBindVertexArrayOES(vertexArraies[vertexArrayID]);
    
    //bind the vertex buffer objects to vertex array objects
    glGenBuffers(1, &vertexBuffers[vertexBufferID]);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffers[vertexBufferID]);
    //initial the data with the vertexbuffer and hint the data with static draw
    Vertex* vertexData = object.getVertices;
//    GLuint a = sizeof(Vertex);
    if (vertexArrayID == VERTEX_ARRAY_POTTERY) {
        glBufferData(GL_ARRAY_BUFFER, sizeof(Vertex)*object.getVertexCount, vertexData, GL_DYNAMIC_DRAW);
    }else{
        glBufferData(GL_ARRAY_BUFFER, sizeof(Vertex)*object.getVertexCount, vertexData, GL_STATIC_DRAW);

    }

    //called after set up shader and find the position of these variables
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 4, GL_FLOAT, GL_FALSE, WT_VERTEX_STRIDE, BUFFER_OFFSET(0));
    //hint the data is composed of 4 components with the type of GL_FLOAT, 4th parameter has no meaning
    //the 5th parameter is the stride, aka, the size of the vertex(4*4*2)
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, WT_VERTEX_STRIDE, BUFFER_OFFSET(16));
    //set the texture here
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, WT_VERTEX_STRIDE, BUFFER_OFFSET(32));
    glEnable(GL_TEXTURE_2D);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, [object textureID]);
    glUniform1i(uniforms[UNIFORM_TEXTURE], 0);
    
    //setup the index here
    glGenBuffers(1, &indexBuffers[indexBufferID]);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffers[indexBufferID]);
    GLushort *indexData = object.getIndices;
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, object.getIndexCount*sizeof(GLushort), indexData, GL_STATIC_DRAW);
    
    glBindVertexArrayOES(0);
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    
    glDeleteBuffers(1, &vertexBuffers[VERTEX_BUFFER_POTTERY]);
    glDeleteVertexArraysOES(1, &vertexArraies[VERTEX_BUFFER_POTTERY]);
    
    glDeleteBuffers(1, &vertexBuffers[VERTEX_BUFFER_PAD]);
    glDeleteVertexArraysOES(1, &vertexArraies[VERTEX_BUFFER_PAD]);
    
    glDeleteBuffers(1, &vertexBuffers[VERTEX_BUFFER_BACKGROUND]);
    glDeleteVertexArraysOES(1, &vertexArraies[VERTEX_BUFFER_BACKGROUND]);

    glDeleteBuffers(1, &vertexBuffers[VERTEX_BUFFER_SHADOW]);
    glDeleteVertexArraysOES(1, &vertexArraies[VERTEX_BUFFER_SHADOW]);
    
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
}

#pragma mark - GLKView and GLKViewController delegate methods
/**
 * called every time after the fromer frame has been displayed and prepared for the next buffer
 **/

- (void)update
{
    float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(_perspective), aspect, 0.1f, 100.0f);
    GLKMatrix4 baseModelViewMatrix = GLKMatrix4MakeTranslation(_transition.x, _transition.y, _transition.z);
    //GLKVector3 scale = GLKVector3Make(0.15f, 0.04f, 0.15f);
    GLKVector3 translate = GLKVector3Make(0.0f, 0.0f, 0.0f);
    [_pottery moveRotate: _rotation scale: _scale translate:translate base:baseModelViewMatrix project: projectionMatrix];
    //scale = GLKVector3Make(0.15f, 0.002f, 0.15f);
    translate = GLKVector3Make(0.0f, -1.0f*_scale.y*_pad.getHeight, 0.0f);
    [_pad moveRotate:_rotation scale:_scale translate:translate base:baseModelViewMatrix project:projectionMatrix];
    [_shadow moveRotate:GLKMathDegreesToRadians(170.0f) scale:_scale translate:translate base:baseModelViewMatrix project:projectionMatrix];
    baseModelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -30.0f);
    [_background moveRotate:GLKMathDegreesToRadians(0.0f) scale:GLKVector3Make(1.9f, 1.9f, 0.5f) translate:translate base:baseModelViewMatrix project:projectionMatrix];
    _rotation += self.timeSinceLastUpdate * 0.5f;

}

//dynamically setup and update the data of pottery

-(void) setupPottery{
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffers[VERTEX_BUFFER_POTTERY]);
    //initial the data with the vertexbuffer and hint the data with static draw
    Vertex* vertexData = _pottery.getVertices;
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertex)*_pottery.getVertexCount, vertexData, GL_DYNAMIC_DRAW);
    
    //called after set up shader and find the position of these variables
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 4, GL_FLOAT, GL_FALSE, WT_VERTEX_STRIDE, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, WT_VERTEX_STRIDE, BUFFER_OFFSET(16));
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, WT_VERTEX_STRIDE, BUFFER_OFFSET(32));
}

/**
 * a draw loop
 **/

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
//    glBlendFunc(GL_ONE, GL_ZERO);
//    glBlendFunc(GL_ONE, GL_SRC_COLOR);
    glClearColor(1.0f, 1.0f, 1.0f, 0.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
//    ////////////////////////////////////////
    glBindVertexArrayOES(vertexArraies[VERTEX_ARRAY_POTTERY]);
    // Render the object again with ES2
    glUseProgram(_program);
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _pottery.getModelProjectionViewMatrix.m);
    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, _pottery.getNormalMatrix.m);
    glBindTexture(GL_TEXTURE_2D, [_pottery textureID]);
    // pass 2 matrix to OPGLES to draw
//    glUniform1f(uniforms[UNIFORM_HEIGHT], _pottery.getHeight);
//    glUniform1fv(uniforms[UNIFORM_RADIUS], WT_NUM_LEVEL, _pottery.getRadius);
    [self setupPottery];
    //glDrawArrays(GL_POINTS, 0, _pottery.getVertexCount);
    glDrawElements(GL_TRIANGLES, _pottery.getIndexCount, GL_UNSIGNED_SHORT, 0);
    //draw pottery
    ////////////////////////////////////////
    glBindVertexArrayOES(vertexArraies[VERTEX_ARRAY_PAD]);
    glUseProgram(_program);
    glBindTexture(GL_TEXTURE_2D, [_pad textureID]);
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _pad.getModelProjectionViewMatrix.m);
    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, _pad.getNormalMatrix.m);
    //glDrawArrays(GL_POINTS, 0, _pad.getVertexCount);
    glDrawElements(GL_TRIANGLES, _pad.getIndexCount, GL_UNSIGNED_SHORT, 0);
    //draw pad
    /////////////////////////////////////////
    glBindVertexArrayOES(vertexArraies[VERTEX_ARRAY_BACKGROUND]);
    glUseProgram(_program);
    glBindTexture(GL_TEXTURE_2D, [_background textureID]);
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _background.getModelProjectionViewMatrix.m);
    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, _background.getNormalMatrix.m);
    //glDrawArrays(GL_POINTS, 0, _background.getVertexCount);
    glDrawElements(GL_TRIANGLE_STRIP, _background.getIndexCount, GL_UNSIGNED_SHORT, 0);
    //draw background
    ////////////////////////////////////////
    glBindVertexArrayOES(vertexArraies[VERTEX_ARRAY_SHADOW]);
    glUseProgram(_program);
    glBindTexture(GL_TEXTURE_2D, [_shadow textureID]);
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _shadow.getModelProjectionViewMatrix.m);
    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, _shadow.getNormalMatrix.m);
    glDrawElements(GL_TRIANGLES, _shadow.getIndexCount, GL_UNSIGNED_SHORT, 0);
    //draw shadow
}

-(GLKVector3) getTransition{
    return _transition;
}

#pragma mark -  OpenGL ES 2 shader compilation

- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(_program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(_program, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(_program, GLKVertexAttribPosition, "position");
    glBindAttribLocation(_program, GLKVertexAttribNormal, "normal");
    glBindAttribLocation(_program, GLKVertexAttribTexCoord0, "texCoordIn");

    // Link program.
    if (![self linkProgram:_program]) {
        NSLog(@"Failed to link program: %d", _program);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_program) {
            glDeleteProgram(_program);
            _program = 0;
        }
        
        return NO;
    }

    // Get uniform locations.
    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(_program, "modelViewProjectionMatrix");
    uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(_program, "normalMatrix");
    uniforms[UNIFORM_HEIGHT]=glGetUniformLocation(_program,"height");
    uniforms[UNIFORM_RADIUS]=glGetUniformLocation(_program, "radius");
    //get position for the texture uniform used for multi texuture
    uniforms[UNIFORM_TEXTURE]=glGetUniformLocation(_program, "texture");
    
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_program, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}
/**
 *  used to test the correctness of the shader program
 **/
- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

@end
