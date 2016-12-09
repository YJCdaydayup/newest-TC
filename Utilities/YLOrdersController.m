

//
//  YLOrdersController.m
//  DianZTC
//
//  Created by 杨力 on 3/11/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "YLOrdersController.h"

@implementation YLOrdersController

-(instancetype)init{
    
    if(self = [super init]){
        
        self.frame = CGRectMake(0, Hscreen-51.5*S6, Wscreen, 65*S6);
        self.backgroundColor = [UIColor whiteColor];
        [self createView];
    }
    
    return self;
}

-(void)createView{
    
    UIView * line_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Wscreen, 1*S6)];
    line_view.backgroundColor = BOARDCOLOR;
    [self addSubview:line_view];
    
    NSArray * titleArray = @[@"首页",@"我的订单",@"删除",@"确认选购"];
    NSArray * imgArray = @[@"first_page",@"myorders"];
    NSArray * imgSelectArray = @[@"first_page_select",@"myorders_select"];
    
    for(int i=0;i<titleArray.count;i++){
        UIButton * btn;
        if(i == 0||i == 1){
            
            btn = [Tools createButtonNormalImage:imgArray[i] selectedImage:nil tag:i addTarget:self action:@selector(clickBtn:)];
            [btn setImage:[UIImage imageNamed:imgSelectArray[i]] forState:UIControlStateHighlighted];
            btn.frame = CGRectMake((Wscreen-255*S6)/2.0*i, CGRectGetMaxY(line_view.frame)-13*S6, (Wscreen-255*S6)/2.0, 65*S6);
            [self addSubview:btn];
            
            UILabel * label = [Tools createLabelWithFrame:CGRectMake(5*S6, 50*S6, 50*S6, 11*S6) textContent:titleArray[i] withFont:[UIFont systemFontOfSize:11*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentCenter];
            [btn addSubview:label];
            
        }else{
            
            btn = [Tools createButtonNormalImage:nil selectedImage:nil tag:i addTarget:self action:@selector(clickBtn:)];
            btn.frame = CGRectMake((Wscreen-255*S6)+255*S6/2.0*(i-2), CGRectGetMaxY(line_view.frame)-0*S6, 255/2.0*S6, 52*S6);
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            if(i == 2){
                btn.backgroundColor = RGB_COLOR(166, 33, 33, 1);
            }else{
                btn.backgroundColor = RGB_COLOR(231, 140, 59, 1);
            }
            btn.titleLabel.font = [UIFont systemFontOfSize:16*S6];
            [self addSubview:btn];
        }
        btn.tag = i;
    }
    
}

-(void)clickBtn:(UIButton *)btn{
    
    if(self.block){
        self.block(btn.tag);
    }
}

-(void)clickBottomBtn:(BottomBtnBlock)block{
    
    self.block = block;
}

@end
