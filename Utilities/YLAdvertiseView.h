//
//  YLAdvertiseView.h
//  DianZTC
//
//  Created by 杨力 on 15/2/2017.
//  Copyright © 2017 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLAdvertiseView : UIView

@property (nonatomic,assign) CGFloat showTime;
@property (nonatomic,strong) NSTimer * timer;

-(instancetype)initWithTime:(CGFloat)showTime;

@end
