//
//  YLProgressHUD.h
//  DianZTC
//
//  Created by 杨力 on 26/8/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLProgressHUD : UIView

@property (nonatomic,strong) UIImageView * showImgView;

-(instancetype)initWithView:(UIView *)view;
-(void)show;
-(void)hide;

@end
