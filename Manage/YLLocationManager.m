

//
//  LocationManager.m
//  退出
//
//  Created by 杨力 on 17/11/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "YLLocationManager.h"
#import "WebViewController.h"
#import <MapKit/MapKit.h>
#import "AppDelegate.h"

@implementation YLLocationManager

-(instancetype)initShareLocationManager:(NSString *)address ViewController:(UIViewController *)vc{
    
    if(self = [super init]){
        
        self.address = address;
        self.vc = vc;
    }
    
    return self;
}

-(void)createLocationManager{
    
    self.geocoder = [[CLGeocoder alloc]init];
    
    NSLog(@"%@",self.address);
    __block typeof(self)weakSelf = self;
    [self.geocoder geocodeAddressString:self.address completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if(error == nil){
            
            CLPlacemark *firstPlacemark = placemarks.lastObject;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf actionSheetWith:firstPlacemark.location.coordinate];
//                NSLog(@"%zi",placemarks.count);
            });
        }else{
            
            NSLog(@"%@",error.description);
        }
    }];
}

-(void)actionSheetWith:(CLLocationCoordinate2D)coordinates{
    
    self.urlScheme = @"demoURI://";
    self.appName = @"demoURI";
    __block NSString *urlScheme = self.urlScheme;
    __block NSString *appName = self.appName;
    __block CLLocationCoordinate2D coordinate = coordinates;
    
    UIAlertController *alert;
    
    if([self.bottomDict[@"isopen"]boolValue]== YES){
        alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    }
    if([self.bottomDict[@"isurl"]boolValue]==YES){
        UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"进入公司首页" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSString * url = self.bottomDict[@"url"];
            WebViewController * webView = [[WebViewController alloc]init];
            UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:webView];
            if([url containsString:@"http"]){
                webView.urlString = url;
            }else{
                webView.urlString = [NSString stringWithFormat:@"http://%@",self.bottomDict[@"url"]];
            }
            [self.vc.navigationController presentViewController:nvc animated:YES completion:nil];
        }];
        [alert addAction:action1];
    }
    
    if([self.bottomDict[@"istel"]boolValue]==YES){
        
        UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"拨打公司电话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIWebView*callWebview =[[UIWebView alloc] init];
            NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.bottomDict[@"tel"]]];
            [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
            [self.vc.view addSubview:callWebview];
        }];
        [alert addAction:action2];
    }
    
    //NSLog(@"%@",[self.bottomDict[@"isaddress"] class]);
    if([self.bottomDict[@"isaddress"] boolValue]==YES){
        
        //这个判断其实是不需要的
        if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://maps.apple.com/"]])
        {
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"苹果地图导航" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
                MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil]];
                
                [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                               launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
            }];
            
            [action setValue:THEMECOLOR forKey:@"titleTextColor"];
            [alert addAction:action];
        }
        
        
        if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]])
        {
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"百度地图导航" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%.2f,%.2f|name=目的地&mode=driving&coord_type=gcj02",coordinate.latitude, coordinate.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                
                NSLog(@"%@",urlString);
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            }];
            [action setValue:THEMECOLOR forKey:@"titleTextColor"];
            [alert addAction:action];
        }
        
        if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]])
        {
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"高德地图导航" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",appName,urlScheme,coordinate.latitude, coordinate.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                
                //            NSLog(@"%@",urlString);
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            }];
            [action setValue:THEMECOLOR forKey:@"titleTextColor"];
            [alert addAction:action];
        }
        
        if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]])
        {
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"谷歌地图导航" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",appName,urlScheme,coordinate.latitude, coordinate.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                
                //            NSLog(@"%@",urlString);
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            }];
            [action setValue:THEMECOLOR forKey:@"titleTextColor"];
            [alert addAction:action];
        }
        
        if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]])
        {
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"腾讯地图导航" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&fromcoord={{我的位置}}&tocoord=%f,%f&policy=1",coordinate.latitude, coordinate.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            }];
            [action setValue:THEMECOLOR forKey:@"titleTextColor"];
            [alert addAction:action];
        }
    }
    
//    NSLog(@"%@",self.bottomDict);
    
    if([self.bottomDict[@"isopen"]boolValue] == YES&&([self.bottomDict[@"isurl"] boolValue]==YES||[self.bottomDict[@"istel"] boolValue]==YES||[self.bottomDict[@"isaddress"] boolValue]==YES)){
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        
        [self.vc presentViewController:alert animated:YES completion:^{
            
        }];
    }
}

-(NSMutableArray *)getSystemMaps{
    
    mapArrays = [[NSMutableArray alloc]init];
    //这个判断其实是不需要的
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://maps.apple.com/"]])
    {
        [mapArrays addObject:@"苹果地图导航"];
    }
    
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]])
    {
        [mapArrays addObject:@"百度地图导航"];
    }
    
    
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]])
    {
        [mapArrays addObject:@"高德地图导航"];
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]])
    {
        [mapArrays addObject:@"谷歌地图导航"];
    }
    
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]])
    {
        [mapArrays addObject:@"腾讯地图导航"];
    }
    
    return mapArrays;
}

@end
