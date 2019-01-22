//
//  ViewController.m
//  SMSegmentedSliderDemo
//
//  Created by 景彧 on 2018/12/24.
//  Copyright © 2018 景彧. All rights reserved.
//

#import "ViewController.h"
#import "SMSegmentedSlider.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    SMSegmentedSlider *slider = [[SMSegmentedSlider alloc] initWithFrame:CGRectMake(0, 50, CGRectGetWidth(self.view.frame), 60)];
    slider.backgroundColor = [UIColor whiteColor];
    slider.sliderHeight = 2;
    slider.numberOfItems = 5;
    slider.sliderColor = UIColor.grayColor;
    //slider.thumbImage = [UIImage imageNamed:@"4.png"];
    slider.thumbColor = UIColor.cyanColor;
    slider.thumbSize = CGSizeMake(20, 20);
    slider.itemSize = CGSizeMake(23, 23);
    slider.itemColor = UIColor.grayColor;
    slider.itemTitles = @[@"0", @"1", @"2", @"3", @"4"];
    slider.position = CGPointMake(0, 20);
    [slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
}

- (void)valueChanged:(SMSegmentedSlider *)sender {
    NSLog(@"current index = %ld", (long)sender.index);
}

@end
