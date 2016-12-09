
//
//  YLTransVoiceToText.m
//  语音转文字封装
//
//  Created by 杨力 on 19/10/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "YLTransVoiceToText.h"

@implementation YLTransVoiceToText

+(instancetype)shareVoiceManager{
    
    static YLTransVoiceToText * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YLTransVoiceToText alloc]init];
    });
    return manager;
}

-(instancetype)init{
    
    if(self = [super init]){
        [self setVoiceManager];
    }
    return self;
}

-(void)setVoiceManager{
    
    //SDK的版本号
    //    NSLog(@"%@",[IFlySetting getVersion]);
    [IFlySetting setLogFile:LVL_ALL];
    [IFlySetting showLogcat:NO];
    
    //设置sdk的工作路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",IFLY_KEY];
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
}

-(void)createiFlyViewWithFrame:(CGPoint)point{
    
    //初始化语音识别控件
    _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:point];
    _iflyRecognizerView.delegate = self;
    [_iflyRecognizerView setParameter: @"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
    //asr_audio_path保存录音文件名，如不再需要，设置value为nil表示取消，默认目录是documents
    [_iflyRecognizerView setParameter:@"asrview.aac" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
}

-(void)startTransfer{
     [_iflyRecognizerView start];
}

/*识别结果返回代理
 @param resultArray 识别结果
 @ param isLast 表示是否最后一次结果
 */
- (void)onResult: (NSArray *)resultArray isLast:(BOOL) isLast
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    NSString * resultFromJson =  [ISRDataHelper stringFromJson:result];
    [self.delegate yl_succeedTransferVoiceToText:resultFromJson];
}
/*识别会话错误返回代理
 @ param  error 错误码
 */
- (void)onError: (IFlySpeechError *) error
{
   [self.delegate yl_failTransferVoiceToText:error.errorDesc];
}

@end
