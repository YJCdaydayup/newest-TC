//
//  UIViewController+Extension.m
//  XCFApp
//
//  Created by callmejoejoe on 16/4/17.
//  Copyright © 2016年 Joey. All rights reserved.
//

#import "UIViewController+Extension.h"
#import "BatarManagerTool.h"

@implementation UIViewController (Extension)

- (void)pushWebViewWithURL:(NSString *)URL {
    UIViewController *viewCon = [[UIViewController alloc] init];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:viewCon.view.bounds];
    webView.backgroundColor = [UIColor redColor];
    [viewCon.view addSubview:webView];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    [webView loadRequest:request];
    [self.navigationController pushViewController:viewCon animated:YES];
}

-(void)pushToViewControllerWithTransition:(UIViewController *)viewController withDirection:(NSString *)direction type:(BOOL)loginBool{
    
    CATransition * animation = [CATransition animation];
    if(loginBool){
        animation.type = @"oglFlip";
    }else{
        animation.type = kCATransitionReveal;
    }
    animation.duration = 0.5f;
    if([direction isEqualToString:@"left"]){
        animation.subtype = kCATransitionFromLeft;
    }else if ([direction isEqualToString:@"right"]){
        animation.subtype = kCATransitionFromRight;
    }
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    [self.navigationController.view.layer addAnimation:animation forKey:@"123"];
    [self.navigationController pushViewController:viewController animated:NO];
}

-(void)popToViewControllerWithDirection:(NSString *)direction type:(BOOL)loginBool{
    
    CATransition * animation = [CATransition animation];
    if(loginBool){
        animation.type = @"oglFlip";
    }else{
        animation.type = kCATransitionReveal;
    }
    animation.duration = 0.5f;
    if([direction isEqualToString:@"left"]){
        animation.subtype = kCATransitionFromLeft;
    }else if ([direction isEqualToString:@"right"]){
        animation.subtype = kCATransitionFromRight;
    }
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    [self.navigationController.view.layer addAnimation:animation forKey:@"123"];
    [self.navigationController popViewControllerAnimated:NO];
}


@end
