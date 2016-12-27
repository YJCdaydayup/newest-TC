//
//  YLLoginView.h
//  DianZTC
//
//  Created by 杨力 on 31/10/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

typedef void(^ConfirmBlock)(NSString * user_code);
typedef void(^CancelBlock)();

@interface YLLoginView : UIView
@property (nonatomic,strong)     UITextField * user_code_field;
-(id)initWithVC:(UIWindow *)window withVc:(RootViewController *)vc;
-(void)clickCancelBtn:(CancelBlock)block;

@end
