//
//  ViewController.m
//  图片点击方法
//
//  Created by ziboow on 16/4/28.
//  Copyright © 2016年 abmas. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIScrollViewDelegate>
/**
 *  显示的图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
/**
 *  背景view
 */
@property (nonatomic, weak) UIScrollView *backgroundView;
/**
 *  存放要被放大的 imageView
 */
@property (nonatomic, weak) UIImageView *originImageView;
/**
 *  放大之前的 imageView 的 frame
 */
@property (nonatomic, assign) CGRect originRect;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showImageView.userInteractionEnabled = YES; //UIImageView开启接收事件
    UITapGestureRecognizer *tapBig = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapZoomIn)]; //点击手势
    [self.showImageView addGestureRecognizer:tapBig];
}
/**
 *  点击原图图片放大
 */
- (void)tapZoomIn {
    self.showImageView.hidden = YES;
    
    UITapGestureRecognizer *tapBack = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapZoomOut)];
    UIScrollView *backgroundView = [[UIScrollView alloc] init]; //背景图
    self.backgroundView = backgroundView;
    backgroundView.frame = [UIScreen mainScreen].bounds;
    backgroundView.backgroundColor = [UIColor whiteColor];
    [backgroundView addGestureRecognizer:tapBack];
    [[UIApplication sharedApplication].keyWindow addSubview:backgroundView];
    
    UIImageView *zoomImageView = [[UIImageView alloc] init]; //要放大的图片
    self.originImageView = zoomImageView;
    zoomImageView.image = self.showImageView.image;
    zoomImageView.frame = [backgroundView convertRect:self.showImageView.frame fromView:self.view]; //将showImageView的坐标系从控制器view上转换到backgroundView 赋给 zoomImageView
    backgroundView.delegate = self;
    backgroundView.maximumZoomScale = 2.0; // 最大的拉伸比例
    [backgroundView addSubview:zoomImageView];
    self.originRect = zoomImageView.frame;
    //改变 zoomImageView 的frame
    [UIView animateWithDuration:0.7 animations:^{
        self.backgroundView.backgroundColor = [UIColor blackColor];
        CGRect frame = zoomImageView.frame;
        frame.size.width = backgroundView.bounds.size.width;
        frame.size.height = frame.size.width * (zoomImageView.frame.size.height / zoomImageView.frame.size.width); // 高 = 宽度 * (高 / 宽)
        frame.origin.x = 0;
        frame.origin.y = (backgroundView.frame.size.height - frame.size.height) * 0.5;
        zoomImageView.frame = frame;
        
    }];
}
/**
 *  点击放大图片回到原始尺寸
 */
- (void)tapZoomOut {
    [UIView animateWithDuration:0.7 animations:^{
        self.originImageView.frame = self.originRect;
        self.backgroundView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self.backgroundView removeFromSuperview]; //在 keywindow 中移除
        self.showImageView.hidden = NO;
        self.originImageView = nil;
        self.backgroundView = nil;
    }];
}

/**
 *  返回的视图可以被拉伸 需要实现 UIScrollView 的代理方法
 *
 *  @param scrollView
 *
 *  @return
 */
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.originImageView;
}

@end










