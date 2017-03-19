//
//  FirstViewController.h
//  DianZTC
//
//  Created by 杨力 on 4/5/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface FirstViewController : RootViewController

-(void)showDetailViewNumber:(NSString *)number;
-(void)showRecommandType:(NSInteger)type param:(NSString *)param;
-(void)showWebViewVc:(NSString *)urlStr;

@end
