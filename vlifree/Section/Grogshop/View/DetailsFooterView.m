//
//  DetailsFooterView.m
//  vlifree
//
//  Created by 仙林 on 15/5/22.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "DetailsFooterView.h"

#define LEFT_SPACE 20
#define TOP_SPACE 10
#define LABEL_HEIGHT 30
#define BUTTON_HEIGHT 40
#define BUTTON_VIEW_TOP_SPACE 10

@interface DetailsFooterView ()


@property (nonatomic, strong)UIView * explainView;

@end


@implementation DetailsFooterView





- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubview];
    }
    return self;
}



- (void)createSubview
{
    self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.7];
    self.allButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _allButton.frame = CGRectMake(0, 0, self.width, BUTTON_HEIGHT);
    [_allButton setTitle:@"展开全部房型" forState:UIControlStateNormal];
    [_allButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_allButton setTitle:@"折叠全部房型" forState:UIControlStateSelected];
    [_allButton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    _allButton.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.6];
    _allButton.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:0.4].CGColor;
    _allButton.layer.borderWidth = 1;
    [self addSubview:_allButton];
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _allButton.bottom + BUTTON_VIEW_TOP_SPACE - 1, self.width, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.4];
    [self addSubview:lineView];
    self.explainView = [[UIView alloc] initWithFrame:CGRectMake(0, _allButton.bottom + BUTTON_VIEW_TOP_SPACE, self.width, 100)];
    _explainView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_explainView];
}

- (void)setExplainArray:(NSArray *)explainArray
{
    _explainArray = explainArray;
    [_explainView removeAllSubviews];
    if (explainArray.count) {
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, 100, LABEL_HEIGHT)];
        titleLabel.text = @"订房说明";
        titleLabel.font = [UIFont systemFontOfSize:25];
        [_explainView addSubview:titleLabel];
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, titleLabel.bottom + TOP_SPACE, _explainView.width - 2 * LEFT_SPACE, 1.5)];
        lineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.4];
        [_explainView addSubview:lineView];
        for (int i = 0; i < explainArray.count; i++) {
            UILabel * explainLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, lineView.bottom + i * LABEL_HEIGHT, _explainView.width - 2 * LEFT_SPACE, LABEL_HEIGHT)];
            explainLB.text = [explainArray objectAtIndex:i];
            [_explainView addSubview:explainLB];
        }
        _explainView.frame = CGRectMake(_explainView.left, _explainView.top, _explainView.width, 2 + 2 * TOP_SPACE + (explainArray.count + 1) * LABEL_HEIGHT);
        self.frame = CGRectMake(self.left, self.top, self.width, _explainView.bottom + 2);
    }else
    {
        self.frame = CGRectMake(self.left, self.top, self.width, _allButton.bottom + 2);
    }
    self.height = _explainView.bottom + 2;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
