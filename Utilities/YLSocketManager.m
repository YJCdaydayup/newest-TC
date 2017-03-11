
//
//  YLSocketManager.m
//  socket111
//
//  Created by 杨力 on 6/3/2017.
//  Copyright © 2017 杨力. All rights reserved.
//

#import "YLSocketManager.h"

@interface YLSocketManager()

@end

@implementation YLSocketManager

+(instancetype)shareSocketManager{
    static YLSocketManager * instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[YLSocketManager alloc]init];
    });
    return instance;
}

-(void)createSocket:(NSString *)url delegate:(id)delegate{
    
    NSLog(@"self---%@",self);
    self.webSocket = [[SRWebSocket alloc]initWithURL:[NSURL URLWithString:url]];
    self.webSocket.delegate = self;
    self.delegate = delegate;
}

-(void)start{
    
    [self.webSocket open];
}
-(void)stop{
    [self.webSocket close];
}
-(void)sendMessage:(id)msg{
    
    [self.webSocket send:msg];
}

/*
 typedef NS_ENUM(NSInteger, SRReadyState) {
 SR_CONNECTING   = 0,
 SR_OPEN         = 1,
 SR_CLOSING      = 2,
 SR_CLOSED       = 3,
 };
 */
-(BOOL)isOpen{
    if(self.webSocket.readyState == SR_OPEN){
        return YES;
    }else{
        return NO;
    }
}

#pragma SRWebSocketDelegate
-(void)webSocketDidOpen:(SRWebSocket *)webSocket{
    
    NSString * str = [NSString stringWithFormat:@"{\"\cmd\"\:%@,\"\message\"\:\"\%@\"\}",@"0",CUSTOMERID];
    [webSocket send:str];
}

-(void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    NSLog(@"连接失败");
}

-(void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    NSLog(@"连接关闭:%@",reason);
}

-(void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    NSLog(@"收到消息,%@------%p",message,webSocket);
    
    //将数据封装成模型
    NSMutableDictionary * dict = [self dictionaryWithJsonString:message];
    NSMutableDictionary * dict1 = [self dictionaryWithJsonString:dict[@"message"]];
    BatarSocketModel * model = [BatarSocketModel shareBatarSocketModel];
    model.all = dict1[@"all"];
    model.state_0 = dict1[@"state_0"];
    model.state_1 = dict1[@"state_1"];
    model.state_2 = dict1[@"state_2"];
    [self.delegate ylSocket:webSocket didReceiveMessage:message];
}

-(BOOL)webSocketShouldConvertTextFrameToString:(SRWebSocket *)webSocket{
    return YES;
}

//将json字符串转字典
-(NSMutableDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData                                                        options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
