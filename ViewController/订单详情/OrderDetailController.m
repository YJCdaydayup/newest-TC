//
//  OrderDetailController.m
//  DianZTC
//
//  Created by 杨力 on 22/11/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "OrderDetailController.h"
#import "NetManager.h"
#import "YLVoicemanagerView.h"

#define VOICECELLHEIGHT  35.0

@interface OrderDetailController ()<UITableViewDataSource,UITableViewDelegate>{
    
    UITableView * message_tableView;
}

@property (nonatomic,strong) NSMutableArray * messageArray;

@end

@implementation OrderDetailController

-(void)viewWillDisappear:(BOOL)animated{
    
    //将播放停止
    YLVoicemanagerView * voiceManager = [[YLVoicemanagerView alloc]initWithFrame:self.view.frame withVc:[UIView new]];
    [voiceManager stopWhenPushAway];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:TEXTCOLOR}];
    self.title = @"订单详情";
    
    [self createView];
}

-(void)createView{
    
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, NAV_BAR_HEIGHT, Wscreen, 40*S6)];
    bgView.backgroundColor = RGB_COLOR(249, 249, 249, 1);
    [self.view addSubview:bgView];
    
    UILabel * label = [Tools createLabelWithFrame:CGRectMake(15*S6, 12*S6, 300, 16*S6) textContent:self.createTime withFont:[UIFont systemFontOfSize:16*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentLeft];
    [bgView addSubview:label];
    
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(18*S6, CGRectGetMaxY(bgView.frame)+10*S6, 111*S6, 82.5*S6)];
    imgView.layer.borderWidth = 2.5*S6;
    imgView.layer.borderColor = [CELLBGCOLOR CGColor];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.image = self.img;
    [self.view addSubview:imgView];
    
    UILabel * nameLabel = [Tools createLabelWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame)+17.5*S6, CGRectGetMinY(imgView.frame)+1.5*S6, 200, 14*S6) textContent:self.name withFont:[UIFont systemFontOfSize:14*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:nameLabel];
    
    UILabel * numberLabel = [Tools createLabelWithFrame:CGRectMake(CGRectGetMinX(nameLabel.frame), CGRectGetMaxY(nameLabel.frame)+15*S6, 200, 14*S6) textContent:self.number withFont:[UIFont systemFontOfSize:14*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:numberLabel];
    
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView.frame)+10*S6, Wscreen, 0.5*S6)];
    lineView1.backgroundColor = BOARDCOLOR;
    [self.view addSubview:lineView1];
    
    UIButton * backBtn = [Tools createNormalButtonWithFrame:CGRectMake(0, Hscreen-50*S6, Wscreen, 50*S6) textContent:@"返回" withFont:[UIFont systemFontOfSize:18*S6] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    backBtn.backgroundColor = RGB_COLOR(231, 140, 59, 1);
    [backBtn addTarget:self action:@selector(backAct) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    [self createTableView:lineView1];
}

-(void)createTableView:(UIView *)lineView{
    
    message_tableView = [[UITableView alloc]initWithFrame:CGRectMake(18*S6,CGRectGetMaxY(lineView.frame)+10*S6, Wscreen-36*S6, Hscreen-60*S6-CGRectGetMaxY(lineView.frame))];
    //    message_tableView.backgroundColor = [UIColor redColor];
    [self.view addSubview:message_tableView];
    message_tableView.tableFooterView = [[UIView alloc]init];
    message_tableView.delegate = self;
    message_tableView.dataSource = self;
    message_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.messageArray = [self getMessageData];
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.messageArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    id obj = [self.messageArray objectAtIndex:indexPath.row];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if([obj isKindOfClass:[NSString class]]){
        
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.size.width-36*S6, [self getTextCellHeight:(NSString *)obj])];
        bgView.layer.cornerRadius = 3.0*S6;
        bgView.layer.masksToBounds = YES;
        bgView.layer.borderColor = [BOARDCOLOR CGColor];
        bgView.layer.borderWidth = 1.0*S6;
        bgView.tag = 954;
        [cell.contentView addSubview:bgView];
        
        //文字
        UILabel * label = [Tools createLabelWithFrame:CGRectMake(10*S6, 8*S6, Wscreen -36*S6-90*S6, [self getTextCellHeight:(NSString *)obj]) textContent:nil withFont:[UIFont systemFontOfSize:15*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentLeft];
        label.tag = 955;
        [bgView addSubview:label];
        
        UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0,[self getTextCellHeight:(NSString *)obj], Wscreen -36*S6, 10*S6)];
        [cell.contentView addSubview:view1];
        
    }else{
        
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Wscreen -36*S6, VOICECELLHEIGHT)];
        bgView.layer.cornerRadius = 3.0*S6;
        bgView.layer.masksToBounds = YES;
        bgView.layer.borderColor = [BOARDCOLOR CGColor];
        bgView.layer.borderWidth = 1.0*S6;
        bgView.tag = 953;
        bgView.backgroundColor = RGB_COLOR(249, 249, 249, 1);
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
        UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0,VOICECELLHEIGHT, Wscreen -36*S6, 10*S6)];
        [cell.contentView addSubview:view1];
    }
    
    if([obj isKindOfClass:[NSString class]]){
        
        UIView * bgView = (UIView *)[cell.contentView viewWithTag:954];
        
        //文字label
        UILabel * text_label = (UILabel *)[bgView viewWithTag:955];
        text_label.text = (NSString *)obj;
        text_label.numberOfLines = 0;
        [text_label sizeToFit];
        
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id obj = [self.messageArray objectAtIndex:indexPath.row];
    if([obj isKindOfClass:[NSString class]]){
        return [self getTextCellHeight:(NSString *)obj]+10*S6;
    }else{
        return (VOICECELLHEIGHT+10)*S6;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id obj = self.messageArray[indexPath.row];
    if([obj isKindOfClass:[NSData class]]){
        YLVoicemanagerView * voiceManager = [[YLVoicemanagerView alloc]initWithFrame:self.view.frame withVc:[UIView new]];
        [voiceManager playWithData:(NSData *)obj];
    }
}

-(NSMutableArray *)getMessageData{
    
    
    NetManager * manager = [NetManager shareManager];
    NSMutableArray * array = [NSMutableArray array];
    
    for(NSDictionary * dict in self.dataArray){
        
        NSString * txt = dict[@"txt"];
        if(![txt containsString:@"wav"]){
            [array addObject:txt];
        }else{
            
//            NSLog(@"有语音");
            [self.hud show:YES];
            NSString * urlStr = [NSString stringWithFormat:GETVOICEURL,[manager getIPAddress],txt];
            [manager downloadDataWithUrl:urlStr parm:nil callback:^(id responseObject, NSError *error) {
                if([responseObject isKindOfClass:[NSData class]]){
//                    NSLog(@"%@",responseObject);
                    [array addObject:responseObject];
                    if(array.count == self.dataArray.count){
                        [self.hud hide:YES];
                        [message_tableView reloadData];
                    }
                }else{
                    NSLog(@"%@",error.description);
                }
            }];
        }
    }
    return array;
}

-(void)backAct{
    
    [self popToViewControllerWithDirection:@"right" type:NO];
}

//获取文本的高度
-(CGFloat)getTextCellHeight:(NSString *)text{
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10*S6, 0, Wscreen -36*S6-50*S6, 10)];
    label.text = text;
    label.font = [UIFont systemFontOfSize:14*S6];
    label.numberOfLines = 0;
    [label sizeToFit];
    return ((int)label.height/14)>1?(label.height/14.0)*label.height:35*S6;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
