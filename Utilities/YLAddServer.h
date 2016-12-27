//
//  YLLoginView.h
//  DianZTC
//
//  Created by 杨力 on 31/10/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

typedef void(^ConfirmBlock)();

@interface YLAddServer : UIView
@property (nonatomic,strong)     UITextField * user_code_field;
@property (nonatomic,strong)     UITextField * user_port_field;
@property (nonatomic,copy) ConfirmBlock block;

-(id)initWithVC:(UIWindow *)window withVc:(RootViewController *)vc;
-(void)clickConfirmBlock:(ConfirmBlock)block;

@end
