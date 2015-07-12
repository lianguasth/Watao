//
//  WTViewController.h
//  Watao
//
//  Created by 连 承亮 on 14-2-27.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "WTPottery.h"
#import "WTPad.h"
#import "WTBackground.h"
#import "WTShadow.h"

/**
 * this class is the root class which contains the pottery 
 */
@interface WTPotteryViewController : GLKViewController   {
    GLuint _program;
    float _rotation;
    WTPottery *_pottery;
    WTPad *_pad;
    WTBackground *_background;
    WTShadow *_shadow;
    GLKVector3 _scale;
    GLKVector3 _transition;
    float _perspective;
    GLuint _textureSlot;
}
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;


- (void)setupGL;
-(void)setupGLfor: (GLint)vertexArrayID
                 :(GLint)vertexBufferID
                 :(GLint)indexBufferID
                 :(WTMeshObject *)object;
- (void)tearDownGL;

- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;

//important getter
-(GLKVector3) getTransition;
//return the transition of basic model view matrix
@end


/**
 * a protocol declares a method to handle "shape" gesture
 */
@protocol ShapePotteryDelegate <NSObject>

@required
-(IBAction)shape:(UIPanGestureRecognizer*)paramSender;

@end

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

// Uniform index.
enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    UNIFORM_NORMAL_MATRIX,
    UNIFORM_HEIGHT,
    UNIFORM_RADIUS,
    UNIFORM_TEXTURE,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

// Attribute index.
enum
{
    ATTRIB_VERTEX,
    ATTRIB_NORMAL,
    ATTRIB_TEXTURE,
    NUM_ATTRIBUTES
};

enum{
    VERTEX_ARRAY_POTTERY,
    VERTEX_ARRAY_PAD,
    VERTEX_ARRAY_BACKGROUND,
    VERTEX_ARRAY_SHADOW,
    NUM_VERTEX_ARRAY
};
GLuint vertexArraies[NUM_VERTEX_ARRAY];
//define the vertex array

enum{
    VERTEX_BUFFER_POTTERY,
    VERTEX_BUFFER_PAD,
    VERTEX_BUFFER_BACKGROUND,
    VERTEX_BUFFER_SHADOW,
    NUM_VERTEX_BUFFER
};
GLuint vertexBuffers[NUM_VERTEX_BUFFER];
//define the vertex buffer

enum{
    INDEX_BUFFER_POTTERY,
    INDEX_BUFFER_PAD,
    INDEX_BUFFER_BACKGROUND,
    INDEX_BUFFER_SHADOW,
    NUM_INDEX_BUFFER
};
GLuint indexBuffers[NUM_INDEX_BUFFER];
//define the index buffer


