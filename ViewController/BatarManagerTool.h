//
//  BatarManagerTool.h
//  DianZTC
//
//  Created by 杨力 on 9/3/2017.
//  Copyright © 2017 杨力. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BatarManagerTool : NSObject

/** 计算本地购物车数量，并通知出去 */
+(void)caculateDatabaseOrderCar;

/** 计算服务端购物车数量，并通知出去 */
+(void)caculateServerOrderCar;

@end
