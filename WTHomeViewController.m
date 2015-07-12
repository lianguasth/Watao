//
//  WTHomeViewController.m
//  Watao
//
//  Created by 连 承亮 on 14-3-12.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import "WTHomeViewController.h"
#import "WTPotteryViewController.h"

@implementation WTHomeViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(IBAction) handleTaps:(UITapGestureRecognizer*)paramSender{
    UIView *view = [self.view.subviews objectAtIndex:0];
//    if(view.tag == 100){
//        [view removeFromSuperview];
//    }
//    //remove the view from the hierachy
//    WTShapeViewController* shapView = [[WTShapeViewController alloc]init];
//    [self presentViewController:shapView animated:YES completion:NULL];
    CGFloat h = self.view.frame.size.height;
    CGFloat w = self.view.frame.size.width;
    CGRect frame = view.frame;
    frame.size.height = h;
    frame.size.width = w;
    frame.origin.x = 0;
    frame.origin.y = 0;    
    [view setFrame:frame];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
