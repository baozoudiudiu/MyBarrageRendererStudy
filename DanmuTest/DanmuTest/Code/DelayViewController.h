//
//  DelayViewController.h
//  DanmuTest
//
//  Created by chenwang on 2017/6/19.
//  Copyright © 2017年 ChenWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DelayViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIImageView    *imageView;
@property (nonatomic, weak) IBOutlet UISlider       *slider;
@property (nonatomic, weak) IBOutlet UILabel        *startLabel;
@property (nonatomic, weak) IBOutlet UILabel        *stopLabel;

@end
