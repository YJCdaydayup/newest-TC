//
//  UIButton+Shake.m
//  DianZTC
//
//  Created by 杨力 on 12/1/2017.
//  Copyright © 2017 杨力. All rights reserved.
//

#import "UIButton+Shake.h"

@implementation UIButton (Shake)

-(void)btn_leftShake{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.transform = CGAffineTransformMakeRotation(M_PI*0.01);
        
    } completion:^(BOOL finished) {
        
        [self btn_rightShake];
    }];
}

-(void)btn_rightShake{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.transform = CGAffineTransformMakeRotation(-M_PI*0.02);
        
    } completion:^(BOOL finished) {
        
        [self btn_leftShake];
        
    }];
}

@end
