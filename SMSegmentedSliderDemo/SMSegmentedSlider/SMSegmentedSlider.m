//
//  SMSegmentedSlider.m
//  SMSegmentedSliderDemo
//
//  Created by 景彧 on 2018/12/24.
//  Copyright © 2018 景彧. All rights reserved.
//

#import "SMSegmentedSlider.h"

@interface SMSegmentedSlider ()
@property (nonatomic, assign) CGRect thumbFrame; // 滑块
@property (nonatomic, assign) CGRect sliderFrame; // 滑杆
@property (nonatomic, strong) NSMutableArray *itemFrameArray; // 分段点数组
@property (nonatomic, strong) NSDictionary *itemTitleAttributes;
@property (nonatomic, assign) BOOL isFirstLaunch;
@end

@implementation SMSegmentedSlider

@synthesize isFirstLaunch, index, numberOfItems, thumbColor, sliderHeight, itemSize, thumbSize, position, sliderColor, itemColor, thumbImage;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialized];
    }
    return self;
}

- (void)initialized {
    isFirstLaunch = YES;
    numberOfItems = 2;
    index = 0;
    sliderHeight = 20;
    thumbSize = CGSizeMake(sliderHeight, sliderHeight);
    position = CGPointZero;
    itemSize = thumbSize;
}

#pragma mark -

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawSliderWithContext:context];
    
    [self drawThumbWithContext:context];
    
}

- (void)drawSliderWithContext:(CGContextRef)context {
    CGFloat width = thumbSize.width > itemSize.width ? thumbSize.width : itemSize.width;
    CGFloat height = thumbSize.height > itemSize.height ? thumbSize.height : itemSize.height;
    
    CGFloat sliderMargin = sliderHeight * 0.5 + width * 0.5;
    CGFloat sliderY = CGRectGetHeight(self.frame) * 0.5;
    CGFloat sliderWidth = CGRectGetWidth(self.frame) - 2 * sliderMargin - width;
    self.sliderFrame = CGRectMake(sliderMargin + itemSize.width * 0.5, sliderY - height * 0.5, sliderWidth + width, height);
    
    // 绘制slider滑杆
    CGPoint startPoint = CGPointMake(sliderMargin + width * 0.5, sliderY);
    CGPoint endPoint = CGPointMake(CGRectGetWidth(self.frame) - sliderMargin - width * 0.5, sliderY);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextSetLineWidth(context, sliderHeight);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(context, sliderColor.CGColor);
    CGContextStrokePath(context);
    
    // 滑杆上的分段点item
    CGFloat itemWidth = itemSize.width;
    CGFloat itemHeight = itemSize.height;
    CGFloat itemY = CGRectGetHeight(self.frame) * 0.5 - itemSize.height * 0.5;
    [self.itemFrameArray removeAllObjects];
    
    for (NSInteger idx = 0; idx < numberOfItems; idx++) {
        CGFloat itemX = idx * sliderWidth / (numberOfItems - 1) + startPoint.x - itemWidth * 0.5;
        CGContextAddEllipseInRect(context, CGRectMake(itemX, itemY, itemWidth, itemHeight));
        [itemColor set];
        CGContextFillPath(context);
        
        // 计算滑块的位置
        CGRect frame = CGRectMake(itemX + itemWidth * 0.5 - thumbSize.width * 0.5,
                                  itemY + itemHeight * 0.5 - thumbSize.height * 0.5,
                                  thumbSize.width,
                                  thumbSize.height);
        [self.itemFrameArray addObject:[NSValue valueWithCGRect:frame]];
    }
    
    // 画分段点名称itemTitle
    for (NSInteger idx = 0; idx < self.itemTitles.count; idx++) {
        NSString *title = [self.itemTitles objectAtIndex:idx];
        CGRect itemFrame = [[self.itemFrameArray objectAtIndex:idx] CGRectValue];
        CGSize size = [title sizeWithAttributes:self.itemTitleAttributes];
        CGFloat titleX = itemFrame.origin.x + itemFrame.size.width * 0.5 - size.width * 0.5 + position.x;
        CGFloat titleY = itemFrame.origin.y + position.y;
        CGRect titleFrame = CGRectMake(titleX, titleY, size.width, size.height);
        [title drawInRect:titleFrame withAttributes:self.itemTitleAttributes];
    }
    
}

- (void)drawThumbWithContext:(CGContextRef)context {
    if (isFirstLaunch) {
        isFirstLaunch = NO;
        self.thumbFrame = [self.itemFrameArray.firstObject CGRectValue];
    }
    
    if (thumbImage) {
        [thumbImage drawInRect:self.thumbFrame];
    }
    else {
        CGContextAddEllipseInRect(context, self.thumbFrame);
        [thumbColor set];
        CGContextFillPath(context);
    }
}

#pragma mark - Events

//- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
//    CGPoint touchPoint = [touch locationInView:self];
//    
//    if (!CGRectContainsPoint(self.sliderFrame, touchPoint)) {
//        return NO;
//    }
//    else {
//        CGFloat x = touchPoint.x;
//        NSInteger idx = [self getItemIndexWithHorizontalX:x];
//        self.thumbFrame = [[self.itemFrameArray objectAtIndex:idx] CGRectValue];
//        [self setNeedsDisplay];
//        return YES;
//    }
//}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touch locationInView:self];
    CGFloat thumbImageX = touchPoint.x - thumbSize.width * 0.5;
    self.thumbFrame = CGRectMake(thumbImageX, self.thumbFrame.origin.y, self.thumbFrame.size.width, self.thumbFrame.size.height);
    [self setNeedsDisplay];
    
    return YES;
}

//拖动结束
- (void)endTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event {
    CGPoint touchPoint = [touch locationInView:self];
    NSInteger idx = [self getItemIndexWithHorizontalX:touchPoint.x];
    self.thumbFrame = [[self.itemFrameArray objectAtIndex:idx] CGRectValue];
    [self setNeedsDisplay];
    //增加控制事件
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (NSInteger)getItemIndexWithHorizontalX:(CGFloat)x {
    // 边界问题
    CGFloat maxX = [[self.itemFrameArray lastObject] CGRectValue].origin.x;
    CGFloat minX = [[self.itemFrameArray firstObject] CGRectValue].origin.x;
    CGFloat tempX = x - minX;
    if (tempX > maxX) {
        tempX = maxX;
    }
    CGFloat width = maxX - minX;
    CGFloat count = width / (numberOfItems - 1);
    CGFloat persent = (thumbSize.width * 0.5) / count;
    NSInteger idx = tempX/ count - persent + 0.5;
    index = idx;
    return idx;
}

#pragma mark -

- (NSMutableArray *)itemFrameArray {
    if (!_itemFrameArray) {
        _itemFrameArray = [NSMutableArray array];
    }
    return _itemFrameArray;
}

- (NSDictionary *)itemTitleAttributes {
    if (!_itemTitleAttributes) {
        _itemTitleAttributes = @{
                                 NSForegroundColorAttributeName : [UIColor blackColor],
                                 NSFontAttributeName : [UIFont systemFontOfSize:14.0]
                                 };
    }
    return _itemTitleAttributes;
}

// item个数至少2个
- (void)setNumberOfItems:(NSInteger)items {
    numberOfItems = items > 1 ? items : 2;
}

@end
