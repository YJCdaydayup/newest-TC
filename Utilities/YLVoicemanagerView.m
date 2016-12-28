

//
//  YLVoicemanagerView.m
//  DianZTC
//
//  Created by 杨力 on 31/10/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "YLVoicemanagerView.h"
#import <AVFoundation/AVFoundation.h>
#import "NSTimer+Net.h"
#import "AppDelegate.h"

#define VOICECELLHEIGHT  35.0
#define TIMERCOUNTER @"timerCount"

@interface YLVoicemanagerView(){
    
 
    UIButton * recordBtn;
    BOOL keyboardState;
    UIView * bgViews;
    UIButton * keyBoardBtn;
    NSTimer * my_timer;
}

@property (nonatomic,copy) NSString * my_RecordPath;
@property (nonatomic,copy) NSString * systemVoicePath;
@property (nonatomic,assign) NSInteger count;

@end

@implementation YLVoicemanagerView
@synthesize sendMessageTextfield = sendMessageTextfield;
-(id)initWithFrame:(CGRect)frame withVc:(UIView *)bg_view{
    
    if(self = [super initWithFrame:frame]){
        self.my_RecordPath = [NSString stringWithFormat:@"%@%@.plist",LIBPATH,[kUserDefaults objectForKey:RECORDPATH]];
        bgViews = bg_view;
        [self createView];
    }
    return self;
}

-(void)createView{
    
    dataArray = [NSMutableArray array];
    voiceTableView = [[UITableView alloc]initWithFrame:CGRectMake(20*S6, 0, self.frame.size.width-40*S6, 4*(VOICECELLHEIGHT+10)*S6)];
    voiceTableView.backgroundColor = RGB_COLOR(238, 238, 238, 1);
    voiceTableView.delegate = self;
    voiceTableView.dataSource = self;
    voiceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:voiceTableView];
    
    [self createData];
    
    [self createKeyboard];
}

-(void)createKeyboard{
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(voiceTableView.frame)+5*S6, Wscreen, 1*S6)];
    lineView.backgroundColor = BOARDCOLOR;
    [self addSubview:lineView];
    
    //创建键盘
    keyBoardBtn = [Tools createButtonNormalImage:@"showKeyboard" selectedImage:nil tag:0 addTarget:self action:@selector(changeVoice)];
    [keyBoardBtn setImage:[UIImage imageNamed:@"voice_keyboard"] forState:UIControlStateSelected];
    keyBoardBtn.frame = CGRectMake(10*S6,CGRectGetMaxY(lineView.frame)+7*S6, 30*S6, 30*S6);
    [self addSubview:keyBoardBtn];
    
    
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10*S6, 35*S6)];
    sendMessageTextfield = [Tools createTextFieldFrame:CGRectMake(CGRectGetMaxX(keyBoardBtn.frame)+10*S6, CGRectGetMaxY(lineView.frame)+7*S6, Wscreen-(10+30+20+10)*S6, 35*S6) placeholder:nil bgImageName:nil leftView:leftView rightView:nil isPassWord:NO];
    sendMessageTextfield.layer.cornerRadius = 5*S6;
    sendMessageTextfield.layer.masksToBounds = YES;
    sendMessageTextfield.layer.borderWidth = 1.0*S6;
    sendMessageTextfield.layer.borderColor = [BOARDCOLOR CGColor];
    sendMessageTextfield.delegate = self;
    sendMessageTextfield.backgroundColor = [UIColor whiteColor];
    sendMessageTextfield.returnKeyType = UIReturnKeySend;
    [self addSubview:sendMessageTextfield];
    
    recordBtn = [Tools createNormalButtonWithFrame:sendMessageTextfield.frame textContent:@"按住发言" withFont:[UIFont systemFontOfSize:16*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentCenter];
    [recordBtn setTitle:@"正在录音..." forState:UIControlStateHighlighted];
    recordBtn.backgroundColor = RGB_COLOR(252, 249, 236, 1);
    recordBtn.layer.cornerRadius = 5*S6;
    recordBtn.layer.masksToBounds = YES;
    recordBtn.layer.borderWidth = 1.0*S6;
    recordBtn.layer.borderColor = [BOARDCOLOR CGColor];
    [self addSubview:recordBtn];
    
    [recordBtn addTarget:self action:@selector(pressAction) forControlEvents:UIControlEventTouchDown];
    [recordBtn addTarget:self action:@selector(touchUpAction) forControlEvents:UIControlEventTouchUpInside];
    [recordBtn addTarget:self action:@selector(dragAction) forControlEvents:UIControlEventTouchDragExit];
}

