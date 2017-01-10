//
//  YLLoginView.m
//  DianZTC
//
//  Created by 杨力 on 31/10/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "YLAddServer.h"
#import "NetManager.h"
#import "YLServerAddView.h"

@interface YLAddServer()<UITextFieldDelegate>{
    
    UIWindow * parentVc;
    UIView * maskView;
    UIView * controlView;
    UIButton * confirm_btn;
    UIButton * cancel_btn;
    RootViewController * currentVc;
    UILabel * wrongLabel;
}

@property (nonatomic,copy) ConfirmBlock confirm_block;

@end

@implementation YLAddServer

-(id)initWithVC:(UIWindow *)window withVc:(RootViewController *)vc{
    
    if(self = [super init]){
        
        //        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        //        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        currentVc = vc;
        parentVc = window;
        self.frame = parentVc.bounds;
        [self createView];
    }
    
    return self;
}

//-(void)keyBoardWillShow:(NSNotification *)notification{
//
////    [user_code_field resignFirstResponder];
//    // 获取通知的信息字典
//    NSDictionary *userInfo = [notification userInfo];
//
//    // 获取键盘弹出后的rect
////    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
////    CGRect keyboardRect = [aValue CGRectValue];
//
//    // 获取键盘弹出动画时间
//    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSTimeInterval animationDuration;
//    [animationDurationValue getValue:&animationDuration];
//
//    // 调用代理
//    [UIView animateWithDuration:animationDuration animations:^{
//        parentVc.transform = CGAffineTransformMakeTranslation(0, -50*S6);
//    }];
//}
//-(void)keyBoardWillHide:(NSNotification *)notification{
//
////    [user_code_field resignFirstResponder];
//
//    // 获取通知的信息字典
//    NSDictionary *userInfo = [notification userInfo];
//
//    // 获取键盘弹出动画时间
//    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSTimeInterval animationDuration;
//    [animationDurationValue getValue:&animationDuration];
//
//    // 调用代理
//    [UIView animateWithDuration:animationDuration animations:^{
//        parentVc.transform = CGAffineTransformIdentity;
//    }];
//}

-(void)createView{
    
    maskView = [[UIView alloc]initWithFrame:self.bounds];
    maskView.backgroundColor = RGB_COLOR(29, 29, 29, 0.6);
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    [maskView addGestureRecognizer:tap];
    [self addSubview:maskView];
    
    controlView = [[UIView alloc]initWithFrame:CGRectMake(0, -140*S6, 275*S6, 140*S6)];
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
    
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 12*S6, 32*S6)];
    self.user_code_field = [Tools createTextFieldFrame:CGRectMake(12.5*S6, 30*S6, 160*S6, 35*S6) placeholder:nil bgImageName:nil leftView:leftView rightView:nil isPassWord:NO];
    self.user_code_field.text = @"zbtj.batar.cn";
    self.user_code_field.delegate = self;
    [self setTextfield:self.user_code_field];
    [controlView addSubview:self.user_code_field];
    
    UIView * leftViews = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 12*S6, 32*S6)];
    self.user_port_field = [Tools createTextFieldFrame:CGRectMake(CGRectGetMaxX(self.user_code_field.frame)+8*S6, 30*S6, 80*S6, 35*S6) placeholder:@"填写端口号" bgImageName:nil leftView:leftViews rightView:nil isPassWord:NO];
    [self setTextfield:self.user_port_field];
    self.user_port_field.delegate = self;
    [controlView addSubview:self.user_port_field];
    
    wrongLabel = [Tools createLabelWithFrame:CGRectMake(24*S6, CGRectGetMaxY(self.user_code_field.frame)+5*S6, 232*S6, 14*S6) textContent:@"输入域名或端口号有误，请重新输入!" withFont:[UIFont systemFontOfSize:12*S6] textColor:[UIColor redColor] textAlignment:NSTextAlignmentLeft];
    wrongLabel.alpha = 0;
    [controlView addSubview:wrongLabel];
    
    confirm_btn = [Tools createNormalButtonWithFrame:CGRectMake(20*S6, CGRectGetMaxY(self.user_code_field.frame)+25*S6, 470/2.0*S6, 75/2.0*S6) textContent:@"确认添加" withFont:[UIFont systemFontOfSize:18*S6] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    confirm_btn.backgroundColor = RGB_COLOR(231, 140, 59, 1);
    confirm_btn.layer.cornerRadius = 75/2.0/2.0*S6;
    confirm_btn.layer.masksToBounds = YES;
    [controlView addSubview:confirm_btn];
    
    [confirm_btn addTarget:self action:@selector(confrimAction) forControlEvents:UIControlEventTouchUpInside];
    [self move];
}

-(void)setTextfield:(UITextField *)tf{
    
    tf.layer.borderWidth = 1*S6;
    tf.layer.borderColor = [RGB_COLOR(204, 204, 204, 1)CGColor];
    tf.layer.cornerRadius = 5*S6;
    tf.layer.masksToBounds = YES;
    tf.font = [UIFont systemFontOfSize:12*S6];
}

-(void)hideKeyboard{
    
    [self.user_code_field resignFirstResponder];
    [self.user_port_field resignFirstResponder];
    
    [self cancelAction];
}

-(void)move{
    
    [UIView animateWithDuration:0.8 delay:0.1 usingSpringWithDamping:0.2 initialSpringVelocity:0.15 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        controlView.y = 180*S6;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)confrimAction{
    
    wrongLabel.alpha = 0;
    [self.user_code_field resignFirstResponder];
    [self.user_port_field resignFirstResponder];
    
    if(self.user_port_field.text.length==0||self.user_code_field.text.length==0){
        [UIView animateWithDuration:0.1 animations:^{
            wrongLabel.text = @"请输入域名或端口号!";
            wrongLabel.alpha = 1;
        }];
        return;
    }
    
    
    NetManager * manager = [NetManager shareManager];
    [manager checkIPCompareWithIP:self.user_code_field.text port:self.user_port_field.text callback:^(NSString *response, NSError *error) {
        
        if(error == nil){
            [UIView animateWithDuration:0.5 animations:^{
                controlView.alpha = 0;
                maskView.alpha = 0;
            } completion:^(BOOL finished) {
                [self clearViews];
            }];
            [manager saveCurrentIP:self.user_port_field.text withPort:self.user_code_field.text];
            if(self.block){
                self.block();
            }
        }else{
            [UIView animateWithDuration:0.1 animations:^{
                wrongLabel.text = @"输入域名或端口号有误，请重新输入!";
                wrongLabel.alpha = 1;
            }];
        }
    }];
}

-(void)clickConfirmBlock:(ConfirmBlock)block{
    
    self.block = block;
}

-(void)cancelAction{
    
    [UIView animateWithDuration:0.5 animations:^{
        controlView.alpha = 0;
        maskView.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self clearViews];
    }];
}

-(void)clearViews{
    
    [controlView removeFromSuperview];
    [maskView removeFromSuperview];
    [self removeFromSuperview];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField == self.user_code_field){
        [self.user_code_field resignFirstResponder];
        [self.user_port_field becomeFirstResponder];
    }else{
        [self.user_code_field resignFirstResponder];
        [self.user_port_field resignFirstResponder];
    }
    return YES;
}

@end
