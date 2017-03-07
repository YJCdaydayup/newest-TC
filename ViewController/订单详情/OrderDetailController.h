//
//  OrderDetailController.h
//  DianZTC
//
//  Created by 杨力 on 22/11/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "RootViewController.h"

@interface OrderDetailController : RootViewController

@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,copy) NSString * img;
@property (nonatomic,copy)   NSString * number;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * createTime;

@end
