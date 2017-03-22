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

/** 首页数据缓存 */
/*轮播缓存*/
UIKIT_EXTERN NSString * const BannerCache;

/*推广缓存*/
UIKIT_EXTERN NSString * const RecommandCache;

/*推荐产品缓存*/
UIKIT_EXTERN NSString * const RecommandProductCache;

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

/*根据产品ID保存发送消息*/
UIKIT_EXTERN NSString * const RECORDPATH;        //根据产品ID保存发送消息

/*收藏或者取消收藏发出通知*/
UIKIT_EXTERN NSString * const SaveOrNotSave;      //收藏或者取消收藏发出通知

/*当没有服务器时，发出通知*/
UIKIT_EXTERN NSString * const DeleteServer;    //删除所有服务器

/*进入服务器编辑状态的通知*/
UIKIT_EXTERN NSString * const ServerEditNotification;

/*取消服务器编辑模式*/
UIKIT_EXTERN NSString * const ServerEditCancelNotification;

/*进入收藏夹编辑模式*/
UIKIT_EXTERN NSString * const SaveCellEditNotification;

/*取消收藏夹编辑模式*/
UIKIT_EXTERN NSString * const SaveCellCancelEditNotification;

/*删除收藏夹成功后，通知详情界面*/
UIKIT_EXTERN NSString * const SaveCellDeleteNotification;

//取消订单发出通知
UIKIT_EXTERN NSString * const CancelOrderNotification;

//确认订单发出通知
UIKIT_EXTERN NSString *const ConfirmOrderNotification;

//我的订单刷新的通知
UIKIT_EXTERN NSString *const UpdateMyOrderNotification;

//将购物车角标的数量通知出去
UIKIT_EXTERN NSString *const ShopCarNumberNotification;

//收到服务端的信息，就发出改变角标的通知
UIKIT_EXTERN NSString *const ServerMsgNotification;

//确认加入购物车后，发出通知删除本地
UIKIT_EXTERN NSString *const ConfirmAddCarNotification;


@end
