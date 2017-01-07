
//
//  CatagoryManager.m
//  DianZTC
//
//  Created by 杨力 on 19/7/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "NetManager.h"
//#import <IOKit/>

@interface NetManager()<NSURLConnectionDataDelegate,NSURLConnectionDelegate>{
    
    NSURLConnection * connection;
}

@property (nonatomic,copy) NSString * history_search_content;

@end


@implementation NetManager

+(instancetype)shareManager{
    
    static NetManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[NetManager alloc]init];
    });
    
    return manager;
}

-(instancetype)init{
    
    if(self = [super init]){
        
        //读取本地的plist文件
        self.plistPath = [NSString stringWithFormat:@"%@catagory.plist",LIBPATH];
        
        //缓存IP PORT
        self.ip_PortPath = [NSString stringWithFormat:@"%@ip_port.plist",LIBPATH];
        
        /*搜索历史*/
        self.history_search_content = [NSString stringWithFormat:@"%@history_search",LIBPATH];
        
        self.dataArray = [NSMutableArray arrayWithContentsOfFile:self.plistPath];
        if(self.dataArray == nil){
            self.dataArray = [NSMutableArray arrayWithCapacity:0];
        }
    }
    return self;
}

-(void)downloadCatagoryData{
    
    //写入数据
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    NSString * URLstring = [NSString stringWithFormat:CATAFGORYITEM,[self getIPAddress]];
    [manager GET:URLstring parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if(responseObject){
            
            //清空数据
            [self.dataArray removeAllObjects];
            NSFileManager *fm = [NSFileManager defaultManager];
            [fm removeItemAtPath:self.plistPath error:nil];
            
            //添加数据
            NSMutableDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray * array1 = [dict objectForKey:@"category"];
            NSArray * array2 = [dict objectForKey:@"craft"];
            NSArray * array3 = [dict objectForKey:@"material"];
            NSArray * array4 = [dict objectForKey:@"shapes"];
            NSArray * array5 = [dict objectForKey:@"weight"];
            
            [self.dataArray addObject:array1];
            [self.dataArray addObject:array2];
            [self.dataArray addObject:array3];
            [self.dataArray addObject:array4];
            [self.dataArray addObject:array5];
            
            [self.dataArray writeToFile:self.plistPath atomically:YES];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        NSLog(@"%@",error.description);
    }];
}

-(void)downloadDataWithUrl:(NSString *)url parm:(id)obj callback:(NetBlock)block{
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"application/octet-stream",@"audio/wav", nil];
    [manager GET:url parameters:obj progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        block(responseObject,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        block(nil,error);
    }];
}

-(NSString *)getIPAddress{
    
    NSString * IP_port;
    IP_port = [NSString stringWithFormat:@"%@:%@",[kUserDefaults objectForKey:IPSTRING],[kUserDefaults objectForKey:PORTSTRING]];
    return IP_port;
}

-(void)checkIPCompareWithIP:(NSString *)ip port:(NSString *)port callback:(CheckIPBlock)block{
    
    self.checkBlock = block;
    NSString * ip_port = [NSString stringWithFormat:@"%@:%@",ip,port];
    NSString * checkUrl = [NSString stringWithFormat:BANNERURL,ip_port];
    NSURLRequest * request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:checkUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:3.0];
    connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
}

#pragma mark -保存正确的ip列表
-(void)saveCurrentIP:(NSString *)ip withPort:(NSString *)port{
    
    //缓存IP port
    NSMutableArray * ipArray = [NSMutableArray arrayWithContentsOfFile:self.ip_PortPath];
    if(ipArray == nil){
        ipArray = [NSMutableArray array];
    }
    NSDictionary * dict = @{ip:port};
    if(![ipArray containsObject:dict]){
        [ipArray addObject:dict];
        [ipArray writeToFile:self.ip_PortPath atomically:YES];
    }
}

#pragma mark -NSURLConnectionDelegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    self.checkBlock(response.textEncodingName,nil);
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    self.checkBlock(nil,error);
}

