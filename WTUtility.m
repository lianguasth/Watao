//
//  WTUtility.m
//  Watao
//
//  Created by 连 承亮 on 14-3-26.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import "WTUtility.h"



@implementation WTUtility

-(id)init:(WTLine) la
         :(WTLine) lb{
    if(self = [super init]){
//        GLKVector3 pa0 = GLKVector3Make(0.0f,0.0f,0.0f);
//        GLKVector3 pa1 = GLKVector3Make(0.0f,1.0f,0.0f);
//        GLKVector3 pb0 = GLKVector3Make(0.0f,0.0f,1.0f);
//        GLKVector3 pb1 = GLKVector3Make(1.0f,0.0f,0.0f);
//        _la.pa = pa0;
//        _la.pb = pa1;
//        _lb.pa = pb0;
//        _lb.pb = pb1;
        _la = la;
        _lb = lb;
        _distance = -1.0f;
        GLKVector3 normal = [self calNormal:_la :_lb];
        _distance = [self calDistance:normal :_la :_lb];
        _planeB.pa = _la.pa;
        _planeB.pb = _la.pb;
        _planeB.pc = GLKVector3Add(_la.pa, normal);
        _nearestPoint = [self calNearestPoint:_planeB :_lb];
        return self;
    }
    return nil;
}

-(float)distance:(GLKVector3)vec{
    return sqrtf(vec.x*vec.x+vec.y*vec.y+vec.z*vec.z);
}

//distance between two points
-(float)distance:(GLKVector3)pa
                :(GLKVector3)pb{
    GLKVector3 vec = GLKVector3Subtract(pa, pb);
    return sqrtf(vec.x*vec.x+vec.y*vec.y+vec.z*vec.z);
}

-(float)calDistance:(GLKVector3)normal
                   :(WTLine) la
                   :(WTLine) lb{
    GLKVector3 vec = GLKVector3Make(la.pa.x-lb.pa.x, la.pa.y-lb.pa.y, la.pa.z-lb.pa.z);
    float d = GLKVector3DotProduct(vec, normal)/[self distance:normal];
    return fabsf(d);
}


-(GLKVector3)calNormal:(WTLine) linea
                      :(WTLine) lineb{
    GLKVector3 va = GLKVector3Make(linea.pa.x-linea.pb.x, linea.pa.y-linea.pb.y, linea.pa.z - linea.pb.z);
    GLKVector3 vb = GLKVector3Make(lineb.pa.x-lineb.pb.x, lineb.pa.y-lineb.pb.y, lineb.pa.z - lineb.pb.z);
    return GLKVector3CrossProduct(va, vb);
}

-(GLKVector3)calNearestPoint:(WTPlane)plane
:(WTLine) line{
    WTLine la,lb;
    la.pa = plane.pa;
    la.pb = plane.pb;
    lb.pa = plane.pb;
    lb.pb = plane.pc;
    GLKVector3 temp1 = GLKVector3Subtract(plane.pa, line.pa);
    GLKVector3 temp2 = GLKVector3Subtract(line.pb, line.pa);
    GLKVector3 normal = [self calNormal:la :lb];
    float t = GLKVector3DotProduct(normal, temp1)/GLKVector3DotProduct(normal, temp2);
    GLKVector3 res;
    res.x = line.pa.x + (line.pb.x - line.pa.x)*t;
    res.y = line.pa.y + (line.pb.y - line.pa.y)*t;
    res.z = line.pa.z + (line.pb.z - line.pa.z)*t;
    return res;
}

//impoatant getters
-(float)getDistance{
    return _distance;
}

-(GLKVector3)getNearestPoint{
    return _nearestPoint;
}

@end
