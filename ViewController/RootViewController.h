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


@interface RootViewController : UIViewController

@property (nonatomic,strong) MBProgressHUD * hud;
@property (nonatomic,strong) YLProgressHUD * ylHud;

//获取placeHolder图片
-(NSString *)captureLocalImage:(NSString *)imageName withType:(NSString *)imageType;

//将字典转化成json字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic;

//将数组转json字符串
-(NSString *)arrayToJson:(NSMutableArray *)array;

//数组转json
- (NSString*)myArrayToJson:(NSMutableArray *)array;

//计算文本高度
-(CGFloat)getDescriptionHeight:(NSString *)text;

//弹出提示
-(void)showAlertViewWithTitle:(NSString *)title;

@end
