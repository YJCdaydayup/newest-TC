//
//  YLLoginAlert.m
//  DianZTC
//
//  Created by 杨力 on 13/10/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "YLLoginAlert.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@implementation YLLoginAlert

+(void)showLoginAlert{
    
    UIAlertController * alert_contr = [UIAlertController alertControllerWithTitle:@"提示:" message:@"您的账户在异地登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * re_loginAction = [UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * cancel_action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert_contr addAction:re_loginAction];
    [alert_contr addAction:cancel_action];
    
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window.rootViewController presentViewController:alert_contr animated:YES completion:^{
        
    }];
}

@end