-(void)saveDateToPlistFile:(id)data{
    
    NSMutableArray * dataArrays = [[NSMutableArray alloc]initWithContentsOfFile:self.my_RecordPath];
    if(dataArrays == nil){
        dataArrays = [NSMutableArray array];
    }
    NSDictionary * dict = @{[self getMessageRecordTime]:data};
    if(![dataArrays containsObject:dict]){
        [dataArrays addObject:dict];
        [dataArrays writeToFile:self.my_RecordPath atomically:YES];
    }
    //    NSLog(@"%zi",[[NSMutableArray alloc]initWithContentsOfFile:self.my_RecordPath].count);
}

-(NSString *)getMessageRecordTime{
    
    NSString * timeCount;
    NSInteger count = [[kUserDefaults objectForKey:TIMERCOUNTER]integerValue];
    if(count == 0){
        timeCount = @"0";
    }else{
        timeCount = [kUserDefaults objectForKey:TIMERCOUNTER];
    }
    
    //    NSLog(@"timerCount:  %@",timeCount);
    NSString * str = [NSString stringWithFormat:@"%@,%@",[self stringFromDate],timeCount];
    return str;
}

-(NSString *)stringFromDate{
    
    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970]*1000;
    long long theTime = [[NSNumber numberWithDouble:nowtime] longLongValue];
    NSString *curTime = [NSString stringWithFormat:@"%llu",theTime];
    return curTime;
}

#pragma mark - 录音
-(void)pressAction{
    
    [self recorderAccess];
    
    self.count = 0;
    [kUserDefaults setObject:@"0" forKey:TIMERCOUNTER];
    __block typeof(self)weakSelf = self;
    //开始录音
    [self.audioRecorder startRecorder:^(NSString *filePath) {
        
        //        NSLog(@"录音文件路径:%@",filePath);
        weakSelf.systemVoicePath = filePath;
        //录音停止就来这个获取录音数据
        NSData * data = [[NSData alloc]initWithContentsOfFile:filePath];
        //        NSLog(@"%zi",[[kUserDefaults objectForKey:TIMERCOUNTER]integerValue]);
        
        if(data.length&&[[kUserDefaults objectForKey:TIMERCOUNTER]integerValue]>0){
            [weakSelf saveDateToPlistFile:data];
            weakSelf.count = 0;
            [kUserDefaults setObject:@"0" forKey:TIMERCOUNTER];
        }
        [weakSelf createData];
    }];
    
    my_timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES callback:^{
        
        weakSelf.count ++;
        //        NSLog(@"%zi",weakSelf.count);
        [kUserDefaults setObject:[NSString stringWithFormat:@"%zi",weakSelf.count] forKey:TIMERCOUNTER];
    }];
    [[NSRunLoop currentRunLoop]addTimer:my_timer forMode:NSDefaultRunLoopMode];
}

-(void)recorderAccess{
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        AVAudioSessionRecordPermission permissionStatus = [[AVAudioSession sharedInstance] recordPermission];
        
        switch (permissionStatus) {
            case AVAudioSessionRecordPermissionUndetermined:{
                NSLog(@"第一次调用，是否允许麦克风弹框");
                [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                    // CALL YOUR METHOD HERE - as this assumes being called only once from user interacting with permission alert!
                    if (granted) {
                        // Microphone enabled code
                    }
                    else {
                        // Microphone disabled code
                    }
                }];
                break;
            }
            case AVAudioSessionRecordPermissionDenied:
                // direct to settings...
                NSLog(@"已经拒绝麦克风弹框");
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIAlertController * control = [UIAlertController alertControllerWithTitle:@"无法录音" message:@"请在“设置-隐私-麦克风”选项中允许“珠宝图鉴”访问你的麦克风" preferredStyle:UIAlertControllerStyleAlert];
                    
                    
                    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    
                    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [app.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
                        
                    }];
                    [control addAction:action];
                    [app.window.rootViewController presentViewController:control animated:YES completion:nil];
                    
                });
                
                break;
            case AVAudioSessionRecordPermissionGranted:
                NSLog(@"已经允许麦克风弹框");
                // mic access ok...
                break;
            default:
                // this should not happen.. maybe throw an exception.
                break;
        }
        if(permissionStatus == AVAudioSessionRecordPermissionUndetermined) return;
    }
}

