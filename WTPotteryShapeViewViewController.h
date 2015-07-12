//
//  WTPotteryShapeViewViewController.h
//  Watao
//
//  Created by 连 承亮 on 14-3-23.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import "WTPotteryViewController.h"
#import "WTUtility.h"

@interface WTPotteryShapeViewViewController : WTPotteryViewController <ShapePotteryDelegate>

-(IBAction)shape:(UIPanGestureRecognizer *)paramSender;

@end
