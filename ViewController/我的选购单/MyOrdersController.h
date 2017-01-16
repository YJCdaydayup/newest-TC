//
//  MyOrdersController.h
//  DianZTC
//
//  Created by 杨力 on 1/11/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "RootViewController.h"

@protocol MyOrdersDelegate <NSObject>

-(void)changeRootController;

@end

@interface MyOrdersController : RootViewController

@property (nonatomic,assign) id<MyOrdersDelegate>delegate;
@property (nonatomic,copy) NSString * productNumber;

@end
