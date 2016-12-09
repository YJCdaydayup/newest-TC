//
//  YLCoder2D.h
//  原生的生成二维码
//
//  Created by 杨力 on 29/9/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLCoder2D : UIView

@property (nonatomic,strong) UIImageView * imgView;
@property (nonatomic,copy) NSString * urlStr;

//+(instancetype)shareInstance;
-(void)createView2DCoder;
-(void)scan2DCoder;

@end
