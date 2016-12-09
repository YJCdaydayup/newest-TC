//
//  UrlDefine.h
//  DianZTC
//
//  Created by 杨力 on 14/7/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#ifndef UrlDefine_h
#define UrlDefine_h

/*客户登录*/
#define LOGIN_URL @"http://%@/photo-album/order/user_reg"

/*轮播图*/
#define BANNERURL @"http://%@/photo-album/index/tabimage"

/*新款产品*/
#define NEWPRODUCT @"http://%@/photo-album/index/newProduct"

/*人气产品*/
#define POPULARITY @"http://%@/photo-album/index/popularity"

/*轮播图拼接url*/
#define BANNERCONNET @"http://%@/photo-album/image/"

/*点击轮播图url*/
#define BANNERCLICKURL @"http://%@/photo-album/search/classify/"

/*分类搜索界面出现的按钮项目*/
#define CATAFGORYITEM @"http://%@/photo-album/search/main"

/*分类搜索界面*/
#define CATAGORYURL @"http://%@/photo-album/search/classify?"

/*分类分组界面跳转到单类界面*/
#define CATAGORYPUSHURL @"http://%@/photo-album/search/classifycontext/"

/*系列界面*/
#define SERIZEURL       @"http://%@/photo-album/series/main"

/*主题界面*/
#define MERRYURL        @"http://%@/photo-album/series/subview/"

/*推荐界面*/
#define RECOMMENDURL    @"http://%@/photo-album/search/recommend"

/*向服务器发送版本号和id*/
#define Send_VersionToService  @"http://%@/photo-album/app/updateforios"

/*上传我的购物车*/
#define UPLOADORDERCAR  @"http://%@/photo-album/order/order_shop_add"

/*上传语音信息*/
#define UPLOADVOICE     @"http://%@/photo-album/order/update_voice"

/*搜索数据*/
#define SEARCHURL       @"http://%@/photo-album/product/product_search"

/*查看我的购物车*/
#define MYORDERCAR      @"http://%@/photo-album/order/order_shop_list"

/*删除我的购物车*/
#define REMOVECARORDER  @"http://%@/photo-album/order/order_shop_delete"

/*确认订单*/
#define CONFRIMORDR     @"http://%@/photo-album/order/order_confirm" 

/*查看已经确认的订单*/
#define CHECKORDER      @"http://%@/photo-album/order/order_list" 

/*删除最终确认的订单*/
#define DELETEMYORDER   @"http://%@/photo-album/order/order_delete"

/*搜索提示*/
#define SEARCHINDICOTOR @"http://%@/photo-album/index/autocomplete"

/*分享*/
#define ShAREPLATFORMS  @"http://%@/photo-album/weixin/product_detailed.html#%@"

/*首页底部*/
#define BOTTOMPIC       @"http://%@/photo-album/index/get_botton_bar"

/*首页底部图片*/
#define BOTTOMIMG       @"http://%@/photo-album/index/image_logo/%@"

/*获取首页推广信息*/
#define TUIGUANGINFO    @"http://%@/photo-album/index/generalization"

/*获取推广的图片*/
#define GETTUIGUANGIMG  @"http://%@/photo-album/index/image/"

/*请求语音接口*/
#define GETVOICEURL     @"http://%@/photo-album/order/voice/%@"

/*企业版App检测更新链接*/
#define PLIST_URL       @"https://git.oschina.net/jeffyang/TestInternalDistribute2/raw/master/Info.plist?"

/*iOS和安卓APP下载地址*/
#define ANDARIOD_APPURL @"http://zbtj.batar.cn:8888/photo-album/app/download/newversion"
#define IOS_APPURL      @"http://fir.im/enterpriseUrl"

#endif /* UrlDefine_h */
