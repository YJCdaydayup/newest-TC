//
//  YLVer_UpManager.m
//  DianZTC
//
//  Created by 杨力 on 5/10/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "YLVer_UpManager.h"
#import "NetManager.h"

@implementation YLVer_UpManager

-(void)compareVersionWithPlist:(Picker_CheckUpdatedBlock)block{
    
    NSString * currentAppVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/plain", nil];
    [manager GET:PLIST_URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSLog(@"%@",responseObject);
        NSString * str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSRange range = [str rangeOfString:@">1"];
        NSString * str1 = [str substringWithRange:NSMakeRange(988, 5)];
//        NSLog(@"%@",str1);
        if([str1 isEqualToString:currentAppVersion]){
            block(YES);//当前是最新版本
        }else{
            //提示更新
            block(NO);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error.description);
    }];
}

@end
