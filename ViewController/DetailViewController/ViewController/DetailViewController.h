//
//  DetailViewController.h
//  DianZTC
//
//  Created by 杨力 on 7/5/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : RootViewController

@property (nonatomic,copy) NSString * index;
@property (nonatomic,copy) NSString * number;

@property (nonatomic,assign) NSInteger fromSaveVc;
@property (nonatomic,assign) BOOL isFromSearchVc;
@property (nonatomic,assign) BOOL isFromSaveVc;
@property (nonatomic,assign) BOOL isFromThemeVc;
@end
