//
//  WTHomeViewController.h
//  Watao
//
//  Created by 连 承亮 on 14-3-12.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTHomeViewController;


@interface WTHomeViewController : UIViewController

@property (nonatomic, strong) UITapGestureRecognizer *tapGuestureRecognizer;

-(IBAction) handleTaps:(UITapGestureRecognizer*)paramSender;

@end

