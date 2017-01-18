//
//  YLNetObseverManager.m
//  DianZTC
//
//  Created by 杨力 on 17/1/2017.
//  Copyright © 2017 杨力. All rights reserved.
//

#import "YLNetObseverManager.h"

@implementation YLNetObseverManager

static id delegateParam;
static YLNetObseverManager * manager = nil;
+(instancetype)shareInstanceWithDelegate:(id)delegate{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[YLNetObseverManager alloc]init];
        manager.delegate = delegate;
        delegateParam = delegate;
    });
    return manager;
}

-(instancetype)init{
    
    if(self = [super init]){
        
        [self resetDelegate];
    }
    return self;
}

-(void)resetDelegate{
    
    AFNetworkReachabilityManager * manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                [self.delegate batarNetChange:BatarNetChangedUnknow];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [self.delegate batarNetChange:BatarNetNotFound];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [self.delegate batarNetChange:BatarNetChangeWWAN];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [self.delegate batarNetChange:BatarNetChangeWifi];
                break;
            default:
                break;
        }
    }];
}


@end