-(BOOL)checkOutIfHasCorrenctIp_port{
    
    NSString * str = [self getIPAddress];
    id obj = str;
    if([obj isKindOfClass:[NSNull class]]){
        return NO;
    }else{
        return YES;
    }
    
}

-(void)getNewestIp_PortWhenLoginFailed{
    
    NSArray * array = [[NSArray alloc]initWithContentsOfFile:self.ip_PortPath];
    NSDictionary * dict = [array lastObject];
    NSString * ipKey = [dict allKeys][0];
    [kUserDefaults setObject:ipKey forKey:IPSTRING];
    [kUserDefaults setObject:[dict objectForKey:ipKey] forKey:PORTSTRING];
}

-(void)sendAppVersionToService{
    
    
    NSString * ip = [self getIPAddress];
    NSString * urlStr = [NSString stringWithFormat:Send_VersionToService,ip];
    NSString * ID = [[UIDevice currentDevice].identifierForVendor UUIDString];
    NSDictionary * dict = @{@"imei":ID,@"version":[Common appVersion]};
    [self downloadDataWithUrl:urlStr parm:dict callback:^(id responseObject, NSError *error) {
        NSLog(@"%@",error.description);
        NSLog(@"%@",responseObject);
    }];
}

-(void)saveSearchText:(NSString *)text{
    
    //缓存搜索历史记录
    NSMutableArray * historyArray = [NSMutableArray arrayWithContentsOfFile:self.history_search_content];
    if(historyArray == nil){
        historyArray = [NSMutableArray array];
    }
    
    NSMutableArray * newArray;
    if(![historyArray containsObject:text]){
        //        [historyArray addObject:text];
        [historyArray insertObject:text atIndex:0];
        //获取数组的最新10个数据
        if(historyArray.count>10){
            
            NSFileManager * fm = [NSFileManager defaultManager];
            [fm removeItemAtPath:self.history_search_content error:nil];
            
            newArray = [NSMutableArray array];
            for(int i=0;i<10;i++){
                [newArray addObject:historyArray[i]];
            }
            [newArray writeToFile:self.history_search_content atomically:YES];
            return;
        }
        [historyArray writeToFile:self.history_search_content atomically:YES];
    }
}
-(NSMutableArray *)getSearchContent{
    
    return [[NSMutableArray alloc]initWithContentsOfFile:self.history_search_content];
}

-(void)cleanHistorySearch{
    
    NSFileManager * fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:self.history_search_content error:nil];
}

-(NSMutableArray *)getAllServers{
    
//        NSFileManager * fm = [NSFileManager defaultManager];
//        [fm removeItemAtPath:self.ip_PortPath error:nil];
    
    NSMutableArray * muArray = [NSMutableArray array];
    NSArray * array = [NSArray arrayWithContentsOfFile:self.ip_PortPath];
    for(NSDictionary * dict in array){
        NSString * key = [[dict allKeys]lastObject];
        NSString * value = [[dict allValues]lastObject];
        NSString * str = [NSString stringWithFormat:@"%@:%@",value,key];
        [muArray addObject:str];
    }
    return muArray;
}

+(NSMutableArray *)batar_getAllServers{
    
    NetManager * manager = [NetManager shareManager];
    return [manager getAllServers];
}


+(void)judgeCoderWithCode:(NSString *)code Type:(CoderTypeBlock)block{
    
    NetManager * manager = [NetManager shareManager];
    NSString * url = [NSString stringWithFormat:CODETYPE,[manager getIPAddress]];
    NSDictionary * dict = @{@"key":code};
    [manager downloadDataWithUrl:url parm:dict callback:^(id responseObject, NSError *error) {
       
        NSArray * array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if(array.count==0){
            //不存在
            block(CoderTypeFailCoder);
        }else if(array.count == 1){
            block(CoderTypeAccurateType);
        }else{
            block(CoderTypeInaccurateType);
        }
    }];
}

@end