-(void)touchUpAction{
    
    [self.audioRecorder stopRecorder];
    [my_timer setFireDate:[NSDate distantFuture]];
//    [my_timer invalidate];
}

-(void)dragAction{
    
    //如果是拖出按钮，就将当前语音删除
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:self.systemVoicePath error:nil];
}

#pragma amrk - 发送文字信息
-(void)sendOutTextMessage:(NSString *)text{
    
    [self saveDateToPlistFile:text];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    //发送消息
    if(textField.text.length>0&&[self judgeSpace:textField.text]){
        
        [self sendOutTextMessage:textField.text];
        [self createData];
    }
    textField.text = nil;
    return YES;
}

-(BOOL)judgeSpace:(NSString *)text{
    
    NSArray * array = [text componentsSeparatedByString:@" "];
    NSInteger lenth = text.length;
    if(array.count-1 == lenth){
        return NO;
    }else{
        return YES;
    }
}

#pragma mark -更换键盘
-(void)changeVoice{
    
    keyboardState = !keyboardState;
    if(keyboardState){
        recordBtn.hidden = YES;
        keyBoardBtn.selected = YES;
    }else{
        
        [sendMessageTextfield resignFirstResponder];
        recordBtn.hidden = NO;
        keyBoardBtn.selected = NO;
    }
}

#pragma mark - 获取所有数据

-(NSMutableArray *)getAllRecordDataArray{
    
    return [[NSMutableArray alloc]initWithContentsOfFile:self.my_RecordPath];
}

