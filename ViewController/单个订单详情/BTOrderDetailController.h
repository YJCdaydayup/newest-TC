//
//  BTOrderDetailController.h
//  DianZTC
//
//  Created by 杨力 on 20/2/2017.
//  Copyright © 2017 杨力. All rights reserved.
//

#import "RootViewController.h"

@interface BTOrderDetailController : RootViewController

/** 订单id */
@property (nonatomic,copy) NSString * orderId;
/** 日期 */
@property (nonatomic,copy) NSString * date;
/** 状态 */
@property (nonatomic,strong) NSNumber * state;

/** 传递给单个详情 */
@property (nonatomic,strong) NSMutableArray * modelArray;

@end
