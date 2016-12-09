//
//  YLCustomerHUD.h
//  DianZTC
//
//  Created by 杨力 on 23/11/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CustomerHudBlock)(NSInteger index);

@interface YLCustomerHUD : UIView{
    
    UIWindow * myWindow;
    UIView * maskView;
}
@property (nonatomic,copy) CustomerHudBlock block;

-(instancetype)initWithWindow:(UIWindow *)window;
-(void)clickCustomerBtn:(CustomerHudBlock)block;

@end
