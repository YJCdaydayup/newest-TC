//
//  YLShareView.h
//  DianZTC
//
//  Created by 杨力 on 15/11/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickShareBlock)(NSInteger index);

@interface YLShareView : UIView

@property (nonatomic,copy) ClickShareBlock block;
@property (nonatomic,strong) UIView * maskView;

+(id)shareManager;
-(void)clickShareBtn:(ClickShareBlock)block;


@end
