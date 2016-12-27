//
//  BatarMainTabBarContoller.m
//  DianZTC
//
//  Created by 杨力 on 21/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "BatarMainTabBarContoller.h"
#import "FirstViewController.h"
#import "DiscoverViewController.h"
#import "BatarSettingController.h"
#import "BatarCarController.h"

@implementation BatarMainTabBarContoller

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self createViewController];
    
    [self createTabBarItem];
}

#pragma mark - 创建tabbar的属性
-(void)createTabBarItem{
    
    //创建3个数组
    NSArray * titleArray = @[@"首页",@"发现",@"购物车",@"我的图鉴"];
    NSArray * unSelectArray = @[@"shouye_nol",@"discover_nol",@"shoppingcar_nor",@"setting_nor"];
    NSArray * selectArray = @[@"shouye_sel",@"discover_sel",@"shoppingcar_sel",@"setting_sel"];
    
    for(int i=0;i<titleArray.count;i++){
        
        //获取item
        UITabBarItem * item = self.tabBar.items[i];
        item = [item initWithTitle:titleArray[i] image:[self createImage:unSelectArray[i]] selectedImage:[self createImage:selectArray[i]]];
    }
    
    //设置item的字体颜色
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:CATAGORYTEXTCOLOR} forState:UIControlStateNormal];
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:TABBARTEXTCOLOR} forState:UIControlStateSelected];
    //设置tabbar的阴影线为隐藏
    UIImage * image = [[UIImage alloc]init];
    [self.tabBar setShadowImage:image];
    
    //设置背景色
//    [self.tabBar setBackgroundImage:[self createImage:@"tabbar_bg.png"]];
}

//路径转化为图片的方法
-(UIImage *)createImage:(NSString *)imageName{
    //生成image
    UIImage * image = [UIImage imageNamed:imageName];
    //处理阴影
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    return image;
}

#pragma mark - 创建界面
-(void)createViewController{
    
    FirstViewController * firstVc = [[FirstViewController alloc]init];
    UINavigationController * firstNvc = [[UINavigationController alloc]initWithRootViewController:firstVc];
    
    DiscoverViewController * discoverVc = [[DiscoverViewController alloc]init];
    UINavigationController * discoverNvc = [[UINavigationController alloc]initWithRootViewController:discoverVc];
    
    BatarCarController * ordersVc = [[BatarCarController alloc]init];
    UINavigationController * ordersNvc = [[UINavigationController alloc]initWithRootViewController:ordersVc];
    
    BatarSettingController * settingVc = [[BatarSettingController alloc]init];
    UINavigationController * settingNvc = [[UINavigationController alloc]initWithRootViewController:settingVc];
    
    self.viewControllers = @[firstNvc,discoverNvc,ordersNvc,settingNvc];
}

@end
