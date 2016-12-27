//
//  YLUploadToServer.m
//  DianZTC
//
//  Created by 杨力 on 27/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "YLUploadToServer.h"
#import "DBSaveModel.h"
#import "DBWorkerManager.h"
#import "NSTimer+Net.h"

@implementation YLUploadToServer
singleM(UploadToServer)

-(instancetype)init{
    
    if(self = [super init]){
        
        self.uploadTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES callback:^{
            
            [self batar_uploadOrdersToServer];
        }];
        [self batar_stop];
    }
    return self;
}

-(void)batar_uploadOrdersToServer{
    
    DBWorkerManager * db_manager = [DBWorkerManager shareDBManager];
    
    [db_manager order_getAllObject:^(NSMutableArray *dataArray) {
        for(DBSaveModel * model in dataArray){
            [kUserDefaults setObject:model.number forKey:RECORDPATH];
            @synchronized(self) {
                [self addMyOrders:model];
                NSLog(@"下一次了吗?");
            }
        }
    }];
}

-(void)batar_start{
    
    [self.uploadTimer setFireDate:[NSDate distantPast]];
}

-(void)batar_stop{
    
    [self.uploadTimer setFireDate:[NSDate distantFuture]];
}

-(void)batar_deleteOrder:(NSString *)number{
    
    DBWorkerManager * db_manager = [DBWorkerManager shareDBManager];
    YLVoicemanagerView * voice_manager = [[YLVoicemanagerView alloc]initWithFrame:CGRectZero withVc:[UIView new]];
    [db_manager order_cleanDBDataWithNumber:number];
    [voice_manager cleanAllVoiceData];
}

//加入我的选购单
-(void)addMyOrders:(DBSaveModel *)model{
    
    self.number = model.number;
    
    YLVoicemanagerView * recordManager = [[YLVoicemanagerView alloc]initWithFrame:CGRectZero withVc:[UIView new]];
    NSMutableArray * reNameVoiceArray = [NSMutableArray array];//获取所有的语音数组
    NSMutableArray * voiceArray = [recordManager getAllVoiceMessages];
    for(int i = 0;i<voiceArray.count;i++){
        
        NSDictionary * dict = [voiceArray objectAtIndex:i];
        NSString * key = [[dict allKeys]lastObject];
        NSData * data = dict[key];
        
        NSString * newKey = [NSString stringWithFormat:@"%@@%@@%@.wav",[kUserDefaults objectForKey:CustomerID],key,model.number];
        NSDictionary * newDict = @{newKey:data};
        [reNameVoiceArray addObject:newDict];
    }
    
    NetManager * netmanager = [NetManager shareManager];
    NSString * urlStr = [NSString stringWithFormat:UPLOADORDERCAR,[netmanager getIPAddress]];
    //    NSLog(@"%@",[recordManager getAllTextMessageStr]);
    NSDictionary * subDict;
    if([recordManager getAllTextMessageStr].count>0){
        subDict = @{@"number":model.number,@"customerid":[kUserDefaults objectForKey:CustomerID],@"message":[self arrayToJson:[recordManager getAllTextMessageStr]]};
    }else{
        subDict = @{@"number":model.number,@"customerid":[kUserDefaults objectForKey:CustomerID],@"message":@""};
    }
    [netmanager downloadDataWithUrl:urlStr parm:subDict callback:^(id responseObject, NSError *error) {
        
        if(responseObject){
            if(reNameVoiceArray.count == 0){
                NSLog(@"上传成功的model:%@,删除本地",model.number);
                [self batar_deleteOrder:model.number];
            }else{
                [self sendVoiceToServer:reNameVoiceArray];
            }
        }else{
            NSLog(@"%@",error.description);
        }
    }];
}

-(void)sendVoiceToServer:(NSMutableArray *)array{
    
    NetManager * manager = [NetManager shareManager];
    // 把语音数据（作为请求体）传过去
    AFHTTPSessionManager * fileManager = [AFHTTPSessionManager manager];
    fileManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    fileManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"application/octet-stream",@"application/x-www-form-urlencoded",@"text/plain",nil];
    NSString * voiceUrl = [NSString stringWithFormat:UPLOADVOICE,[manager getIPAddress]];
    [fileManager POST:voiceUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //先将数据写入文件
        for(int i = 0;i<array.count;i++){
            
            NSDictionary * dict = array[i];
            NSString * fileName = [[dict allKeys]lastObject];
            NSData * data = [dict objectForKey:fileName];
            [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"application/octet-stream"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(responseObject){
            
            NSLog(@"%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
            if(responseObject){
                NSLog(@"文字上传成功，删除本地");
                [self batar_deleteOrder:self.number];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.description);
    }];
}

-(NSString *)arrayToJson:(NSMutableArray *)picArr{
    
    if (picArr && picArr.count > 0) {
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        
        for (NSDictionary * dict in picArr) {
            
            NSString * jsonText = [self dictionaryToJson:dict];
            [arr addObject:jsonText];
        }
        
        return [self objArrayToJSON:arr];
    }
    
    return nil;
}


#pragma mark -将字典转化成json字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSString*)myArrayToJson:(NSMutableArray *)array{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//把多个json字符串转为一个json字符串
- (NSString *)objArrayToJSON:(NSArray *)array {
    
    NSString *jsonStr = @"[";
    
    for (NSInteger i = 0; i < array.count; ++i) {
        if (i != 0) {
            jsonStr = [jsonStr stringByAppendingString:@","];
        }
        jsonStr = [jsonStr stringByAppendingString:array[i]];
    }
    jsonStr = [jsonStr stringByAppendingString:@"]"];
    
    return jsonStr;
}


@end
