//
//  BatarCommandModel.h
//  DianZTC
//
//  Created by 杨力 on 29/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "JSONModel.h"
#import "BatarCommandSubModel.h"

@interface BatarCommandModel : JSONModel

//{
//id = 5858e19134bec01341e48785;
//products =         (
//                    {
//                        image = "161108150641668_4ebc0d4af0259834378a82faefd0999b.jpg";
//                        name = "\U5fc3\U706b\U76f8\U4f20";
//                        number = S100007;
//                    },
//                    {
//                        image = "161108150641608_8e125b3a6617765b7c896e7ad6f95683.jpg";
//                        name = "\U5929\U5730\U56db\U795e\U4e4b\U9752\U9f99";
//                        number = S100009;
//                    },
//                    {
//                        image = "161108150641547_2a47c918deb237f458c8d36dbc645fc1.jpg";
//                        name = "\U5929\U5730\U56db\U795e\U4e4b\U767d\U864e";
//                        number = S100010;
//                    },
//                    {
//                        image = "161108150642029_9527882911db0813c80bd4b7bc9a3db2.jpg";
//                        name = "\U5929\U5730\U56db\U795e\U4e4b\U6731\U96c0";
//                        number = S100011;
//                    }
//                    );
//themename = "\U82ad\U838e\U7cfb\U5217";
//},

@property (nonatomic,strong) NSMutableArray<BatarCommandSubModel*> * products;
@property (nonatomic,copy) NSString * themename;
@property (nonatomic,copy) NSString * kid;



@end
