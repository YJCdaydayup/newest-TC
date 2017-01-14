//
//  UIView+Tap.m
//  tap
//
//  Created by 杨力 on 14/1/2017.
//  Copyright © 2017 杨力. All rights reserved.
//

#import "UIView+Tap.h"

@implementation UIView (Tap)

-(void)addTapGestureCallback:(TapGestureBlock)block{
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction:)];
    [self addGestureRecognizer:tap];
    blockParam = block;
}

-(void)clickAction:(UITapGestureRecognizer *)tap{
    
    blockParam();
}

@end
