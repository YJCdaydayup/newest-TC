//
//  BatarCarController.h
//  DianZTC
//
//  Created by 杨力 on 26/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "RootViewController.h"
#import "BatarMainTabBarContoller.h"

@protocol BatarCarDelegate <NSObject>

-(void)changeRootController;

@end

@interface BatarCarController : RootViewController

@property (nonatomic,assign) id<BatarCarDelegate>delegate;

@end
