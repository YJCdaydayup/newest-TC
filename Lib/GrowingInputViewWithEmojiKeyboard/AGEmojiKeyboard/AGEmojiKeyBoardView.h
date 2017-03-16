//
//  AGEmojiKeyboardView.h
//  AGEmojiKeyboard
//
//  Created by Ayush on 09/05/13.
//  Copyright (c) 2013 Ayush. All rights reserved.
//
// Set as inputView to textfields, this view class gives an
// interface to the user to enter emoji characters.

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AGEmojiKeyboardViewCategoryImage) {
  AGEmojiKeyboardViewCategoryImageRecent,
  AGEmojiKeyboardViewCategoryImageFace,
  AGEmojiKeyboardViewCategoryImageBell,
  AGEmojiKeyboardViewCategoryImageFlower,
  AGEmojiKeyboardViewCategoryImageCar,
  AGEmojiKeyboardViewCategoryImageCharacters
};

@protocol AGEmojiKeyboardViewDelegate;
@protocol AGEmojiKeyboardViewDataSource;

/**
 Keyboard class to present as an alternate.
 This keyboard presents the emojis supported by iOS.

 @note To modify appearance, use @p segmentsBar @p pageControl
 @p emojiPagesScrollView properties.
 */
@interface AGEmojiKeyboardView : UIView

/**
 Segment control displays the categories.
 分组控制条
 */
@property (nonatomic, readonly) UISegmentedControl *segmentsBar;

/**
 Pagecontrol displays the current page and number of pages on an emoji page.
 分页
 */
@property (nonatomic, readonly) UIPageControl *pageControl;

/**
 Scroll view displays all the emoji pages.
 */
@property (nonatomic, readonly) UIScrollView *emojiPagesScrollView;

@property (nonatomic, weak) id<AGEmojiKeyboardViewDelegate> delegate;
@property (nonatomic, weak) id<AGEmojiKeyboardViewDataSource> dataSource;

/**
 @param frame Frame of the view to be initialised with.

 @param dataSource dataSource is required during the initialization to
 get all the relevent images to present in the view.
 */
- (instancetype)initWithFrame:(CGRect)frame
                   dataSource:(id<AGEmojiKeyboardViewDataSource>)dataSource;

@end


/**
 Protocol to be followed by the dataSource of `AGEmojiKeyboardView`.
 */
@protocol AGEmojiKeyboardViewDataSource <NSObject>

/**
 选中某分组时显示的标题图片
 Method called on dataSource to get the category image when selected.

 @param emojiKeyBoardView EmojiKeyBoardView object on which user has tapped.

 @param category category to get the image for. @see AGEmojiKeyboardViewCategoryImage
 
 */
- (UIImage *)emojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView
      imageForSelectedCategory:(AGEmojiKeyboardViewCategoryImage)category;

/**
 未选中某分组时显示的标题图片
 Method called on dataSource to get the category image when not-selected.

 @param emojiKeyBoardView EmojiKeyBoardView object on which user has tapped.

 @param category category to get the image for. @see AGEmojiKeyboardViewCategoryImage
 */
- (UIImage *)emojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView
   imageForNonSelectedCategory:(AGEmojiKeyboardViewCategoryImage)category;

/**
 删除按钮的图片
 Method called on dataSource to get the back button image to be shown in the view.

 @param emojiKeyBoardView EmojiKeyBoardView object on which user has tapped.
 */
- (UIImage *)backSpaceButtonImageForEmojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView;

@optional

/**
 默认的分组
 Method called on dataSource to get category that should be shown by
 default i.e. when the keyboard is just presented.

 @note By default `AGEmojiKeyboardViewCategoryImageRecent` is shown.

 @param emojiKeyBoardView EmojiKeyBoardView object shown.
 */
- (AGEmojiKeyboardViewCategoryImage)defaultCategoryForEmojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView;

/**
 最近使用的表情保留多少个
 Method called on dataSource to get number of emojis to be maintained in
 recent category.

 @note By default `50` is used.

 @param emojiKeyBoardView EmojiKeyBoardView object shown.
 */
- (NSUInteger)recentEmojisMaintainedCountForEmojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView;

@end


/**
 Protocol to be followed by the delegate of `AGEmojiKeyboardView`.
 */
@protocol AGEmojiKeyboardViewDelegate <NSObject>

/**
 点击了某个表情
 Delegate method called when user taps an emoji button

 @param emojiKeyBoardView EmojiKeyBoardView object on which user has tapped.

 @param emoji Emoji used by user
 */
- (void)emojiKeyBoardView:(AGEmojiKeyboardView *)emojiKeyBoardView
              didUseEmoji:(NSString *)emoji;

/**
 点击了删除按钮
 Delegate method called when user taps on the backspace button

 @param emojiKeyBoardView EmojiKeyBoardView object on which user has tapped.
 */
- (void)emojiKeyBoardViewDidPressBackSpace:(AGEmojiKeyboardView *)emojiKeyBoardView;

@end
