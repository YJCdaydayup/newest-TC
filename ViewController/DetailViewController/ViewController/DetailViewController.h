//
//  DetailViewController.h
//  DianZTC
//
//  Created by 杨力 on 7/5/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BatarMainTabBarContoller.h"

@protocol DetailChangeDelegate <NSObject>

-(void)changeRootController;

@end

@interface DetailViewController : RootViewController

+(instancetype)shareDetailController;

@property (nonatomic,assign) id<DetailChangeDelegate>delegate;

@property (nonatomic,copy) NSString * index;
@property (nonatomic,copy) NSString * number;

@property (nonatomic,assign) NSInteger fromSaveVc;
@property (nonatomic,assign) BOOL isFromSearchVc;
@property (nonatomic,assign) BOOL isFromSaveVc;
@property (nonatomic,assign) BOOL isFromThemeVc;

//扫码界面传递参数
@property (nonatomic,copy) NSString * codeType;
@property (nonatomic,copy) NSString * searchType;

-(void)deleteLocalRemark;

@end