-(void)createData{
    
    dataArray = [self getAllRecordDataArray];
    [voiceTableView reloadData];
    if(dataArray.count>1){
        [voiceTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[dataArray count]- 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSDictionary * dict = @{@"1":@(1)};
    if(![dataArray containsObject:dict]){
        [dataArray addObject:dict];
    }else{
        NSInteger index = [dataArray indexOfObject:dict];
        [dataArray exchangeObjectAtIndex:index withObjectAtIndex:dataArray.count-1];
    }
    return dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary * dict = [dataArray objectAtIndex:indexPath.row];
    NSString * key = [[dict allKeys]lastObject];
    id obj = [dict objectForKey:key];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if([obj isKindOfClass:[NSString class]]){
        
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width-40*S6, [self getTextCellHeight:(NSString *)obj]+20*S6)];
        bgView.layer.cornerRadius = 3.0*S6;
        bgView.layer.masksToBounds = YES;
        bgView.layer.borderColor = [BOARDCOLOR CGColor];
        bgView.layer.borderWidth = 1.0*S6;
        bgView.tag = 854;
        [cell.contentView addSubview:bgView];
        
        //文字
        UILabel * label = [Tools createLabelWithFrame:CGRectMake(10*S6, 10*S6, self.frame.size.width-90*S6,[self getTextCellHeight:(NSString *)obj]) textContent:nil withFont:[UIFont systemFontOfSize:14*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentLeft];
        label.tag = 855;
        [bgView addSubview:label];
        
        UIButton * deleteBtn = [Tools createButtonNormalImage:@"delete_remark" selectedImage:nil tag:1 addTarget:self action:@selector(deleteCell:)];
        deleteBtn.frame = CGRectMake(self.frame.size.width-70*S6,9*S6, 17*S6, 17*S6);
        deleteBtn.tag = indexPath.row;
        [bgView addSubview:deleteBtn];
        
        UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0,[self getTextCellHeight:(NSString *)obj], self.frame.size.width, 10*S6)];
        [cell.contentView addSubview:view1];
        
    }else if([obj isKindOfClass:[NSData class]]){
        
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width-40*S6, VOICECELLHEIGHT)];
        bgView.layer.cornerRadius = 3.0*S6;
        bgView.layer.masksToBounds = YES;
        bgView.layer.borderColor = [BOARDCOLOR CGColor];
        bgView.layer.borderWidth = 1.0*S6;
        bgView.tag = 853;
        bgView.backgroundColor = RGB_COLOR(231, 231, 231, 1);
        [cell.contentView addSubview:bgView];
        
        //语音
        CGFloat height = 0;
        if(IS_IPHONE == IS_IPHONE_5||IS_IPHONE == IS_IPHONE_4_OR_LESS){
            height = 12.5*S6;
        }else if (IS_IPHONE == IS_IPHONE_6){
            height = 8.5*S6;
        }else if (IS_IPHONE == IS_IPHONE_6P){
            height = 7.0*S6;
        }
        
        UIImageView * voiceImg = [[UIImageView alloc]initWithFrame:CGRectMake(12.5*S6, height, 12*S6, 12*13.5/8.5*S6)];
        voiceImg.image = [UIImage imageNamed:@"play_voice"];
        [bgView addSubview:voiceImg];
        
        CGFloat height1 = 0;
        if(IS_IPHONE == IS_IPHONE_5||IS_IPHONE == IS_IPHONE_4_OR_LESS){
            height1 = 13.5*S6;
        }else if (IS_IPHONE == IS_IPHONE_6){
            height1 = 9.5*S6;
        }else if (IS_IPHONE == IS_IPHONE_6P){
            height1 = 9.0*S6;
        }
        
        UIButton * deleteBtn = [Tools createButtonNormalImage:@"delete_remark" selectedImage:nil tag:1 addTarget:self action:@selector(deleteCell:)];
        deleteBtn.tag = indexPath.row;
        deleteBtn.frame = CGRectMake(self.frame.size.width-70*S6,height1, 17*S6, 17*S6);
        [bgView addSubview:deleteBtn];
        
        UILabel * time_label = [Tools createLabelWithFrame:CGRectMake(10*S6, height1, 40*S6, 14*S6) textContent:nil withFont:[UIFont systemFontOfSize:14*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentCenter];
        time_label.tag = 856;
        [bgView addSubview:time_label];
        
        UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0,VOICECELLHEIGHT, self.frame.size.width, 10*S6)];
        [cell.contentView addSubview:view1];
    }else{
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 2.1*S6, self.frame.size.width-40*S6, 115*S6)];
//        label.backgroundColor = [UIColor redColor];
//        cell.backgroundColor = [UIColor orangeColor];
        label.backgroundColor = [UIColor whiteColor];
        label.layer.borderColor = [BOARDCOLOR CGColor];
        label.layer.borderWidth = 0.5*S6;
        label.userInteractionEnabled = YES;
        [cell.contentView addSubview:label];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(activeTextfield)];
        [label addGestureRecognizer:tap];
    }
    
    cell.backgroundColor = RGB_COLOR(238, 238, 238, 1);
    
    if([obj isKindOfClass:[NSString class]]){
        
        UIView * bgView = (UIView *)[cell.contentView viewWithTag:854];
        
        //文字label
        UILabel * text_label = (UILabel *)[bgView viewWithTag:855];
        text_label.text = (NSString *)obj;
        text_label.numberOfLines = 0;
        [text_label sizeToFit];
        
    }else if([obj isKindOfClass:[NSData class]]){
        
        UIView * bgView = (UIView *)[cell.contentView viewWithTag:853];
        //语音时长label
        UILabel * time_label = (UILabel *)[bgView viewWithTag:856];
        NSString * record_time = [[key componentsSeparatedByString:@","]lastObject];
        time_label.text = [NSString stringWithFormat:@"%@'%@",record_time,@"'"];
        time_label.width = [Tools getTextWidth:time_label.text withHeight:14*S6]+5*S6;
        time_label.x = Wscreen-75*S6-[Tools getTextWidth:time_label.text withHeight:14*S6];
    }
    return cell;
}

