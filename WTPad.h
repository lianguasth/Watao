//
//  WTPad.h
//  Watao
//
//  Created by 连 承亮 on 14-3-20.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTMeshObject.h"

#define WT_NUM_MESH 100
//set 100 mesh, aka, 1200 triangle
#define WT_PAD_NUM_VERTEX WT_NUM_MESH*2+2
#define WT_PAD_NUM_INDEX WT_NUM_MESH*2*3+WT_NUM_MESH*2*3
/**
 * a table that could be padded under the pottery
 * and rotate with it
 */
@interface WTPad : WTMeshObject{
    GLfloat _radius;
}

-(id)WTPadHeight:(GLfloat)H Radius:(GLfloat)R;
//deprecated
-(id)init;

@end
