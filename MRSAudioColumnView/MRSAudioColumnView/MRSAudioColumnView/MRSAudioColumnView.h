//
//  MRSAudioColumnView.h
//  MRSAudioColumnView
//
//  Created by admin on 13/8/18.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MRSAudioColumnViewDelegate <NSObject>

@required
- (CGFloat)fetchData;
- (void)currentTime:(NSTimeInterval)recordTime totalTime:(NSTimeInterval)totalTime;

@end

@interface MRSAudioColumnView : UIView

@property (nonatomic,weak) id<MRSAudioColumnViewDelegate> delegate;

- (void)start;
- (void)cancel;
- (void)finish;

@end
