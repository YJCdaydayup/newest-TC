//
//  AppDelegate.m
//  DianZTC
//
//  Created by 杨力 on 4/5/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "AppDelegate.h"
#import "BatarSettingController.h"
#import "DBWorkerManager.h"
#import "YLVer_UpManager.h"
#import "NetManager.h"
#import "YLLoginView.h"
#import "BatarMainTabBarContoller.h"
#import "BatarLoginController.h"
#import "YLUploadToServer.h"
//#import <IOKitFramework.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [kUserDefaults removeObjectForKey:CustomerID];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(uploadDataToServer) name:CustomerID object:nil];
    //SDImageCache默认是利用NSCache存储资源，也就是利用内存。设置不使用内存就行
    //    [[SDImageCache sharedImageCache] setShouldCacheImagesInMemory:NO];
    /**
     * Decompressing images that are downloaded and cached can improve performance but can consume lot of memory.
     * Defaults to YES. Set this to NO if you are experiencing a crash due to excessive memory consumption.
     */
    //    [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
    //    [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    
    //检测版本更新
    [self checkUpdated];
    //上传app版本
    NetManager * manager = [NetManager shareManager];
    [manager sendAppVersionToService];
    // 启动图片延时: 1秒
    [NSThread sleepForTimeInterval:1];
    
    [[UINavigationBar appearance]setFrame:CGRectMake(0, 20, self.window.width, 100)];
    [[UINavigationBar appearance]setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:TEXTCOLOR,NSFontAttributeName:[UIFont systemFontOfSize:17*S6]}];
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    if([kUserDefaults objectForKey:BatarEntrance]){
        
        BatarMainTabBarContoller * mainVc = [[BatarMainTabBarContoller alloc]init];
        self.window.rootViewController = mainVc;
        [self.window makeKeyAndVisible];
    }else{
        
        BatarLoginController * loginVc = [[BatarLoginController alloc]init];
        self.window.rootViewController = loginVc;
    }
    
    return YES;
}

-(void)checkUpdated{
    
    YLVer_UpManager * manager = [[YLVer_UpManager alloc]init];
    [manager compareVersionWithPlist:^(BOOL isupdated) {
        NSString * alertStr;
        UIAlertAction * action1;
        UIAlertAction * action2;
        if(isupdated){
            alertStr = @"当前为最新版本";
        }else{
            alertStr = @"检测到新版本";
            action1 = [UIAlertAction actionWithTitle:@"暂不更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            action2 = [UIAlertAction actionWithTitle:@"现在去更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:IOS_APPURL]];
            }];
        }
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示:" message:alertStr preferredStyle:UIAlertControllerStyleAlert];
        if(isupdated){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertController dismissViewControllerAnimated:YES completion:nil];
            });
        }else{
            [alertController addAction:action1];
            [alertController addAction:action2];
            [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

-(void)uploadDataToServer{
    
    NSLog(@"开始上传");
   YLUploadToServer * uploadManager = [YLUploadToServer shareUploadToServer];
    [uploadManager batar_start];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    //1.取消当前任务
    [[SDWebImageManager sharedManager]cancelAll];
    
    //2.清空缓存
    //    [[SDWebImageManager sharedManager].imageCache clearDisk];
    [[SDWebImageManager sharedManager].imageCache cleanDisk];
    //    [[SDImageCache sharedImageCache]cleanDisk];
    //    [[SDImageCache sharedImageCache]clearMemory];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //    NSURL *url = [NSURL URLWithString:@"prefs:root=General&path=ManagedConfigurationList"];
    //    if ([[UIApplication sharedApplication] canOpenURL:url])
    //    {
    //        [[UIApplication sharedApplication] openURL:url];
    //    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

@end
