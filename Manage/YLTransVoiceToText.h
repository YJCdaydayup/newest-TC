//
//  YLTransVoiceToText.h
//  语音转文字封装
//
//  Created by 杨力 on 19/10/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISRDataHelper.h"
#import <iflyMSC/iflyMSC.h>

#define IFLY_KEY @"580d9fea"

@protocol YLVoiceTransferDelegate <NSObject>

-(void)yl_succeedTransferVoiceToText:(NSString *)text;
-(void)yl_failTransferVoiceToText:(NSString *)error;

@end

@interface YLTransVoiceToText : NSObject<IFlyRecognizerViewDelegate>{
    
    IFlyRecognizerView * _iflyRecognizerView;
}

@property (nonatomic,assign) id<YLVoiceTransferDelegate>delegate;

+(instancetype)shareVoiceManager;
-(void)createiFlyViewWithFrame:(CGPoint)point;
-(void)startTransfer;//开始转换成文字时，先将利用YLAudioRecorder的-(void)transferVoiceToTextWithRow:(NSInteger)row方法将文件进行替换


@end
