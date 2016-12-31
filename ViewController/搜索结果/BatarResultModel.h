//
//  BatarResultModel.h
//  DianZTC
//
//  Created by 杨力 on 29/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "JSONModel.h"

@interface BatarResultModel : JSONModel

//{"totlesize":18,
//"page":[
//{"category":"吊坠",
//"name":"吊坠",
//"number":"112544",
//"time":"*",
//"image":"161026110139860_4d2c96fab5d348f9ce8f4c7a40901f56.jpg",
//"number_module":"吊坠$吊坠$$$花、五角星$$$倒模$112544$$4$0$0$0$0$1",
//"online":true},

@property (nonatomic,copy) NSString * category;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * number;
@property (nonatomic,copy) NSString * image;
//@property (nonatomic,copy) NSString * number_module;

@end
