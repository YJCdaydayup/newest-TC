//
//  ProductCell.h
//  DianZTC
//
//  Created by 杨力 on 5/5/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BatarCommandSubModel.h"

typedef void(^ClickImageBlock)(NSString *number);

@interface ProductCell : UITableViewCell

@property (nonatomic,copy) ClickImageBlock block;

-(void)configCellWithModel:(BatarCommandSubModel *)leftModel rightModel:(id)obj;
-(void)clickImageForDetai:(ClickImageBlock)block;

@end
