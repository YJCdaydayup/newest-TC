//
//  BatarSocketModel.h
//  DianZTC
//
//  Created by 杨力 on 10/3/2017.
//  Copyright © 2017 杨力. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Single.h"

@interface BatarSocketModel : NSObject

singleH(BatarSocketModel);

/** 所有订单 */
@property (nonatomic,strong) NSNumber * all;

/** 待明细 */
@property (nonatomic,strong) NSNumber * state_0;

/** 待确认 */
@property (nonatomic,strong) NSNumber * state_1;

/** 已确认 */
@property (nonatomic,strong) NSNumber * state_2;

@end
