//
//  YLScrollerView.h
//  自己写图片浏览器
//
//  Created by 杨力 on 28/7/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YLScrollerViewDelegate <NSObject>

-(void)didClickScrollerImage:(NSInteger)index withImageView:(UIImageView *)imageView withImgArray:(NSMutableArray *)imgArray;;

@end

@interface YLScrollerView : UIView<UIScrollViewDelegate>

@property (nonatomic,strong)  UIScrollView * scollerView;
@property (nonatomic,strong) UIImageView * currentImgView;
@property (nonatomic,strong) NSMutableArray * totalImgArray;
@property (nonatomic,weak) id<YLScrollerViewDelegate>delegate;

+(instancetype)shareImageManager;
-(void)configScrollView:(BOOL)fromTag WithArray:(NSArray*)array;
-(void)clearSubViews;
@end
