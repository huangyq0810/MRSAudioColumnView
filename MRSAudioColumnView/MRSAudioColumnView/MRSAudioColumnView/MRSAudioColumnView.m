//
//  MRSAudioColumnView.m
//  MRSAudioColumnView
//
//  Created by admin on 13/8/18.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "MRSAudioColumnView.h"

@interface MRSAudioColumnView()

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) NSMutableArray *columnViewArray;
@property (nonatomic,strong) NSMutableArray *soundMeters;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) CGFloat columnViewWidth;
@property (nonatomic,assign) CGFloat columnViewMaxX;
// 重复周期
@property (nonatomic,assign) NSTimeInterval repeatTime;
// 录制总时长
@property (nonatomic,assign) NSTimeInterval totalTime;
// 当前录制时长
@property (nonatomic,assign) NSTimeInterval recordTime;

@end

@implementation MRSAudioColumnView

# pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.soundMeters = [NSMutableArray array];
        self.columnViewArray = [NSMutableArray array];
        // 默认值设置
        self.totalTime = 15.0;
        self.repeatTime = 0.02;
        self.columnViewWidth = 3.0;
        self.recordTime = 0;
        
        [self setupLineView];
    }
    return self;
}

- (void)setupLineView {
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithRed:255/255.0 green:77/255.0 blue:138/255.0 alpha:1.0];
    [self addSubview:self.lineView];
    self.lineView.frame = CGRectMake(0, 0, 1, self.frame.size.height);

    #pragma mark - pointView Setting
    
    CGFloat pointWidth = 3.0;
    
    CGPoint point = self.lineView.center;

    UIView *topPointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pointWidth, pointWidth)];
    topPointView.backgroundColor = self.lineView.backgroundColor;
    topPointView.layer.cornerRadius = pointWidth / 2;
    topPointView.layer.masksToBounds = YES;
    point.y = pointWidth / 2;
    topPointView.center = point;
    
    UIView *bottomPointView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - pointWidth, pointWidth, pointWidth)];
    bottomPointView.backgroundColor = self.lineView.backgroundColor;
    bottomPointView.layer.cornerRadius = pointWidth / 2;
    bottomPointView.layer.masksToBounds = YES;
    point.y = self.frame.size.height - pointWidth / 2;
    bottomPointView.center = point;
    
    [self.lineView addSubview:topPointView];
    [self.lineView addSubview:bottomPointView];
}

# pragma mark - status

- (void)start {
    [self.timer invalidate];
    self.recordTime = 0;
    self.columnViewMaxX = 0;
    [self removeColumnViews];
    self.soundMeters = [NSMutableArray array];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.repeatTime target:self selector:@selector(update) userInfo:nil repeats:YES];
    self.lineView.frame = CGRectMake(0, 0, 1, self.frame.size.height);
    self.lineView.hidden = NO;
}

- (void)cancel {
    [self.timer invalidate];
    [self removeColumnViews];
    self.lineView.hidden = YES;
}

- (void)finish {
    [self.timer invalidate];
}

- (void)update {
    CGFloat width = self.frame.size.width;
    NSUInteger count = self.totalTime / self.repeatTime;
    //计算每次lineView需要滑动的距离
    CGFloat distance = width / count;
    self.lineView.transform = CGAffineTransformTranslate(self.lineView.transform, distance, 0);
    
    // 当lineView的x值大于柱形图最大x值的时候，再次请求数据
    if (self.lineView.frame.origin.x > self.columnViewMaxX) {
        if([self.delegate respondsToSelector:@selector(fetchData)]) {
            CGFloat number = [self.delegate fetchData];
            NSUInteger scale = (self.frame.size.height / 2) / 1; //(self.frame.size.height / 2):view的一半高度为最大值，1：表示录音最大值1
            CGFloat value = number * scale;
            [self.soundMeters addObject:@(value)];
            [self addColumnView:self.soundMeters.count - 1];
        }
    }
    
    // 累加得到录音时间
    self.recordTime += self.repeatTime;
    
    if (self.recordTime < self.totalTime) {
        if ([self.delegate respondsToSelector:@selector(currentTime:totalTime:)]) {
            [self.delegate currentTime:self.recordTime totalTime:self.totalTime];
        }
    } else {
        NSLog(@"-----finish--");
         [self finish];
    }
}

# pragma mark - add & remove

// 删除所有ColumnView
- (void)removeColumnViews {
    while (self.columnViewArray.count > 0) {
        UIView *view = self.columnViewArray.lastObject;
        [view removeFromSuperview];
        [self.columnViewArray removeObject:view];
    }
}

// 增加一个ColumnView
- (void)addColumnView:(NSUInteger)i {
    CGFloat number = [self.soundMeters[i] doubleValue];
    
    CGFloat viewY = (self.frame.size.height) / 2;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * self.columnViewWidth * 2, viewY, self.columnViewWidth, 0)];
    
    view.backgroundColor = [UIColor colorWithRed:107/255.0 green:144/255.0 blue:251/255.0 alpha:1.0];
    view.layer.cornerRadius = self.columnViewWidth;
    view.layer.masksToBounds = YES;
    
    // 执行动画，改变高度
    [UIView animateWithDuration:0.2 animations:^{
        CGFloat viewY = (self.frame.size.height - number * 2) / 2;
        view.frame = CGRectMake(i * self.columnViewWidth * 2, viewY, self.columnViewWidth, number * 2);
    }];
    
    [self addSubview:view];
    [self.columnViewArray addObject:view];
    
    self.columnViewMaxX = view.frame.origin.x + self.columnViewWidth * 2;
}

@end
