//
//  HKPieChartView.h
//  PieChart
//
//  Created by hukaiyin on 16/6/20.
//  Copyright © 2016年 HKY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AnimationStopAction)();
@interface HKPieChartView : UIView

@property (nonatomic,copy) NSString * titleStr;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,copy) AnimationStopAction block;
- (void)updatePercent:(CGFloat)percent animation:(BOOL)animationed;
-(void)animationStop:(AnimationStopAction)block;
- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title;

@end
