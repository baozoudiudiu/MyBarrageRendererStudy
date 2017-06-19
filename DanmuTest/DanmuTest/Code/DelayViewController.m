//
//  DelayViewController.m
//  DanmuTest
//
//  Created by chenwang on 2017/6/19.
//  Copyright © 2017年 ChenWang. All rights reserved.
//

#import "DelayViewController.h"

#import <BarrageRenderer.h>

#import "BarrageSenderView.h"

@interface DelayViewController ()<BarrageRendererDelegate, UITextFieldDelegate>

@property (nonatomic, strong) BarrageRenderer           *renderer;

@property (nonatomic, strong) NSTimer                   *timer;
@property (nonatomic, assign) NSTimeInterval            totalTimeInterval;
@property (nonatomic, assign) NSInteger                 changeTimeInterval;

@property (nonatomic, strong) NSDate                    *startDate;
@property (nonatomic, strong) BarrageSenderView         *senderView;

@property (nonatomic, strong) NSMutableArray            *barrageArr;
@end

@implementation DelayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.totalTimeInterval = 100;
    self.changeTimeInterval = 0;
    
    //键盘弹出通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.barrageArr = [NSMutableArray array];
    
    [self setUpRenderer];
    [self setUpSlider];
}

- (void)setUpRenderer {
    
    self.renderer = [[BarrageRenderer alloc] init];
    self.renderer.delegate = self;
    self.renderer.redisplay = YES;
    
    [self.imageView addSubview:self.renderer.view];
    [self.imageView sendSubviewToBack:self.renderer.view];
}

- (void)setUpSlider {
    
    [self.slider setValue:0 animated:YES];
    self.startLabel.text = @"0";
    self.stopLabel.text = [@(self.totalTimeInterval) stringValue];
    [self.slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - < Logic Helper >
///滑块值变化监听
- (void)valueChanged:(UISlider *)sender {
    
    self.changeTimeInterval = [@(self.totalTimeInterval * sender.value) integerValue];
    self.startLabel.text = [NSString stringWithFormat:@"%ld", self.changeTimeInterval];
}

- (void)loadBarrages {
    
    NSInteger const number = self.totalTimeInterval;
    NSMutableArray * descriptors = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < number; i++) {
        
        if(i % 2 == 0) {
            NSInteger delay = i;
            [descriptors addObject:[self walkTextSpriteDescriptorWithDelay:delay]];
        }
    }
    self.barrageArr = descriptors;
    [_renderer load:descriptors];
}

#pragma mark -
#pragma mark - -- < TextFieldDelegate >
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self stopSenderBarrage];
    
    return YES;
}

///开始发送弹幕逻辑
- (void)startSenderBarrage {
    
    [self.senderView.textField becomeFirstResponder];
}

///发送弹幕逻辑
- (void)stopSenderBarrage {
    
    [self.senderView.textField resignFirstResponder];
    
    if(self.senderView.textField.text != nil
       && ![self.senderView.textField.text isEqualToString:@""]
       && self.senderView.textField.text.length > 0) {
        BarrageDescriptor *descriptor = [[BarrageDescriptor alloc] init];
//        
        if(self.senderView.barrageStyle == SendBarrageTypeRightToLeft) {
            
            descriptor = [self sendWalkTextSpriteDescriptorWithDelay:3];///<立即发送,可能时间已经走过了,延时3秒

        }else {
            
            NSInteger deriction = self.senderView.barrageStyle == SendBarrageTypeTopToBottom ? BarrageFloatDirectionT2B : BarrageFloatDirectionB2T;
            
            descriptor = [self floatTextSpriteDescriptorWithDelay:3 direction:deriction];///<立即发送,可能时间已经走过了,延时3秒
        }
        
        [self.renderer receive:descriptor];
    }
}

///键盘监听
- (void)keyboardChanged:(NSNotification *)notify {
    
    CGRect frame = [[notify.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat reduce = CGRectGetHeight([UIScreen mainScreen].bounds) - frame.origin.y;
    
    if(reduce > 0)
        reduce += 70;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.senderView.transform = CGAffineTransformMakeTranslation(0, -reduce);
        
    } completion:^(BOOL finished) {
        
    }];
}

