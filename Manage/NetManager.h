//
//  CatagoryManager.h
//  DianZTC
//
//  Created by 杨力 on 19/7/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger{
    CoderTypeAccurateType,//精确的
    CoderTypeInaccurateType,//条形码
    CoderTypeFailCoder,//错误码
}CoderType;

typedef void(^NetBlock)(id responseObject,NSError * error);
typedef void(^CheckIPBlock)(NSString * response, NSError * error);
typedef void(^CoderTypeBlock)(CoderType type);
typedef void(^CacheBlock)(id data);

@interface NetManager : NSObject

@property (nonatomic,copy) NSString * plistPath;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,copy) CheckIPBlock checkBlock;

//保存ip，port键值对
@property (nonatomic,copy) NSString * ip_PortPath;

+(instancetype)shareManager;
-(void)downloadCatagoryData;

//网络请求
-(void)downloadDataWithUrl:(NSString *)url parm:(id)obj callback:(NetBlock)block;
//获取IP和端口组合
-(NSString *)getIPAddress;
//判断IP或者端口是否正确
-(void)checkIPCompareWithIP:(NSString *)ip port:(NSString *)port callback:(CheckIPBlock)block;
//本地保存正确的ip列表
-(void)saveCurrentIP:(NSString *)ip withPort:(NSString *)port;
//如果存在正确的ip，就直接进入主界面
-(BOOL)checkOutIfHasCorrenctIp_port;
//获取最新一组正确的IP地址
-(void)getNewestIp_PortWhenLoginFailed;
//程序启动就向服务器推送版本号
-(void)sendAppVersionToService;
//获取所有的正确的ip
+(NSMutableArray *)batar_getAllServers;
//删除某个服务器
+(void)batar_deleteServerWithIndex:(NSInteger)index;

/*******************搜索历史数据********************/
-(void)saveSearchText:(NSString *)text;
-(NSMutableArray *)getSearchContent;
-(void)cleanHistorySearch;
+(void)judgeCoderWithCode:(NSString *)code Type:(CoderTypeBlock)block;

/*******************启动页广告********************/
-(void)bt_saveAdvertiseInfo;
-(NSData *)bt_getAdvertiseInfo;
-(NSDictionary *)bt_getAdvertiseControlInfo;

/*******************首页数据缓存********************/
//判断是否存在缓存
+(BOOL)bt_exsitTabbarFirstCache:(NSString *)cacheName;
//进行缓存
+(void)bt_beginTabbarFirstCache:(NSString *)cacheName data:(id)data;
//读取缓存
+(void)bt_getTabbarFirstCache:(NSString *)cacheName completion:(CacheBlock)block;
//清空缓存
+(void)bt_removeAllCache;



@end
