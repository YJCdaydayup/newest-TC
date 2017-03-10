//
//  BatarMainTabBarContoller.h
//  DianZTC
//
//  Created by 杨力 on 21/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Single.h"

@interface BatarMainTabBarContoller : UITabBarController

singleH(tabbarController)
-(void)changeRootController;
-(void)changeBadgeValue:(NSString *)number;
@end
