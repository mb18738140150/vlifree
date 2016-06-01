//
//  TakeoutTypeView.m
//  vlifree
//
//  Created by 仙林 on 16/4/7.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "TakeoutTypeView.h"

#define LEFT_SPACE 20
#define TOP_SPACE 10
#define IMAGE_HEIGHT 10
#define FONT_LABEL [UIFont systemFontOfSize:15]
#define BUTTON_SIZE 30

@interface TakeoutTypeView ()
@property (nonatomic, copy)ScreenBlock myBloclk;
@end

@implementation TakeoutTypeView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubviews];
        [self addObserver:self forKeyPath:@"self.titleBT.selected" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}
- (void)creatSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    self.titleBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.titleBT.frame = CGRectMake(LEFT_SPACE - 5, TOP_SPACE, self.width - 2 * LEFT_SPACE, BUTTON_SIZE);
    [self.titleBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.titleBT setTitleColor:BACKGROUNDCOLOR forState:UIControlStateSelected];
    _titleBT.backgroundColor = [UIColor whiteColor];
    _titleBT.titleLabel.font = FONT_LABEL;
    [_titleBT addTarget:self action:@selector(shouTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_titleBT];
    
    self.stateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_titleBT.right, LEFT_SPACE, IMAGE_HEIGHT, IMAGE_HEIGHT)];
    self.stateImageView.image = [UIImage imageNamed:@"state_down.png"];
    self.stateImageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_stateImageView];
    
}

- (void)shouTypeAction:(UIButton *)button
{
    button.selected = !button.selected;
    
    _myBloclk(button.selected);
    
}

- (void)screenAction:(ScreenBlock)block
{
    _myBloclk = [block copy];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
//    NSLog(@"***%@", change);
    
    if ([[change objectForKey:@"new"] boolValue]) {
        
        // 选中状态
        
        if ([_stateImageView.image isEqual:[UIImage imageNamed:@"back_r_top.png"]]) {
            ;
        }else
        {
            
            [UIView animateWithDuration:.3 animations:^{
                _stateImageView.transform = CGAffineTransformRotate(_stateImageView.transform, M_PI);
            } completion:^(BOOL finished) {
                
                if (finished) {
//                    NSLog(@"成功");
                }else
                {
//                    NSLog(@"失败");
                }
                
                _stateImageView.image = [UIImage imageNamed:@"back_r_top.png"];
                
            }];
        }
        
    }else
    {
        if ([_stateImageView.image isEqual:[UIImage imageNamed:@"state_down.png"]]) {
            ;
        }else
        {
            [UIView animateWithDuration:.3 animations:^{
                _stateImageView.transform = CGAffineTransformRotate(_stateImageView.transform, M_PI);
            } completion:^(BOOL finished) {
                
                if (finished) {
//                    NSLog(@"成功");
                }else
                {
//                    NSLog(@"失败");
                }
                self.stateImageView.image = [UIImage imageNamed:@"state_down.png"];
            }];
        }
    }
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"self.titleBT.selected"];
}

@end
