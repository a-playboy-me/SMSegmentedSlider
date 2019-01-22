//
//  SMSegmentedSlider.h
//  SMSegmentedSliderDemo
//
//  Created by 景彧 on 2018/12/24.
//  Copyright © 2018 景彧. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMSegmentedSlider : UIControl

/**
 滑块当前所在index
 */
@property (nonatomic, assign) NSInteger index;

/**
 分段点的个数，至少2个点（头和尾）
 */
@property (nonatomic, assign) NSInteger numberOfItems;

/**
 滑块的颜色
 */
@property (nonatomic, strong) UIColor *thumbColor;

/**
 滑块的背景图片
 */
@property (nonatomic, strong) UIImage *thumbImage;

/**
 滑块的尺寸
 */
@property (nonatomic, assign) CGSize thumbSize;

/**
 分段点的尺寸
 */
@property (nonatomic, assign) CGSize itemSize;

/**
 分段点的颜色
 */
@property (nonatomic, strong) UIColor *itemColor;

/**
 分段点的标题
 */
@property (nonatomic, strong) NSArray<NSString *> *itemTitles;

/**
 分段点的位置，默认在滑杆上
 */
@property (nonatomic, assign) CGPoint position;

/**
 滑杆的高度
 */
@property (nonatomic, assign) CGFloat sliderHeight;

/**
 滑杆的颜色
 */
@property (nonatomic, strong) UIColor *sliderColor;

@end

NS_ASSUME_NONNULL_END
