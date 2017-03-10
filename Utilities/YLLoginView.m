//
//  YLLoginView.m
//  DianZTC
//
//  Created by 杨力 on 31/10/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "YLLoginView.h"
#import "NetManager.h"

@interface YLLoginView(){
    
    UIWindow * parentVc;
    UIView * maskView;
    UIView * controlView;
    UIButton * confirm_btn;
    UIButton * cancel_btn;
    RootViewController * currentVc;
    UILabel * wrongLabel;
}

@property (nonatomic,copy) ConfirmBlock confirm_block;
@property (nonatomic,copy) CancelBlock cancel_block;

@end

@implementation YLLoginView

-(id)initWithVC:(UIWindow *)window withVc:(RootViewController *)vc{
    
    if(self = [super init]){
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        currentVc = vc;
        parentVc = window;
        self.frame = parentVc.bounds;
        [self createView];
    }
    
    return self;
}

-(void)keyBoardWillShow:(NSNotification *)notification{
    
//    [user_code_field resignFirstResponder];
    // 获取通知的信息字典
    NSDictionary *userInfo = [notification userInfo];
    
    // 获取键盘弹出后的rect
//    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
    
    // 获取键盘弹出动画时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // 调用代理
    [UIView animateWithDuration:animationDuration animations:^{
        parentVc.transform = CGAffineTransformMakeTranslation(0, -50*S6);
    }];
}

-(void)keyBoardWillHide:(NSNotification *)notification{
    
//    [user_code_field resignFirstResponder];
    
    // 获取通知的信息字典
    NSDictionary *userInfo = [notification userInfo];
    
    // 获取键盘弹出动画时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // 调用代理
    [UIView animateWithDuration:animationDuration animations:^{
        parentVc.transform = CGAffineTransformIdentity;
    }];
}

-(void)createView{
    
    maskView = [[UIView alloc]initWithFrame:self.bounds];
    maskView.backgroundColor = RGB_COLOR(29, 29, 29, 0.6);
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    [maskView addGestureRecognizer:tap];
    [self addSubview:maskView];
    
    controlView = [[UIView alloc]initWithFrame:CGRectMake(0, -190*S6, 280*S6, 190*S6)];
    controlView.backgroundColor = RGB_COLOR(235, 235, 235, 1);
    controlView.layer.borderColor = [RGB_COLOR(76, 66, 41, 1)CGColor];
    controlView.layer.borderWidth = 1*S6;
    controlView.layer.shadowColor = [[UIColor blackColor] CGColor];
    controlView.layer.shadowOpacity = 10;
    controlView.layer.cornerRadius = 5*S6;
    controlView.layer.masksToBounds = YES;
    controlView.layer.shadowOffset = CGSizeMake(5,5);
    controlView.centerX = self.centerX;
    [self addSubview:controlView];
    
    UILabel * title_label = [Tools createLabelWithFrame:CGRectMake(0, 17.5*S6, 280*S6, 17*S6) textContent:@"用户登录" withFont:[UIFont systemFontOfSize:18*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentCenter];
    [controlView addSubview:title_label];
    
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 12*S6, 32*S6)];
   self.user_code_field = [Tools createTextFieldFrame:CGRectMake(24*S6, CGRectGetMaxY(title_label.frame)+35*S6, 232*S6, 32*S6) placeholder:@"用户编号" bgImageName:nil leftView:leftView rightView:nil isPassWord:NO];
   
    self.user_code_field.layer.borderWidth = 1*S6;
    self.user_code_field.layer.borderColor = [RGB_COLOR(204, 204, 204, 1)CGColor];
    self.user_code_field.layer.cornerRadius = 5*S6;
    self.user_code_field.layer.masksToBounds = YES;
    [controlView addSubview:self.user_code_field];
    
    wrongLabel = [Tools createLabelWithFrame:CGRectMake(24*S6, CGRectGetMaxY(self.user_code_field.frame)+5*S6, 232*S6, 14*S6) textContent:@"输入客户编号有误，请重新输入!" withFont:[UIFont systemFontOfSize:14*S6] textColor:[UIColor redColor] textAlignment:NSTextAlignmentLeft];
    wrongLabel.alpha = 0;
    [controlView addSubview:wrongLabel];
    
    cancel_btn = [Tools createNormalButtonWithFrame:CGRectMake(27.5*S6, 42.5*S6+CGRectGetMaxY(self.user_code_field.frame), 95*S6, 31.5*S6) textContent:@"取消" withFont:[UIFont systemFontOfSize:17*S6] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    cancel_btn.layer.cornerRadius = 5*S6;
    cancel_btn.layer.masksToBounds = YES;
    cancel_btn.backgroundColor = RGB_COLOR(207, 193, 193, 1);
    [controlView addSubview:cancel_btn];
    
    confirm_btn = [Tools createNormalButtonWithFrame:CGRectMake(CGRectGetMaxX(cancel_btn.frame)+35*S6, CGRectGetMinY(cancel_btn.frame), 95*S6, 31.5*S6) textContent:@"登录" withFont:[UIFont systemFontOfSize:17*S6] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    confirm_btn.backgroundColor = RGB_COLOR(231, 140, 59, 1);
    confirm_btn.layer.cornerRadius = 5*S6;
    confirm_btn.layer.masksToBounds = YES;
    [controlView addSubview:confirm_btn];
    
    [confirm_btn addTarget:self action:@selector(confrimAction) forControlEvents:UIControlEventTouchUpInside];
    [cancel_btn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self move];
}

-(void)hideKeyboard{
    
    [self.user_code_field resignFirstResponder];
}

-(void)move{
    
    [UIView animateWithDuration:0.8 delay:0.1 usingSpringWithDamping:0.2 initialSpringVelocity:0.15 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        controlView.centerY = self.centerY;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)confrimAction{

    wrongLabel.alpha = 0;
    NetManager * manager = [NetManager shareManager];
    NSString * urlStr = [NSString stringWithFormat:LOGIN_URL,[manager getIPAddress]];
    NSDictionary * dict = @{@"number":self.user_code_field.text};
    [manager downloadDataWithUrl:urlStr parm:dict callback:^(id responseObject, NSError *error) {

        NSMutableDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString * state = [dict objectForKey:@"state"];
        if([state intValue] == 1){
            //发出通知
            [kUserDefaults setObject:self.user_code_field.text forKey:CustomerID];
            [[NSNotificationCenter defaultCenter]postNotificationName:UploadOrders object:nil];
            [UIView animateWithDuration:0.5 animations:^{
                controlView.alpha = 0;
                maskView.alpha = 0;
            } completion:^(BOOL finished) {
                [self clearViews];
            }];
        }else{
            [UIView animateWithDuration:0.1 animations:^{
                wrongLabel.alpha = 1;
            }];
        }
    }];
}

-(void)cancelAction{
    
    [UIView animateWithDuration:0.5 animations:^{
        controlView.alpha = 0;
        maskView.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self clearViews];
    }];
    if(self.cancel_block){
        self.cancel_block();
    }
}

-(void)clearViews{
    
    [controlView removeFromSuperview];
    [maskView removeFromSuperview];
    [self removeFromSuperview];
}

-(void)clickCancelBtn:(CancelBlock)block{

    if(self.cancel_block){
        self.cancel_block = block;
    }
}


@end
