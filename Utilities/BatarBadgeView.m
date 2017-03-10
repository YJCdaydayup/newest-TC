
//
//  BatarBadgeView.m
//  DianZTC
//
//  Created by 杨力 on 9/3/2017.
//  Copyright © 2017 杨力. All rights reserved.
//

#import "BatarBadgeView.h"

#define VWidth (18*S6)

@interface BatarBadgeView()
{
    UILabel *_numberLbl;
}
@end

@implementation BatarBadgeView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
//        CGPoint point = CGPointMake(CGRectGetMaxX(vc.frame), CGRectGetMinY(vc.frame));
//        self.center = point;
        self.size = CGSizeMake(VWidth, VWidth);
       
        self.backgroundColor = [UIColor redColor];
        self.font = [UIFont systemFontOfSize:10*S6];
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor whiteColor];
        self.layer.cornerRadius = VWidth/2.0;
        self.layer.masksToBounds = YES;
    }
    return self;
}

-(void)changeBadgeValue:(NSString *)number{
    
    self.text = number;
    if([number integerValue]==0){
        self.hidden = YES;
    }else{
        self.hidden = NO;
    }
}



@end
