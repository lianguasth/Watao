//
//  WTUtility.h
//  Watao
//
//  Created by 连 承亮 on 14-3-26.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

typedef struct{
    GLKVector3 pa;
    GLKVector3 pb;
}WTLine;

typedef struct{
    GLKVector3 pa;
    GLKVector3 pb;
    GLKVector3 pc;
    //pay attention that these three point must not be in a line
}WTPlane;


@interface WTUtility : NSObject{
    WTLine _la;
    WTLine _lb;
    //above is given, bellow is calculated
    WTPlane _planeB;
    float _distance;
    GLKVector3 _nearestPoint;
}
//line b is considered to be the target line where nearest point is on
-(id)init:(WTLine)la :(WTLine)lb;
//init and calculate at the same time
-(float)getDistance;
//return the distance
-(GLKVector3)getNearestPoint;
//return the nearest point
@end
