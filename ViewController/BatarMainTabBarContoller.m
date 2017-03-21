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
#import "DetailViewController.h"
#import "MyOrdersController.h"
#import "BatarBadgeView.h"
#import "AppDelegate.h"
#import "BatarTabbar.h"
#import "BatarManagerTool.h"

@interface BatarMainTabBarContoller()<DetailChangeDelegate,MyOrdersDelegate>
/** 数量显示 */
@property (nonatomic,strong) BatarBadgeView *badgeView;
@property (nonatomic,strong) BatarTabbar * tabBar;
@property (nonatomic,strong) UIView * mySettingBadge;

@end

static UINavigationController * _carVc;

@implementation BatarMainTabBarContoller

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

singleM(tabbarController)

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeBadgeValue:) name:ShopCarNumberNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeMeBadge) name:ServerMsgNotification object:nil];
    
    [self setValue:[BatarTabbar shareBatarTabbar] forKeyPath:@"tabBar"];
    [self.tabBar addSubview:self.mySettingBadge];
    
    [self createViewController];
    [self createTabBarItem];
}

#pragma "我的图鉴"角标
-(void)changeMeBadge{
    
    if([SocketModel.state_1 integerValue]>0){
        self.mySettingBadge.hidden = NO;
    }else{
        self.mySettingBadge.hidden = YES;
    }
}

-(void)changeBadgeValue:(NSNotification *)notice{
    
    //tabbar
    [self.badgeView changeBadgeValue:[NSString stringWithFormat:@"%@",notice.object]];
}

-(void)changeRootController{
    
    self.selectedIndex = 0;
}

-(void)changeRootController:(NSInteger)index{
    
    self.selectedIndex = index;
}

#pragma mark - 创建tabbar的属性
-(void)createTabBarItem{
    
    //创建3个数组
    NSArray * titleArray = @[@"首页",@"发现",@"购物车",@"我的图鉴"];
    NSArray * unSelectArray = @[@"shouye_nol",@"discover_nol",@"shoppingcar_nor",@"setting_nor"];
    NSArray * selectArray = @[@"shouye_sel",@"discover_sel",@"tabbar_car",@"setting_sel"];
    
    for(int i=0;i<titleArray.count;i++){
        
        //创建自动释放池
        @autoreleasepool {
            //获取item
            UITabBarItem * item = self.tabBar.items[i];
            item = [item initWithTitle:titleArray[i] image:[self createImage:unSelectArray[i]] selectedImage:[self createImage:selectArray[i]]];
        }
    }
    
    //设置item的字体颜色
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:CATAGORYTEXTCOLOR} forState:UIControlStateNormal];
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:TABBARTEXTCOLOR} forState:UIControlStateSelected];
    //设置tabbar的阴影线为隐藏
    UIImage * image = [[UIImage alloc]init];
    [self.tabBar setShadowImage:image];
    
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

-(BatarBadgeView *)badgeView{
    
    if(!_badgeView){
        _badgeView= [[BatarBadgeView alloc]initWithFrame:CGRectMake(Wscreen*3/4.0-40*S6,3*S6,200,20)];
        [self setValue:[BatarTabbar shareBatarTabbar] forKeyPath:@"tabBar"];
        [self.tabBar addSubview:self.badgeView];
    }
    return _badgeView;
}

-(UIView *)mySettingBadge{
    
    if(!_mySettingBadge){
        
        _mySettingBadge = [[UIView alloc]initWithFrame:CGRectMake(Wscreen*3/4.0+50*S6,6*S6,8*S6,8*S6)];
        _mySettingBadge.backgroundColor = [UIColor redColor];
        _mySettingBadge.layer.cornerRadius = 4*S6;
        _mySettingBadge.layer.masksToBounds = YES;
        [self setValue:[BatarTabbar shareBatarTabbar] forKeyPath:@"tabBar"];
        [self.tabBar addSubview:self.badgeView];
        _mySettingBadge.hidden = YES;
    }
    return _mySettingBadge;
}

@end
