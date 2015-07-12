//
//  WTMeshObject.h
//  Watao
//
//  Created by 连 承亮 on 14-3-21.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#define WT_VERTEX_STRIDE 48

typedef struct{
    GLKVector4 coord;
    GLKVector4 normal;
    //use vector 4 for the efficiency
    //the value still requires calculation in shader language
    //GLKVector4 textureCoords;
    GLKVector2 textureCoords;
} Vertex;



@interface WTMeshObject : NSObject{
    Vertex *_vertices;
    GLint _vertexCount;
    GLushort* _indices;
    GLint _indexCount;
    GLfloat _height;
    //the basic data
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    //matrix used for transformation and rendering
}

//hate to write getter and setter, change to property in the middle
@property (nonatomic) GLuint textureID;

-(id)init;
-(void)dealloc;
//some basic function
-(void)moveRotate:(float) rotate scale: (GLKVector3) scale translate:(GLKVector3)translate base:(GLKMatrix4)baseModelViewMatrix project:(GLKMatrix4) projectionMatrix;
//called to when update the transformation
-(GLKMatrix4) getModelProjectionViewMatrix;
-(void)setModelProjectionViewMatrix:(GLKMatrix4)matrix;
-(GLKMatrix3) getNormalMatrix;
-(Vertex *)getVertices;
-(GLushort *)getIndices;
-(GLint)getVertexCount;
-(GLint)getIndexCount;
-(GLfloat)getHeight;
//some important getter
-(GLuint)setupTexture:(NSString *)fileName;
//a function that load texture into memory
- (id)initUsingOBJWithPath:(NSString *)path;
//init and loadObj from file

@end
