//
//  RootViewController.h
//  DianZTC
//
//  Created by 杨力 on 23/7/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "UIViewController+Extension.h"
#import "YLProgressHUD.h"

@interface RootViewController : UIViewController{
    
    UIButton * _leftNavBtn;
    UIButton * _rightNavBtn;
}

@property (nonatomic,strong) AppDelegate * app;
@property (nonatomic,strong) MBProgressHUD * hud;
@property (nonatomic,strong) YLProgressHUD * ylHud;
@property (nonatomic,strong) RootViewController * fatherVc;

-(instancetype)initWithController:(id)Vc;

-(void)createView;

//导航条
-(void)batar_setNavibar:(NSString *)title;

//导航按钮
-(void)batar_setLeftNavButton:(NSArray *)imgArray target:(id)target selector:(SEL)leftSel size:(CGSize)leftSize selector:(SEL)rightSel rightSize:(CGSize)rightSize topHeight:(CGFloat)height;

//获取placeHolder图片
-(NSString *)captureLocalImage:(NSString *)imageName withType:(NSString *)imageType;

//将字典转化成json字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic;

//将数组转json字符串
-(NSString *)arrayToJson:(NSMutableArray *)array;

//将json字符串转字典
-(NSMutableDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

//数组转json
- (NSString*)myArrayToJson:(NSMutableArray *)array;

//计算文本高度
-(CGFloat)getDescriptionHeight:(NSString *)text;

//弹出提示
-(void)showAlertViewWithTitle:(NSString *)title;

//删除已经push过的某个界面
-(void)removeNaviPushedController:(id)controller;

//获取当前日期时间
-(NSString *)getCurrentDate;

//时间监测购物车数量
-(void)makeNotification;

//计算文本宽度
-(CGFloat)getDescriptionWidth:(NSString *)text font:(CGFloat)size height:(CGFloat)height;

@end
