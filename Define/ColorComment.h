//
//  ColorComment.h
//  DianZTC
//
//  Created by 杨力 on 5/5/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#ifndef ColorComment_h
#define ColorComment_h

//主题颜色
#define THEMECOLOR RGB_COLOR(76, 66, 41, 1)

//Logo处的文字颜色
#define LOGOTEXTCOLOR RGB_COLOR(94, 94, 94, 1)

//导航条的颜色
#define NAVICOLOR RGB_COLOR(165, 129, 68, 1)

//首页表格的背景颜色
#define TABLEVIEWCOLOR RGB_COLOR(241, 241, 241, 1)

//cell的背景颜色
#define CELLBGCOLOR RGB_COLOR(238, 238, 238, 1)

//首页“新款产品”文字的底片View颜色
#define IMAGETILIECOLOR RGB_COLOR(165, 129, 68, 1)

//按钮的边框颜色
#define BTNBORDCOLOR RGB_COLOR(221, 221, 221, 1)

//主题界面按钮点击颜色
#define THEMEBTNSELECTCOLOR RGB_COLOR(135, 85, 49, 1)

//文字颜色
#define TEXTCOLOR RGB_COLOR(51, 51, 51, 1)
#define CATAGORYTEXTCOLOR RGB_COLOR(102, 102, 102, 1)

//描边颜色
#define BOARDCOLOR  RGB_COLOR(204, 204, 204, 1)

//持久化NSUserDefault
#define kUserDefaults [NSUserDefaults standardUserDefaults]

//注销按钮颜色
#define LOGOUTBTNCOLOR RGB_COLOR(220, 119, 40, 1)

//资源下载路径
#define LIBPATH [NSString stringWithFormat:@"%@/",[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject]]

#define CustomerID                @"customerid"                     //客户编号

#define BANNERPLACEHOLDER @"banner_placeHolder@2x.jpg"
#define PLACEHOLDER @"placeHolder.jpg"
#define PLACETYPE @"jpg"                                            //图片的默认填充
#define FROMFLAG @"FROMFLAG"                                        //多个按钮界面跳转到下一级
#define BUTTONWIDTH 82.5
#define BUTTONHEIGHT 35                                             //分类搜索界面按钮间距
#define PAGECONTROLALPHA 0.7f                                       //pageControl的透明度
#define IPSTRING @"IPSTRING"                                        //地址ip
#define PORTSTRING @"PORTSTRING"                                    //端口port
#define ISLOGIN @"ISLOGIN"
#define LOGINFAILED @"loginfailed"                                  //登录失败
#define SHOWMENUE @"showmenue"                            //判断是否显示系列界面的“系列”和“分类”
#define ALLDETAILCACHE @"allDetailCache"                  //所有的详情界面数据缓存文件夹
#define SHOWSAVEBUTTON @"showsaveselectedbutton"          //收藏界面判断是否显示出编辑按钮
#define SAVEFILEEXIST @"SAVEFILEEXIST"                              //判断收藏夹是否有数据
#define THUMBNAILRATE 10                                             //缩略图清晰度比例
#define GETSTRING(parma) [NSString stringWithFormat:@"%zi",parma]   //将数字转化成字符串
#define IFLY_KEY @"580d9fea"                                        //讯飞语音APPKEY
#define RECORDPATH @"recordPath"                           //根据产品ID保存发送消息
#define FROMORDERVC @"fromOrderVc"                         //从订购单界面跳转过来
#define PRODUCTNUMBER @"productNumber"                     //全程的产品名
#define SAVE_PUSH_FLAG  @"save_push_flag"                  //解决收藏与详情页的混乱的跳转逻辑
#define LONG_PRODUCT_ID @"long_product_id"                 //记录长的那个产品ID
#define FROM_VC_TO_SAVE @"from_vc_to_save"                 //从哪个界面跳到收藏页
#define TEMP_FROM_VC_TO_SAVE @"temp_from_vc"               //临时接收赋值

#endif /* ColorComment_h */
