//
//  YLProgressHUD.m
//  DianZTC
//
//  Created by 杨力 on 26/8/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "YLProgressHUD.h"

@interface YLProgressHUD(){
    
    UIView * parentView;//父视图
    UIView * maskView;
}

@end

@implementation YLProgressHUD

-(instancetype)initWithView:(UIView *)view{
    
    if(self = [super init]){
        
        self.frame = view.frame;
        parentView = view;
        [self createHud];
        [view addSubview:self];
        [view bringSubviewToFront:self];
    }
    return self;
}

-(void)createHud{
    
    maskView = [[UIView alloc]initWithFrame:parentView.bounds];
    maskView.backgroundColor = RGB_COLOR(29, 29, 29, 0.01);
    [self addSubview:maskView];
    
    UIImage * image = [UIImage sd_animatedGIFNamed:@"move"];
    self.showImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    self.showImgView.image = image;
    self.showImgView.center = CGPointMake(Wscreen/2.0, Hscreen/2.0);
    [maskView addSubview:self.showImgView];
    self.showImgView.alpha = 0;
}

-(void)show{
    
    maskView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.showImgView.alpha = 1;
        maskView.alpha = 0.3;
    }];
}

-(void)hide{
    
    maskView.userInteractionEnabled = YES;
    [UIView animateWithDuration:0.2 animations:^{
       
        self.showImgView.alpha = 0;
        maskView.alpha = 0;
    }];
}

@end
