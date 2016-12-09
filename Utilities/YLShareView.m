
//
//  YLShareView.m
//  DianZTC
//
//  Created by 杨力 on 15/11/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "YLShareView.h"
#import "AppDelegate.h"

@implementation YLShareView

+(id)shareManager{
    
    static YLShareView * shareView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareView = [[YLShareView alloc]initWithFrame:CGRectMake(0, Hscreen, Wscreen, 80*S6)];
        shareView.backgroundColor =[UIColor whiteColor];
    });
    return shareView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        [self createView];
    }
    return self;
}

-(void)createView{
    
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.maskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.maskView.backgroundColor = RGB_COLOR(29, 29, 29, 0.5);
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideView)];
    [self.maskView addGestureRecognizer:tap];
    [app.window.rootViewController.view addSubview:self.maskView];
    [app.window addSubview:self];
    
    NSArray * imgName = @[@"UMS_qq_icon",@"UMS_qzone_icon",@"UMS_wechat_session_icon",@"UMS_wechat_timeline_icon"];
    NSArray * titleArray = @[@"QQ",@"QQ空间",@"微信",@"朋友圈"];
    for(int i=0;i<titleArray.count;i++){
        
        UIButton * btn = [Tools createButtonNormalImage:imgName[i] selectedImage:nil tag:i addTarget:self action:@selector(btnClick:)];
        btn.frame = CGRectMake(20*S6+ Wscreen/4*i, 0, 58*S6, 58*S6);
        btn.backgroundColor = [UIColor whiteColor];
        [self addSubview:btn];
        
        UILabel * label = [Tools createLabelWithFrame:CGRectMake(0, 54*S6, 58*S6, 15*S6) textContent:titleArray[i] withFont:[UIFont systemFontOfSize:14*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentCenter];
        [btn addSubview:label];
    }
}

-(void)hideView{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.maskView.alpha = 0;
        self.y = Hscreen;
    }];
}

-(void)btnClick:(UIButton *)btn{
    
    if(self.block){
        self.block(btn.tag);
    }
}

-(void)clickShareBtn:(ClickShareBlock)block{
    self.block = block;
}

@end
