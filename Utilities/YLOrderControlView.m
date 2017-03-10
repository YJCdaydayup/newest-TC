//
//  YLOrderControlView.m
//  DianZTC
//
//  Created by 杨力 on 31/10/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "YLOrderControlView.h"
#import "BatarBadgeView.h"

@interface YLOrderControlView()

/** 数量显示 */
@property (nonatomic,strong) BatarBadgeView *badgeView;

/** 购物车按钮 */
@property (nonatomic,strong) UIButton * shopCarBtn;

@end

@implementation YLOrderControlView

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self forKeyPath:ShopCarNumberNotification];
}

-(instancetype)init{
    
    if(self = [super init]){
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeBadgeValue:) name:ShopCarNumberNotification object:nil];
        self.frame = CGRectMake(0, Hscreen-51.5*S6, Wscreen, 65*S6);
        self.backgroundColor = [UIColor whiteColor];
        [self createView];
    }
    
    return self;
}

-(void)changeBadgeValue:(NSNotification *)notice{
    
    //tabbar
    [self.badgeView changeBadgeValue:[NSString stringWithFormat:@"%@",notice.object]];
}

-(void)createView{
    
    UIView * line_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Wscreen, 1*S6)];
    line_view.backgroundColor = BOARDCOLOR;
    [self addSubview:line_view];
    
    NSArray * titleArray = @[@"首页",@"我的收藏",@"购物车",@"加入购物车"];
    NSArray * imgArray = @[@"first_page",@"my_saved",@"shoppingcar_sel",@"my_addin"];
    NSArray * imgSelectArray = @[@"first_page_select",@"my_saved_select",@"shoppingcar_nor",@"my_order_select"];
    
    for(int i=0;i<titleArray.count;i++){
        UIButton * btn;
        if(i != titleArray.count-1){
            
            btn = [Tools createButtonNormalImage:imgArray[i] selectedImage:nil tag:i addTarget:self action:@selector(clickBtn:)];
            [btn setImage:[UIImage imageNamed:imgSelectArray[i]] forState:UIControlStateHighlighted];
            btn.frame = CGRectMake((Wscreen-195*S6)/3.0*i, CGRectGetMaxY(line_view.frame)-13*S6, (Wscreen-195*S6)/3.0, 65*S6);
            [self addSubview:btn];
            
            UILabel * label = [Tools createLabelWithFrame:CGRectMake(5*S6, 50*S6, 50*S6, 11*S6) textContent:titleArray[i] withFont:[UIFont systemFontOfSize:11*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentCenter];
            [btn addSubview:label];
            if(i == 2){
                self.shopCarBtn = btn;
            }
            
        }else{
            
            btn = [Tools createButtonNormalImage:imgArray[i] selectedImage:nil tag:i addTarget:self action:@selector(clickBtn:)];
            btn.frame = CGRectMake((Wscreen-195*S6),0, 195*S6, 52*S6);
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.backgroundColor = RGB_COLOR(231, 140, 59, 1);
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

-(BatarBadgeView *)badgeView{
    
    if(!_badgeView){
        _badgeView= [[BatarBadgeView alloc]initWithFrame:CGRectMake(35*S6,13*S6,20,20)];
        [self.shopCarBtn addSubview:_badgeView];
    }
    return _badgeView;
}

@end
