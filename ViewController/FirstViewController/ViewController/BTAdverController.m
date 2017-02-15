//
//  BTAdverController.m
//  DianZTC
//
//  Created by 杨力 on 15/2/2017.
//  Copyright © 2017 杨力. All rights reserved.
//

#import "BTAdverController.h"
#import "NetManager.h"
#import "AppDelegate.h"
#import "BatarMainTabBarContoller.h"

@interface BTAdverController ()

@property (nonatomic,strong) UIImageView * bgImgView;

@end

@implementation BTAdverController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bgImgView = [[UIImageView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.bgImgView];
    
    NetManager * manager = [NetManager shareManager];
    self.bgImgView.image = [UIImage imageWithData:[manager bt_getAdvertiseInfo]];
    
    NSDictionary * info = [manager bt_getAdvertiseControlInfo];
    CGFloat showTime = [info[@"showtime"]floatValue];
    [self performSelector:@selector(changeMode) withObject:nil afterDelay:showTime];
}

-(void)changeMode{
    
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    BatarMainTabBarContoller * tabbar = [[BatarMainTabBarContoller alloc]init];
    app.window.rootViewController = tabbar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
