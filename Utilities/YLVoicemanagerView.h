//
//  YLVoicemanagerView.h
//  DianZTC
//
//  Created by 杨力 on 31/10/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHSoundRecorder.h"
#import <CoreText/CoreText.h>

@interface YLVoicemanagerView : UIView<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    
    UITableView * voiceTableView;
    NSMutableArray * dataArray;
}

@property (nonatomic,strong) XHSoundRecorder * audioRecorder;
@property (nonatomic,strong)    UITextField * sendMessageTextfield;

-(id)initWithFrame:(CGRect)frame withVc:(UIView *)bg_view;
-(void)playWithData:(NSData *)data;
-(void)cleanAllVoiceData;//移除对应缓存
-(NSMutableArray *)getAllVoiceMessages;//获取所有语音数据
-(NSMutableArray *)getAllTextMessageStr;//获取所有文字数据
-(void)stopWhenPushAway;//页面跳转就不播放了
@end
