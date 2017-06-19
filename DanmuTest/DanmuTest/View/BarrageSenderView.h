//
//  BarrageSenderView.h
//  DanmuTest
//
//  Created by WangChen on 17/6/18.
//  Copyright © 2017年 ChenWang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SendBarrageType) {
    SendBarrageTypeRightToLeft,
    SendBarrageTypeTopToBottom,
    SendBarrageTypeBottomToTop,
};

@interface BarrageSenderView : UIView

@property (nonatomic, strong, readonly) UIColor *textColor;
@property (nonatomic, assign, readonly) SendBarrageType barrageStyle;

@property (nonatomic, weak) IBOutlet UITextField    *textField;
@end
