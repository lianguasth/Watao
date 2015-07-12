//
//  WTPottery.h
//  Watao
//
//  Created by 连 承亮 on 14-2-28.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#ifndef Watao_WTPottery_h
#define Watao_WTPottery_h

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import <Foundation/Foundation.h>
#import <math.h>
#import "WTMeshObject.h"

#define WT_NUM_LEVEL 50
#define WT_NUM_VERTEX 51

typedef struct{
    float maxHeight;
    float minHeight;
    float maxRadius;
    float minRadius;
    GLKVector3 bottomCenter;
    float height;
    float maxRadiusNow;//define the radius now
}BoundingBox;


@interface WTPottery : WTMeshObject{
    float _thickness;
    //indicate the position of each vertex with two levels
    GLfloat _radius[WT_NUM_LEVEL];
    //define an array to store the index
    BoundingBox _boundingBox;
}


-(id)WTPotteryIH:(float)initHeight IR:(float)initRadius MINH:(float)minHeight MINR:(float)minRadius MAXH:(float)maxHeight MAXR:(float)maxRadius TH:(float)thickness;
-(id)init;
//init the pottery
-(void)updateVertex;
-(void)updateNormal;
-(void)updateTexture;
-(void)initIndex;
//compute update when changes
-(void)thinner:(float)y :(float)scale :(float)distance;
-(void)fatter:(float)y :(float)scale :(float)distance;
-(void)shorter :(float)y :(float)scale :(float)distance;
-(void)taller :(float)y :(float)scale :(float)distance;
-(float)gaussianDelta: (float) delta Mean: (float) mean X: (float) x;
//response the user actions
-(BoundingBox)getBoundingBox;
//important getters
@end


#endif
