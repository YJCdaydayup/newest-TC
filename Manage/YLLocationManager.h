//
//  LocationManager.h
//  退出
//
//  Created by 杨力 on 17/11/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface YLLocationManager : NSObject<CLLocationManagerDelegate>{
    CLLocationManager * _locationManager;
    NSMutableArray * mapArrays;
}

@property (nonatomic, strong) NSString *urlScheme;
@property (nonatomic, strong) NSString *appName;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString * address;
@property (nonatomic,strong)  CLGeocoder * geocoder;
@property (nonatomic,strong) UIViewController * vc;
@property (nonatomic,strong) NSDictionary * bottomDict;

-(instancetype)initShareLocationManager:(NSString *)address ViewController:(UIViewController *)vc;
-(void)createLocationManager;

@end
