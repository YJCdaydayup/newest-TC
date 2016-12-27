//
//  YLShoppingCarBottom.h
//  DianZTC
//
//  Created by 杨力 on 26/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Single.h"

typedef void(^ShoppingCarBlock)(NSInteger index);

@interface YLShoppingCarBottom : UIView

@property (nonatomic,strong) UIButton * selectAllBtn;
@property (nonatomic,copy) ShoppingCarBlock block;

+(instancetype)shareCarBottom;
+(void)clickShoppingCar:(ShoppingCarBlock)block;

@end
