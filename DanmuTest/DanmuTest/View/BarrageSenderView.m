//
//  BarrageSenderView.m
//  DanmuTest
//
//  Created by WangChen on 17/6/18.
//  Copyright © 2017年 ChenWang. All rights reserved.
//

#import "BarrageSenderView.h"

@interface BarrageSenderView()

@property (nonatomic, strong) UIButton          *currentColorBtn;
@property (nonatomic, strong) UIButton          *currentStyleBtn;

@property (nonatomic, weak) IBOutlet UIButton   *defaultColorBtn;
@property (nonatomic, weak) IBOutlet UIButton   *defaultStyleBtn;

@end

@implementation BarrageSenderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    
    frame.size.height = self.frame.size.height;
    
    self.frame = frame;
    
    [self colorBtnSelected:self.defaultColorBtn];
    [self colorBtnSelected:self.defaultStyleBtn];
    
    self.currentColorBtn = self.defaultColorBtn;
    self.currentStyleBtn = self.defaultStyleBtn;
    
    _textColor = [UIColor blueColor];
    
    return self;
}

- (IBAction)selectColorButtonClick:(UIButton *)sender {
    
    [self colorBtnCancelSelected:self.currentColorBtn];
    
    _textColor = sender.backgroundColor;
    
    [self colorBtnSelected:sender];
    
    self.currentColorBtn = sender;
}

- (IBAction)selectBarrageStyleButtonClick:(UIButton *)sender {
    
    _barrageStyle = sender.tag;
    
    [self colorBtnCancelSelected:self.currentStyleBtn];
    
    [self colorBtnSelected:sender];
    
    self.currentStyleBtn = sender;
}

- (void)colorBtnSelected:(UIButton *)sender {
    
    sender.layer.cornerRadius = 2.0;
    sender.layer.borderColor = [UIColor blackColor].CGColor;
    sender.layer.borderWidth = 1.0;
    
}

- (void)colorBtnCancelSelected:(UIButton *)sender {
    sender.layer.cornerRadius = 0;
    sender.layer.borderColor = [UIColor clearColor].CGColor;
    sender.layer.borderWidth = 0;
}

@end
