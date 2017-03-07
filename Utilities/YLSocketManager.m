
//
//  YLSocketManager.m
//  socket111
//
//  Created by 杨力 on 6/3/2017.
//  Copyright © 2017 杨力. All rights reserved.
//

#import "YLSocketManager.h"

@interface YLSocketManager(){
    
    SRWebSocket *_webSocket;
}

@end

@implementation YLSocketManager

-(instancetype)initWithUrl:(NSString *)urlStr delegate:(id)delegate{
    
    if(self = [super init]){
        self.delegate = delegate;
        _webSocket = [[SRWebSocket alloc]initWithURL:[NSURL URLWithString:urlStr]];
        _webSocket.delegate = self;
    }
    return self;
}
-(void)start{
    
    [_webSocket open];
}
-(void)stop{
    [_webSocket close];
}
-(void)sendMessage:(id)msg{
    
    [_webSocket send:msg];
}

#pragma SRWebSocketDelegate
-(void)webSocketDidOpen:(SRWebSocket *)webSocket{
    
    NSLog(@"连接成功");
    [self.delegate ylSocketDidOpen:webSocket];
}

-(void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    [self.delegate ylSocket:webSocket didFailWithError:error];
    NSLog(@"连接失败");
}

-(void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    [self.delegate ylSocket:webSocket didCloseWithCode:code reason:reason wasClean:wasClean];
    NSLog(@"连接关闭:%@",reason);
}

-(void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    NSLog(@"收到消息,%@",message);
    [self.delegate ylSocket:webSocket didReceiveMessage:message];
}

-(BOOL)webSocketShouldConvertTextFrameToString:(SRWebSocket *)webSocket{
    return YES;
}

@end
