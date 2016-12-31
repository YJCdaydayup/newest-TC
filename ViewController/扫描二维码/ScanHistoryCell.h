//
//  ScanHistoryCell.h
//  DianZTC
//
//  Created by 杨力 on 30/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBSaveModel.h"

@interface ScanHistoryCell : UITableViewCell

@property (nonatomic,strong) UIImageView * imgView;
@property (nonatomic,strong) UILabel * name;
@property (nonatomic,strong) UILabel * number;
@property (nonatomic,strong) DBSaveModel * model;

@end
