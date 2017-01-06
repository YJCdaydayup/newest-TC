//
//  BannerModel.h
//  DianZTC
//
//  Created by 杨力 on 22/7/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "JSONModel.h"

@interface BannerModel : JSONModel

//actionaliasname = "\U5a5a\U5e86\U7cfb\U5217";
//actionname = 1;
//aliasname = 45;
//img = 9d377b10ce778c4938b3c7e2c63a229a;
//index = 1;
//isopen = 1;

@property (nonatomic,strong) NSDictionary * action;
@property (nonatomic,copy) NSString * actionname;
@property (nonatomic,copy) NSString * img;
@property (nonatomic,copy) NSString * index;
@property (nonatomic,copy) NSString * aliasname;
@property (nonatomic,copy) NSString * actionaliasname;
@property (nonatomic,strong) NSNumber * type;



@end
