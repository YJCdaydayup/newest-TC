
//
//  YLCustomerHUD.m
//  DianZTC
//
//  Created by 杨力 on 23/11/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "YLCustomerHUD.h"

@implementation YLCustomerHUD
-(instancetype)initWithWindow:(UIWindow *)window{
    
    if(self = [super init]){
        
        
        myWindow = window;
        self.frame = myWindow.bounds;
        [myWindow addSubview:self];
        [self createView];
    }
    return self;
}

-(void)createView{
    
    maskView = [[UIView alloc]initWithFrame:self.bounds];
    maskView.backgroundColor = RGB_COLOR(29, 29, 29, 0.5);
    [self addSubview:maskView];
    
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 280*S6, 190*S6)];
    bgView.center = self.center;
    bgView.backgroundColor = RGB_COLOR(234, 234, 234, 1);
    bgView.layer.cornerRadius = 10*S6;
    bgView.layer.masksToBounds = YES;
    [maskView addSubview:bgView];
    
    UILabel * label = [Tools createLabelWithFrame:CGRectMake(0, 3*S6, 280*S6, 34*S6) textContent:@"提示" withFont:[UIFont systemFontOfSize:17*S6] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
    [bgView addSubview:label];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, label.height+5*S6, 280*S6, 1*S6)];
    line1.backgroundColor = RGB_COLOR(204, 204, 204, 1);
    [bgView addSubview:line1];
    
    UILabel * textLabel = [Tools createLabelWithFrame:CGRectMake(30*S6, 38*S6, 220*S6, 100*S6) textContent:@"客户编号错误，请询问业务员或者下次再填!" withFont:[UIFont systemFontOfSize:16*S6] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    textLabel.numberOfLines = 0;
    textLabel.lineSpace = 10*S6;
    [textLabel getLableRectWithMaxWidth:100*S6];
    [bgView addSubview:textLabel];
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 138*S6, 280*S6, 1*S6)];
    line2.backgroundColor = RGB_COLOR(204, 204, 204, 1);
    [bgView addSubview:line2];
    
    UIButton * nextTimeBtn = [Tools createNormalButtonWithFrame:CGRectMake(55/2.0*S6, CGRectGetMaxY(line2.frame)+10*S6, 95*S6, 31.5*S6) textContent:@"下次再说" withFont:[UIFont systemFontOfSize:15*S6] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    nextTimeBtn.backgroundColor = RGB_COLOR(195, 179, 180, 1);
    [self confgiBtn:nextTimeBtn];
    nextTimeBtn.tag = 0;
    [bgView addSubview:nextTimeBtn];
    
    UIButton * retryBtn = [Tools createNormalButtonWithFrame:CGRectMake(CGRectGetMaxX(nextTimeBtn.frame)+35*S6, CGRectGetMinY(nextTimeBtn.frame), nextTimeBtn.width, nextTimeBtn.height) textContent:@"重新填写" withFont:[UIFont systemFontOfSize:15*S6] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
        retryBtn.backgroundColor = RGB_COLOR(220, 120, 39, 1);
    [self confgiBtn:retryBtn];
    retryBtn.tag = 1;
    [bgView addSubview:retryBtn];
    
    [nextTimeBtn addTarget:self action:@selector(nextTime:) forControlEvents:UIControlEventTouchUpInside];
    [retryBtn addTarget:self action:@selector(retryAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)nextTime:(UIButton *)btn{
    
    if(self.block){
        self.block(btn.tag);
    }
    
    [UIView animateWithDuration:0.5 animations:^{
       
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)retryAction:(UIButton *)btn{
    
    if(self.block){
        self.block(btn.tag);
    }
    [UIView animateWithDuration:0.5 animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)clickCustomerBtn:(CustomerHudBlock)block{
    
    self.block = block;
}

-(void)confgiBtn:(UIButton *)btn{
    
    btn.layer.cornerRadius = 5*S6;
    btn.layer.masksToBounds = YES;
}

@end
