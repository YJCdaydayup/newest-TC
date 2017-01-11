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
-(void)updateServerView;
-(void)getSelectedBtn;
-(void)cancelEdit;
-(void)startEdit;
@end
