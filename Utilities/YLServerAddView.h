//
//  YLServerAddView.h
//  DianZTC
//
//  Created by 杨力 on 22/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BatarLoginController.h"
#import "RootViewController.h"

@interface YLServerAddView : UIView

@property (nonatomic,strong) NSArray * serverArray;

-(instancetype)initWithView:(BatarLoginController *)motherVc;
//更新界面
-(void)updateServerView;
//打开选择状态
-(void)getSelectedBtn;
//取消编辑
-(void)cancelEdit;
//开始编辑
-(void)startEdit;
@end
