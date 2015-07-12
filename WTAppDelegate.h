//
//  WTAppDelegate.h
//  Watao
//
//  Created by 连 承亮 on 14-2-27.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTPottery.h"
#import "WTPad.h"
#import "WTBackground.h"
#import "WTShadow.h"

@interface WTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) WTPottery *pottery;
@property (strong, nonatomic) WTPad *pad;
@property (strong, nonatomic) WTBackground *background;
@property (strong, nonatomic) WTShadow *shadow;

@end
