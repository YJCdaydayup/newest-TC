//
//  OrderCarModel.h
//  DianZTC
//
//  Created by 杨力 on 9/11/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "JSONModel.h"

@interface OrderCarModel : JSONModel

//[{"orderid":"20161109150449688",
//"customerid":"123",
//"createtime":"2016-11-09 15:04",
//"products":[
//{"number":"S600001","message":null,"name":"贵气天成","image":"161108200327098_76f26bb11e5d752f4c7b439dd0f383e5.jpg","module":"套装$贵气天成$$足金999$$女$$倒模$S600001$$135-220$0$0$0$0$1"
//}
//]
//}]

@property (nonatomic,copy) NSString * number;
@property (nonatomic,copy) NSString * message;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * image;
@property (nonatomic,copy) NSString * module;
@property (nonatomic,assign) BOOL selected;
@property (nonatomic,copy) NSString * note;


@end
