//
//  DanmuView.m
//  DanmuTest
//
//  Created by WangChen on 17/6/15.
//  Copyright © 2017年 ChenWang. All rights reserved.
//

#import "DanmuView.h"

@interface DanmuView()

@property (nonatomic, strong) UILabel   *comentLabel;

@end

@implementation DanmuView

- (instancetype)initWithComment:(NSString *)comment {
    
    if(self = [super init])
    {
        
    }
    return self;
}

- (UILabel *)comentLabel {
    
    if(!_comentLabel)
    {
        self.comentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    return _comentLabel;
}
@end
