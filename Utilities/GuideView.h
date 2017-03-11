//
//  GuideView.h
//  杨力
//
//  Created by 杨力  on 16/1/3.
//  Copyright (c) 2016年 杨力 . All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GoBackBlock)();
@interface GuideView : UIView
@property(nonatomic,strong)NSMutableArray * imageArray;
-(GuideView *)initWithArray:(NSArray *)array andFrame:(CGRect)frame andBlock:(GoBackBlock)block;
@end