/// 生成精灵描述 - 延时文字弹幕
- (BarrageDescriptor *)walkTextSpriteDescriptorWithDelay:(NSTimeInterval)delay
{
    static NSInteger index = 0;
    
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"text"] = [NSString stringWithFormat:@"弹幕出现时间:(延时%.0f秒):%ld", delay,(long)index++];
    descriptor.params[@"textColor"] = [UIColor blueColor];
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(1);
    descriptor.params[@"delay"] = @(delay);
    return descriptor;
}

- (BarrageDescriptor *)sendWalkTextSpriteDescriptorWithDelay:(NSTimeInterval)delay
{
    NSLog(@">>>>>>%f", delay + self.changeTimeInterval);
    
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"text"] = [NSString stringWithFormat:@"%@(延时%.0f秒)",self.senderView.textField.text ,delay + self.changeTimeInterval];
    descriptor.params[@"textColor"] = self.senderView.textColor;
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(1);
    descriptor.params[@"borderColor"] = [UIColor blueColor];
    descriptor.params[@"borderWidth"] = @(1);
    descriptor.params[@"cornerRadius"] = @(2);
    descriptor.params[@"delay"] = @(delay);
    return descriptor;
}

- (BarrageDescriptor *)floatTextSpriteDescriptorWithDelay:(NSTimeInterval)delay direction:(NSInteger)direction {
    
    NSLog(@">>>>>>%f", delay + self.changeTimeInterval);
    
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageFloatTextSprite class]);
    descriptor.params[@"text"] = self.senderView.textField.text;
    descriptor.params[@"textColor"] = self.senderView.textColor;
    descriptor.params[@"duration"] = @(3);
    descriptor.params[@"fadeInTime"] = @(0);
    descriptor.params[@"fadeOutTime"] = @(0);
    descriptor.params[@"direction"] = @(direction);
    descriptor.params[@"side"] = @(0);
    descriptor.params[@"borderColor"] = [UIColor blueColor];
    descriptor.params[@"borderWidth"] = @(1);
    descriptor.params[@"cornerRadius"] = @(2);
    descriptor.params[@"delay"] = @(delay);
    return descriptor;
}

#pragma mark - <BarrageRendererDelegate>
- (NSTimeInterval)timeForBarrageRenderer:(BarrageRenderer *)renderer {

    return self.changeTimeInterval;
}

#pragma mark - < 事件响应 >
- (IBAction)buttonClick:(UIButton *)sender {
    
    switch (sender.tag) {
        case 0:
            //加载
        {
            [self loadBarrages];
        }
            break;
        case 1:
            //开始
        {
            self.startDate = [NSDate date];
            [self.renderer start];
            
            __weak typeof (&*self) weakSelf = self;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
               
                weakSelf.changeTimeInterval += 1;
                
                if(weakSelf.changeTimeInterval >= self.totalTimeInterval + 1) {
                    
                    [weakSelf.timer setFireDate:[NSDate distantFuture]];
                    [weakSelf.timer invalidate];
                    weakSelf.timer = nil;
                }else {
                    weakSelf.startLabel.text = [@(weakSelf.changeTimeInterval) stringValue];
                    [weakSelf.slider setValue:weakSelf.changeTimeInterval / weakSelf.totalTimeInterval animated:NO];
                }
            }];
            [self.timer setFireDate:[NSDate distantPast]];
        }
            break;
        case 2:
            //暂停
        {
            [self.renderer pause];
            [self.timer setFireDate:[NSDate distantFuture]];
        }
            break;
        case 3:
        {
            [self.renderer stop];
            [self.timer setFireDate:[NSDate distantFuture]];
            [self.timer invalidate];
            self.timer = nil;
            self.changeTimeInterval = 0;
            self.startLabel.text = [@(self.changeTimeInterval) stringValue];
            [self.slider setValue:self.changeTimeInterval / self.totalTimeInterval animated:NO];
        }
            //结束
            break;
        default:
            break;
    }
}

- (IBAction)senderBarrage:(id)sender {
    
    [self startSenderBarrage];
}

///发送弹幕编辑控件
- (BarrageSenderView *)senderView {
    
    if(!_senderView) {
        
        CGFloat height = 70;
        
        self.senderView = [[BarrageSenderView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds), CGRectGetWidth([UIScreen mainScreen].bounds), height)];
        
        _senderView.textField.delegate = self;
        
        [self.view addSubview:_senderView];
        
        _senderView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    }
    return _senderView;
}

@end
