//
//  YLShoppingCarBottom.m
//  DianZTC
//
//  Created by 杨力 on 26/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "YLShoppingCarBottom.h"

@implementation YLShoppingCarBottom

+(instancetype)shareCarBottom{
    
    static YLShoppingCarBottom * bottom = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bottom = [[YLShoppingCarBottom alloc]init];
    });
    return bottom;
}

-(instancetype)init{
    
    if(self = [super init]){
        
        self.frame = CGRectMake(0, Hscreen-TABBAR_HEIGHT-40.5*S6, Wscreen, 40.5*S6);
        [self createView];
    }
    return self;
}

-(void)createView{
    
    self.selectAllBtn = [Tools createButtonNormalImage:@"no_select" selectedImage:@"select" tag:10000 addTarget:self action:@selector(clickBtn:)];
    self.selectAllBtn.frame = CGRectMake(12.5*S6, 24.5/2.0*S6, 16*S6, 16*S6);
    [self addSubview:self.selectAllBtn];
    
    UIControl * selectView = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, 40*S6, 40.5*S6)];
    selectView.backgroundColor = [UIColor clearColor];
    [selectView addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    selectView.tag = 0;
    [self addSubview:selectView];
    
    UILabel * title = [Tools createLabelWithFrame:CGRectMake(CGRectGetMaxX(self.selectAllBtn.frame)-5*S6, 13.5*S6, 50, 13*S6) textContent:@"全选" withFont:[UIFont systemFontOfSize:12*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentCenter];
    [self addSubview:title];
    
    UIButton * delete = [Tools createNormalButtonWithFrame:CGRectMake(Wscreen-180*S6, 0, 90*S6, 40.5*S6) textContent:@"删除" withFont:[UIFont systemFontOfSize:12*S6] textColor:RGB_COLOR(153, 37, 42, 1) textAlignment:NSTextAlignmentCenter];
    delete.tag = 1;
    delete.layer.borderWidth = 0.1*S6;
    delete.layer.borderColor = [BOARDCOLOR CGColor];
    [delete setTitleColor:RGB_COLOR(29, 29, 29, .5) forState:UIControlStateHighlighted];
    [self addSubview:delete];
    delete.backgroundColor = CELLBGCOLOR;
    [delete addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * confirm = [Tools createNormalButtonWithFrame:CGRectMake(Wscreen-90*S6, 0, 90*S6, 40.5*S6) textContent:@"确认选购" withFont:[UIFont systemFontOfSize:12*S6] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    confirm.tag = 2;
    [confirm setTitleColor:RGB_COLOR(29, 29, 29, .5) forState:UIControlStateHighlighted];
    confirm.backgroundColor = TABBARTEXTCOLOR;
    [confirm addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirm];
    
    UIView * topline = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Wscreen, 1*S6)];
    topline.backgroundColor = BTNBORDCOLOR;
    [self addSubview:topline];
}

-(void)clickBtn:(UIButton *)btn{
    
    if(btn.tag == 0){
        self.selectAllBtn.selected = !self.selectAllBtn.selected;
    }
    
    if(self.block){
        self.block(btn.tag);
    }
}

+(void)clickShoppingCar:(ShoppingCarBlock)block{
    
    YLShoppingCarBottom * bottom = [YLShoppingCarBottom shareCarBottom];
    bottom.block = block;
}

@end
