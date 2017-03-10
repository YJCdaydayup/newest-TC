//
//  UrlDefine.m
//  DianZTC
//
//  Created by 杨力 on 29/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//
#import "UrlDefine.h"

//NSString const * Batar_TUIJIAN
NSString * const LOGIN_URL     = @"http://%@/photo-album/order/user_reg";

NSString * const Batar_TUIJIAN = @"http://%@/photo-album/index/get_mobile_index";

NSString * const BANNERURL     = @"http://%@/photo-album/index/tabimage";

NSString * const NEWPRODUCT    = @"http://%@/photo-album/index/newProduct";

NSString * const POPULARITY    = @"http://%@/photo-album/index/popularity";

NSString * const BANNERCONNET  = @"http://%@/photo-album/image/";

NSString * const NEWBANNERCONNET = @"http://%@/photo-album/index/image_tab/";

NSString * const BANNERCLICKURL = @"http://%@/photo-album/search/classify/";

NSString * const CATAFGORYITEM = @"http://%@/photo-album/search/main";

NSString * const CATAGORYURL = @"http://%@/photo-album/search/classify?";

NSString * const CATAGORYPUSHURL = @"http://%@/photo-album/search/classifycontext/";

/*系列界面*/
NSString * const SERIZEURL = @"http://%@/photo-album/series/main";

/*主题界面*/
NSString * const MERRYURL  = @"http://%@/photo-album/series/subview/";

/*推荐界面*/
NSString * const RECOMMENDURL = @"http://%@/photo-album/search/recommend";

/*向服务器发送版本号和id*/
NSString * const Send_VersionToService = @"http://%@/photo-album/app/updateforios";

/*上传我的购物车*/
NSString * const UPLOADORDERCAR = @"http://%@/photo-album/order/order_shop_add";

/*上传语音信息*/
NSString * const UPLOADVOICE = @"http://%@/photo-album/order/update_voice";

/*搜索数据*/
NSString * const SEARCHURL = @"http://%@/photo-album/product/product_search";

/*查看我的购物车*/
NSString * const MYORDERCAR = @"http://%@/photo-album/order/order_shop_list";

/*删除我的购物车*/
NSString * const REMOVECARORDER = @"http://%@/photo-album/order/order_shop_delete";

/*确认订单*/
NSString * const CONFRIMORDR = @"http://%@/photo-album/order/order_confirm";

/*查看已经确认的订单*/
NSString * const CHECKORDER = @"http://%@/photo-album/order/order_list";

/*删除最终确认的订单*/
NSString * const DELETEMYORDER = @"http://%@/photo-album/order/app_order_remove";

/*搜索提示*/
NSString * const SEARCHINDICOTOR = @"http://%@/photo-album/index/autocomplete";

/*分享*/
NSString * const ShAREPLATFORMS = @"http://%@/photo-album/weixin/product_detailed.html#%@";

/*首页底部*/
NSString * const BOTTOMPIC = @"http://%@/photo-album/index/get_botton_bar";

/*首页底部图片*/
NSString * const BOTTOMIMG = @"http://%@/photo-album/index/image_logo/%@";

/*获取首页推广信息*/
NSString * const TUIGUANGINFO = @"http://%@/photo-album/index/generalization";

/*获取推广的图片*/
NSString * const GETTUIGUANGIMG = @"http://%@/photo-album/index/image/";

/*请求语音接口*/
NSString * const GETVOICEURL = @"http://%@/photo-album/order/voice/%@";

/*企业版App检测更新链接*/
NSString * const PLIST_URL = @"https://git.oschina.net/jeffyang/TestInternalDistribute2/raw/master/Info.plist?";

/*type=1时,首页推广点击*/
NSString * const RECOMMANDCLICK = @"http://%@/photo-album/product/get_series_product";

/*判断码的类型：精确，模糊，错误码*/
NSString * const CODETYPE = @"http://%@/photo-album/index/_autocomplete";

/*首页更多按钮*/
NSString * const CLICKMORE = @"http://%@/photo-album/index/getmore";

/*上传收藏夹*/
NSString * const AddSaveURL = @"http://%@/photo-album/favorite/add";

/*收藏:获取收藏夹数据*/
NSString * const GetSaveURL = @"http://%@/photo-album/favorite/getall";

/*收藏:删除收藏夹*/
NSString * const DeleteSaveURL = @"http://%@/photo-album/favorite/del";

/*收藏:判断产品是否收藏*/
NSString * const WhetherSavedURl = @"http://%@/photo-album/favorite/isfavorite";

/*启动广告页参数*/
NSString * const AdvertiseUrl = @"http://%@/photo-album/startup/get_startup";

/*启动广告页图片*/
NSString * const startImg = @"http://%@/photo-album/startup/image/%@";

NSString * const OrderDetailUrl = @"http://%@/photo-album/order_manger/get_details?";

/*确认订单&&取消订单*/
NSString * const ChangeOrderState = @"http://%@/photo-album/order/order_state_change";

NSString * const ConnectWithServer = @"ws://%@/photo-album/order_mobile_message";

/*iOS和安卓APP下载地址*/
NSString * const ANDARIOD_APPURL = @"http://zbtj.batar.cn:8888/photo-album/app/download/newversion";
NSString * const IOS_APPURL = @"http://fir.im/enterpriseUrl";
