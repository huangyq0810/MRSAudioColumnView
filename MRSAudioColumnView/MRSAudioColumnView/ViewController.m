//
//  ViewController.m
//  MRSAudioColumnView
//
//  Created by admin on 13/8/18.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ViewController.h"
#import "MRSAudioColumnView.h"

@interface ViewController ()<MRSAudioColumnViewDelegate>

@property (nonatomic, strong) MRSAudioColumnView *audioColumnView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.audioColumnView = [[MRSAudioColumnView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 140)];
    [self.view addSubview:self.audioColumnView];
    self.audioColumnView.center = self.view.center;
    self.audioColumnView.delegate = self;
    self.audioColumnView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
}

- (IBAction)click:(id)sender {
    [self.audioColumnView start];
}

- (IBAction)cancel:(id)sender {
    [self.audioColumnView cancel];
}

#pragma mark - MRSAudioColumnViewDelegate

- (CGFloat)fetchData {
    // test
    // 获取从0到1的随机数
    #define ARC4RANDOM_MAX      0x100000000
    double val = ((double)arc4random() / ARC4RANDOM_MAX);
    return val;
}

- (void)currentTime:(NSTimeInterval)recordTime totalTime:(NSTimeInterval)totalTime {
    NSLog(@"----currentTime----%f----totalTime----%f----",recordTime,totalTime);
}

@end
