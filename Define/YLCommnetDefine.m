//
//  YLCommnetDefine.m
//  DianZTC
//
//  Created by 杨力 on 7/1/2017.
//  Copyright © 2017 杨力. All rights reserved.
//

#import "YLCommnetDefine.h"

@implementation YLCommnetDefine

NSString * const CodeTypeAccurary = @"CodeTypeAccurary";     //精确
NSString * const CodeTypeInaccurary = @"CodeTypeInaccurary"; //模糊
NSString * const CodeTypeFail = @"CodeTypeFail";             //错误查找

NSString * const CodeTypeQRCode = @"CodeTypeQRCode";         //二维码
NSString * const CodeTypeBarCode = @"CodeTypeBarCode";       //条形码
NSString * const CodeTypeFailCode = @"CodeTypeFailCode";     //错误码

NSString * const BatarEntrance = @"BatarEntrance";      //登录入口

NSString * const CustomerID = @"CustomerID";            //客户编号

NSString * const AddShoppingCar = @"AddShoppingCar";    //加入购物车

NSString * const UploadOrders = @"UploadOrders";        //上传订单

NSString * const SwitchSerser = @"SwitchSerser";        //切换服务器发出通知

NSString * const RECORDPATH = @"recordPath";            //根据产品ID保存发送消息

NSString * const SaveOrNotSave = @"SaveOrNotSave";      //收藏或者取消收藏发出通知

NSString * const DeleteServer = @"DeleteAllServer";  //删除所有服务器

NSString * const ServerEditNotification = @"ServerEditNotification"; //开始编辑发出通知

NSString * const ServerEditCancelNotification = @"ServerEditCancelNotification";

NSString * const SaveCellEditNotification = @"SaveCellEditNotification";

NSString * const SaveCellCancelEditNotification = @"SaveCellCancelEditNotification";

NSString * const SaveCellDeleteNotification = @"SaveCellDeleteNotification";


@end
