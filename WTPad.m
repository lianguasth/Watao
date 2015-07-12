//
//  WTPad.m
//  Watao
//
//  Created by 连 承亮 on 14-3-20.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//
#import "WTPad.h"
//a rotating pad set under the pottery
@implementation WTPad

-(id)WTPadHeight:(GLfloat)H Radius:(GLfloat)R{
    _height = H;
    _radius = R;
    _indexCount = WT_PAD_NUM_INDEX;
    _vertexCount = WT_PAD_NUM_VERTEX;
    _vertices = (Vertex *)malloc(sizeof(Vertex)*_vertexCount);
    _indices = (GLushort *)malloc(sizeof(GLushort)*_indexCount);
    //init
    for (int i = 0; i < 2; i++) {
        for(int j =0; j < WT_NUM_MESH; j++){
            _vertices[i*WT_NUM_MESH+j].coord = GLKVector4Make(R*cos((GLfloat)j*2.0f*M_PI/WT_NUM_MESH), (GLfloat)i*_height, R*sin((GLfloat)j*2.0f*M_PI/WT_NUM_MESH), 1.0f);
            _vertices[i*WT_NUM_MESH+j].normal = GLKVector4Make((GLfloat)cos(j*2.0f*M_PI/WT_NUM_MESH), 0.0f, (GLfloat)sin(j*2.0f*M_PI/WT_NUM_MESH), 1.0f);
        }
    }
    _vertices[WT_PAD_NUM_VERTEX-2].coord = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
    _vertices[WT_PAD_NUM_VERTEX-2].normal = GLKVector4Make(0.0f,-1.0f,0.0f,1.0f);
    _vertices[WT_PAD_NUM_VERTEX-1].coord = GLKVector4Make(0.0f, _height, 0.0f, 1.0f);
    _vertices[WT_PAD_NUM_VERTEX-1].normal = GLKVector4Make(0.0f,1.0f,0.0f,1.0f);
    //init the vertex;
    for (int i = 0; i < WT_NUM_MESH; i++) {
        _indices[i*6+0]=i;
        _indices[i*6+1]=(i+1)%WT_NUM_MESH;
        _indices[i*6+2]=WT_NUM_MESH+i;
       
        _indices[i*6+3]=(i+1)%WT_NUM_MESH;
        _indices[i*6+4]=WT_NUM_MESH+(i+1)%WT_NUM_MESH;
        _indices[i*6+5]=WT_NUM_MESH+i;
    }
    for (int i = 0; i < WT_NUM_MESH; i++) {
        _indices[WT_NUM_MESH*3*2+i*3+0]= WT_PAD_NUM_VERTEX-2;
        _indices[WT_NUM_MESH*3*2+i*3+1]= i;
        _indices[WT_NUM_MESH*3*2+i*3+2]= (i+1)%WT_NUM_MESH;
        //upper front
        _indices[WT_NUM_MESH*3*2+WT_NUM_MESH*3+i*3+0]= WT_PAD_NUM_VERTEX-1;
        _indices[WT_NUM_MESH*3*2+WT_NUM_MESH*3+i*3+1]= WT_NUM_MESH+i;
        _indices[WT_NUM_MESH*3*2+WT_NUM_MESH*3+i*3+2]= WT_NUM_MESH+(i+1)%WT_NUM_MESH;
        //lower front
    }
    //init the index
    WTPad *pad = [self init];
    return pad;
}

-(id)init{
    if(self = [super init]){
        return self;
    }
    NSLog(@"initial failed!");
    return nil;
}





@end
