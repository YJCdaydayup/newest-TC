//
//  YLCommnetDefine.h
//  DianZTC
//
//  Created by 杨力 on 7/1/2017.
//  Copyright © 2017 杨力. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLCommnetDefine : NSObject

/*查找类型*/
UIKIT_EXTERN NSString * const CodeTypeAccurary;   //精确码
UIKIT_EXTERN NSString * const CodeTypeInaccurary; //模糊码
UIKIT_EXTERN NSString * const CodeTypeFail;       //错误查找

/*码的类型*/
UIKIT_EXTERN NSString * const CodeTypeQRCode;     //二维码
UIKIT_EXTERN NSString * const CodeTypeBarCode;    //条形码
UIKIT_EXTERN NSString * const CodeTypeFailCode;   //错误码

/*改变登录入口*/
UIKIT_EXTERN NSString * const BatarEntrance;      //登录入口

/*客户编号*/
UIKIT_EXTERN NSString * const CustomerID;         //客户编号

/*加入购物车即发出通知*/
UIKIT_EXTERN NSString * const AddShoppingCar;     //加入购物车，通知刷新购物车界面

/*开始上传订单的通知和收藏夹*/
UIKIT_EXTERN NSString * const UploadOrders;       //上传订单

/*切换服务器发出通知*/
UIKIT_EXTERN NSString * const SwitchSerser;      //切换服务器发出通知



@end
