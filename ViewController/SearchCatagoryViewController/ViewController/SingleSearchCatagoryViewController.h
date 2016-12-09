//
//  SingleSearchCatagoryViewController.h
//  DianZTC
//
//  Created by 杨力 on 6/5/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleSearchCatagoryViewController : RootViewController

//参数
@property (nonatomic,strong) NSMutableDictionary * parmDict;
//选择的一个按钮
@property (nonatomic,copy) NSString * catagoryItem;

//判断是否是从多个按钮点击后的界面跳转过来
@property (nonatomic,assign) NSInteger vc_flag;
@property (nonatomic,copy) NSString * catagoryIndex;


@end
