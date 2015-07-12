//
//  WTBackground.m
//  Watao
//
//  Created by 连 承亮 on 14-4-9.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import "WTBackground.h"

@implementation WTBackground 

-(id)init{
    if (self = [super init]) {
        [self initVertex];
    }
    return self;
}

-(void)initVertex{
    _vertexCount = 4;
    _indexCount = 4;
    _vertices = (Vertex *)malloc(sizeof(Vertex)*_vertexCount);
    _indices = (GLushort *)malloc(sizeof(GLushort)*_indexCount);
    //init background with constant
    _vertices[0].coord = GLKVector4Make(10.0f,-15.0f,-20.0f,1.0);
    _vertices[0].normal = GLKVector4Make(0.0,0.0,1.0,1.0);
//    _vertices[0].textureCoords = GLKVector4Make(0,0,1,1);
    _vertices[0].textureCoords = GLKVector2Make(1,1);
    
    _vertices[1].coord = GLKVector4Make(10.0f,15.0f,-20.0f,1.0);
    _vertices[1].normal = GLKVector4Make(0.0,0.0,1.0,1.0);
//    _vertices[1].textureCoords = GLKVector4Make(1,0,1,1);
    _vertices[1].textureCoords = GLKVector2Make(1,0);
    
    _vertices[2].coord = GLKVector4Make(-10.0f,15.0f,-20.0f,1.0);
    _vertices[2].normal = GLKVector4Make(0.0,0.0,1.0,1.0);
//    _vertices[2].textureCoords = GLKVector4Make(1,1,1,1);
    _vertices[2].textureCoords = GLKVector2Make(0,0);
    
    _vertices[3].coord = GLKVector4Make(-10.0f,-15.0f,-20.0f,1.0);
    _vertices[3].normal = GLKVector4Make(0.0,0.0,1.0,1.0);
//    _vertices[3].textureCoords = GLKVector4Make(0,1,1,1);
    _vertices[3].textureCoords = GLKVector2Make(0,1);
    


    _indices[0] = (GLushort)1;
    _indices[1] = (GLushort)0;
    _indices[2] = (GLushort)2;
    _indices[3] = (GLushort)3;

}

@end
