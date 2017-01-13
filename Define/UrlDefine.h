//
//  UrlDefine.h
//  DianZTC
//
//  Created by 杨力 on 14/7/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UrlDefine : NSObject

/*客户登录*/
UIKIT_EXTERN NSString * const LOGIN_URL;

/*轮播图*/
UIKIT_EXTERN NSString * const BANNERURL;

/*首页款类*/
UIKIT_EXTERN NSString * const Batar_TUIJIAN;

/*新款产品*/
UIKIT_EXTERN NSString * const NEWPRODUCT;

/*人气产品*/
UIKIT_EXTERN NSString * const POPULARITY;

/*图片拼接url*/
UIKIT_EXTERN NSString * const BANNERCONNET;

/*轮播图拼接url*/
UIKIT_EXTERN NSString * const NEWBANNERCONNET;

/*点击轮播图url*/
UIKIT_EXTERN NSString * const BANNERCLICKURL;

/*分类搜索界面出现的按钮项目*/
UIKIT_EXTERN NSString * const CATAFGORYITEM;

/*分类搜索界面*/
UIKIT_EXTERN NSString * const CATAGORYURL;

/*分类分组界面跳转到单类界面*/
UIKIT_EXTERN NSString * const CATAGORYPUSHURL;

/*系列界面*/
UIKIT_EXTERN NSString * const SERIZEURL;

/*主题界面*/
UIKIT_EXTERN NSString *const   MERRYURL;

/*推荐界面*/
UIKIT_EXTERN NSString *const  RECOMMENDURL;

/*向服务器发送版本号和id*/
UIKIT_EXTERN NSString *const  Send_VersionToService;

/*上传我的购物车*/
UIKIT_EXTERN NSString *const  UPLOADORDERCAR;

/*上传语音信息*/
UIKIT_EXTERN NSString *const  UPLOADVOICE ;

/*搜索数据*/
UIKIT_EXTERN NSString *const  SEARCHURL;

/*查看我的购物车*/
UIKIT_EXTERN NSString *const   MYORDERCAR ;

/*删除我的购物车*/
UIKIT_EXTERN NSString *const  REMOVECARORDER;

/*确认订单*/
UIKIT_EXTERN NSString *const CONFRIMORDR;

/*查看已经确认的订单*/
UIKIT_EXTERN NSString *const  CHECKORDER;

/*删除最终确认的订单*/
UIKIT_EXTERN NSString *const  DELETEMYORDER;

/*搜索提示*/
UIKIT_EXTERN NSString *const  SEARCHINDICOTOR;

/*分享*/
UIKIT_EXTERN NSString *const ShAREPLATFORMS;

/*首页底部*/
UIKIT_EXTERN NSString * const BOTTOMPIC;

/*首页底部图片*/
UIKIT_EXTERN NSString *const  BOTTOMIMG;

/*获取首页推广信息*/
UIKIT_EXTERN NSString *const TUIGUANGINFO;

/*获取推广的图片*/
UIKIT_EXTERN NSString *const  GETTUIGUANGIMG;

/*请求语音接口*/
UIKIT_EXTERN NSString *const GETVOICEURL;

/*企业版App检测更新链接*/
UIKIT_EXTERN NSString *const PLIST_URL;

/*type=1时,首页推广点击*/
UIKIT_EXTERN NSString *const RECOMMANDCLICK;

/*判断码的类型：精确，模糊，错误码*/
UIKIT_EXTERN NSString * const CODETYPE;

/*首页更多按钮*/
UIKIT_EXTERN NSString * const CLICKMORE;

/*上传收藏夹*/
UIKIT_EXTERN NSString * const AddSaveURL;

/*收藏:获取收藏夹数据*/
UIKIT_EXTERN NSString * const GetSaveURL;

/*收藏:删除收藏夹*/
UIKIT_EXTERN NSString * const DeleteSaveURL;

/*收藏:判断产品是否收藏*/
UIKIT_EXTERN NSString * const WhetherSavedURl;

/*iOS和安卓APP下载地址*/
UIKIT_EXTERN NSString *const ANDARIOD_APPURL;
UIKIT_EXTERN NSString *const IOS_APPURL;

@end
