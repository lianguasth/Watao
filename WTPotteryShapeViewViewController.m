//
//  WTPotteryShapeViewViewController.m
//  Watao
//
//  Created by 连 承亮 on 14-3-23.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import "WTPotteryShapeViewViewController.h"

@interface WTPotteryShapeViewViewController ()

@end

@implementation WTPotteryShapeViewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)shape:(UIPanGestureRecognizer *)paramSender{
    if(paramSender.state == UIGestureRecognizerStateChanged){
        CGPoint translation = [paramSender translationInView:self.view];
        CGPoint location = [paramSender locationInView:self.view];
        GLKVector3 tran = [self getTransition];
        GLKVector3 camera = GLKVector3Make(0.0f, 0.0f, 0.0f);
        //FIXME gravity change the position of camera
        float distance;
        GLKVector3 positonInWorld = [self convertScreenToWorld:location Perspective:_perspective Pottery:_pottery Positon:tran Camera:camera distance:&distance];
        float y = positonInWorld.y - _transition.y;
        CGSize frameSize = self.view.frame.size;
        
        //TODO box have to be completed
        if (abs(translation.y)>abs(translation.x)) {
            if(translation.y<0){
                [_pottery taller:y :_scale.y :distance];
            }else if(translation.y > 0){
                [_pottery shorter: y :_scale.y :distance];
            }
        }
        else{
            if((translation.x>0 && location.x>frameSize.width/2)||(translation.x<0&&location.x<frameSize.width/2)){
                [_pottery fatter: y : _scale.y : distance];
                //getting larger
            }else if((translation.x>0 && location.x<frameSize.width/2)||(translation.x<0&&location.x>frameSize.width/2)){
                [_pottery thinner: y : _scale.y : distance];
                //getting thinner
            }
        }
        [paramSender setTranslation:CGPointMake(0, 0) inView:self.view];
    }
}

/**
 * convert the screen on touch to the world
 */

-(GLKVector3)convertScreenToWorld:(CGPoint)pScreen
                      Perspective: (float)perspective
                          Pottery: (WTPottery *)pottery
                          Positon: (GLKVector3)potteryPositon
                           Camera:(GLKVector3) cameraPoint
                         distance:(float *)distance
{
    //compute the position of Xs and Ys
    CGSize size = self.view.frame.size;
    float height = tan(GLKMathDegreesToRadians(perspective/2.0f));
    float width = height*(float)size.width/(float)size.height;
    //let's assume distance from screen to eye is 1
    float xs = (pScreen.x - size.width/2.0f)/size.width*width*2.0f;
    float ys =  (size.height/2.0f - pScreen.y)/size.height*height*2.0f;
    //convert linear equation of the eye line is (tXs,tYs,t)=0 (t > 0)
    //calculate the nearest point on the pottery axis
    GLKVector3 pTouch = GLKVector3Make(xs,ys,-1.0f);
    GLKVector3 pPottery = GLKVector3Make(potteryPositon.x, 0.0f, potteryPositon.z);
    WTLine la,lb;
    la.pa = cameraPoint;
    la.pb = pTouch;
    //set the first line: eye line
    lb.pa = potteryPositon;
    lb.pb = pPottery;
    WTUtility *utility = [[WTUtility alloc] init:la :lb];
    //calculate the distance and nearest point
    *distance = utility.getDistance;
    GLKVector3 point = utility.getNearestPoint;
    return point;
}



@end
