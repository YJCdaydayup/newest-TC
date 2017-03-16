//
//  BatarManagerTool.m
//  DianZTC
//
//  Created by 杨力 on 9/3/2017.
//  Copyright © 2017 杨力. All rights reserved.
//

#import "BatarManagerTool.h"
#import "DBWorkerManager.h"
#import "NetManager.h"
#import "BatarMainTabBarContoller.h"

@implementation BatarManagerTool

+(void)caculateDatabaseOrderCar{
    
    DBWorkerManager * manager = [DBWorkerManager shareDBManager];
    [manager createOrderDB];
    [manager order_getAllObject:^(NSMutableArray *dataArray) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:ShopCarNumberNotification object:@(dataArray.count)];
    }];
}

+(void)caculateServerOrderCar{
    
    //服务器获取数据
    NSMutableArray *dataArray = [NSMutableArray array];
    [dataArray removeAllObjects];
    NetManager * manager = [NetManager shareManager];
    NSString * urlStr = [NSString stringWithFormat:MYORDERCAR,[manager getIPAddress]];
    NSDictionary * dict = @{@"customerid":CUSTOMERID};
    [manager downloadDataWithUrl:urlStr parm:dict callback:^(id responseObject, NSError *error) {
        if(responseObject){
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            id objs = dict[@"products"];
            if([dict isKindOfClass:[NSArray class]]){
                return ;
            }
            if([objs isKindOfClass:[NSNull class]]){
                [dataArray removeAllObjects];
            }else{
                NSMutableArray * modelArray = dict[@"products"];
                NSMutableArray * tempArray = [[NSMutableArray alloc]init];
                for(NSDictionary * dict in modelArray){
                    DBSaveModel * model = [[DBSaveModel alloc]init];
                    model.name = dict[@"name"];
                    model.number = dict[@"number"];
                    model.image = dict[@"image"];
                    [tempArray addObject:model];
                }
                [dataArray addObjectsFromArray:tempArray];
            }
                 [[NSNotificationCenter defaultCenter]postNotificationName:ShopCarNumberNotification object:@(dataArray.count)];
        }else{
            NSLog(@"%@",error.description);
        }
    }];
}

@end