-(void)activeTextfield{
    
    keyboardState = NO;
    [self changeVoice];
    [sendMessageTextfield becomeFirstResponder];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary * dict = [dataArray objectAtIndex:indexPath.row];
    NSString * key = [[dict allKeys]lastObject];
    id obj = [dict objectForKey:key];
    if([obj isKindOfClass:[NSString class]]){
        return [self getTextCellHeight:(NSString *)obj]+30*S6;
    }else if([obj isKindOfClass:[NSData class]]){
        return (VOICECELLHEIGHT+18)*S6;
    }else{
        return 120*S6;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary * dict = [dataArray objectAtIndex:indexPath.row];
    id obj = [[dict allValues]lastObject];
    if([obj isKindOfClass:[NSData class]]){
        [self playWithData:(NSData *)obj];
    }
}

-(NSMutableArray *)getAllTextMessageStr{
    
    NSMutableArray * message_content_time = [NSMutableArray array];
    NSMutableArray * dataArrays = [self getAllRecordDataArray];
    for(NSDictionary * dict in dataArrays){
        
        NSString * key = [[dict allKeys]lastObject];
        id obj = dict[key];
        if([obj isKindOfClass:[NSString class]]){
            
            NSString * currentTime1 = [[key componentsSeparatedByString:@","]firstObject];
            NSDictionary * dict = @{@"time":currentTime1,@"txt":(NSString *)obj};
            [message_content_time addObject:dict];
        }
    }
    return message_content_time;
}

-(NSMutableArray *)getAllVoiceMessages{
    
    NSMutableArray * message_content_time = [NSMutableArray array];
    NSMutableArray * dataArrays = [self getAllRecordDataArray];
    if(dataArrays.count==0){
        return nil;
    }
    for(NSDictionary * dict in dataArrays){
        
        NSString * key = [[dict allKeys]lastObject];
        id obj = dict[key];
        if(![obj isKindOfClass:[NSString class]]){
            
            NSString * currentTime1 = [[key componentsSeparatedByString:@","]firstObject];
            NSDictionary * dict = @{currentTime1:(NSString *)obj};
            //NSLog(@"%@",dict);
            [message_content_time addObject:dict];
        }
    }
    return message_content_time;
}

-(void)playWithData:(NSData *)data{
    
    [self.audioRecorder stopPlaysound];
    NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * currentPath = [NSString stringWithFormat:@"%@/llll.wav", strUrl];
    [data writeToFile:currentPath atomically:YES];
    [self.audioRecorder playsound:currentPath withFinishPlaying:^{
        NSLog(@"播放完成");
    }];
}

-(void)stopWhenPushAway{
    
    [self.audioRecorder stopPlaysound];
}

//删除消息
-(void)deleteCell:(UIButton *)btn{
    
    [self deleteMesWithRow:btn.tag];
    [self createData];
}

-(void)deleteMesWithRow:(NSInteger)row{
    
    NSMutableArray * dataArrays = [self getAllRecordDataArray];
    [dataArrays removeObjectAtIndex:row];
    [self cleanAllVoiceData];
    [dataArrays writeToFile:self.my_RecordPath atomically:YES];
}

-(void)cleanAllVoiceData{
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSError * error;
    BOOL isDeleted = [fileManager removeItemAtPath:self.my_RecordPath error:&error];
    if(isDeleted){
        //        NSLog(@"清除成功");
    }else{
        //        NSLog(@"%@",error.description);
    }
}

//获取文本的高度
-(CGFloat)getTextCellHeight:(NSString *)text{
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10*S6, 8*S6, self.frame.size.width-90*S6, 10)];
    label.text = text;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.font = [UIFont systemFontOfSize:14*S6];
    label.numberOfLines = 0;
    [label sizeToFit];
//    return ((int)label.height/14)>1?(label.height/14.0)*label.height:35*S6;
    return label.height;
}

-(XHSoundRecorder *)audioRecorder{
    
    if(_audioRecorder == nil){
        
        _audioRecorder = [XHSoundRecorder sharedSoundRecorder];
    }
    return _audioRecorder;
}

@end
