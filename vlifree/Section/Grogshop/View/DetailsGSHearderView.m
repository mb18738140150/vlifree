//
//  DetailsGSHearderView.m
//  vlifree
//
//  Created by 仙林 on 15/5/22.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "DetailsGSHearderView.h"
#import "CycleScrollView.h"
#import "DescribeView.h"



#define CYCLESCROLLVIEW_HEIGHT 150
#define DESCRIBEVIEW_HEIGHT 50
#define LABEL_HEIGHT 30

#define IMAGE_SIZE 15

@interface DetailsGSHearderView ()


@property (nonatomic, strong)CycleScrollView * cycleScrollView;//轮播图



@property (nonatomic, strong)UIImageView * wifiView;
@property (nonatomic, strong)UIImageView * parkView;
@property (nonatomic, strong)UIImageView * foodView;


@end


@implementation DetailsGSHearderView




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
    self.cycleScrollView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, CYCLESCROLLVIEW_HEIGHT) array:nil animationDuration:3];
//    _cycleScrollView.backgroundColor = [UIColor greenColor];
    _cycleScrollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_cycleScrollView];
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _cycleScrollView.height - 1, self.width, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.4];
    [self addSubview:lineView];
    self.addressView = [[DescribeView alloc] initWithFrame:CGRectMake(0, _cycleScrollView.bottom, self.width, DESCRIBEVIEW_HEIGHT)];
    _addressView.iconView.image = [UIImage imageNamed:@"addressIcon.png"];
    _addressView.titleLable.text = @"新环西路56号高新工业园区1号楼";
    _addressView.backgroundColor = [UIColor whiteColor];
//    _addressView.backgroundColor = [UIColor orangeColor];
    [self addSubview:_addressView];
    self.phoneView = [[DescribeView alloc] initWithFrame:CGRectMake(0, _addressView.bottom, self.width, DESCRIBEVIEW_HEIGHT)];
    _phoneView.iconView.image = [UIImage imageNamed:@"phoneIcon.png"];
    _phoneView.titleLable.text = @"18530053345";
    _phoneView.backgroundColor = [UIColor whiteColor];
//    _phoneView.backgroundColor = [UIColor magentaColor];
    [self addSubview:_phoneView];
    
    UIView * labelView = [[UIView alloc] initWithFrame:CGRectMake(0, _phoneView.bottom, self.width, DESCRIBEVIEW_HEIGHT)];
    labelView.backgroundColor = [UIColor whiteColor];
    [self addSubview:labelView];
    
    UILabel * aLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 80, LABEL_HEIGHT)];
    aLabel.text = @"查看详情";
    [labelView addSubview:aLabel];
    
    self.wifiView = [[UIImageView alloc] initWithFrame:CGRectMake(aLabel.right, (labelView.height - IMAGE_SIZE) / 2, IMAGE_SIZE, IMAGE_SIZE)];
    _wifiView.image = [UIImage imageNamed:@"wifi_on.png"];
    [labelView addSubview:_wifiView];
    
    
    self.parkView = [[UIImageView alloc] initWithFrame:CGRectMake(_wifiView.right, _wifiView.top, IMAGE_SIZE, IMAGE_SIZE)];
    _parkView.image = [UIImage imageNamed:@"P_on.png"];
    [labelView addSubview:_parkView];
    
    self.foodView = [[UIImageView alloc] initWithFrame:CGRectMake(_parkView.right, _wifiView.top, IMAGE_SIZE, IMAGE_SIZE)];
    _foodView.image = [UIImage imageNamed:@"food_on.png"];
    [labelView addSubview:_foodView];
    
    
    UIView * bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, labelView.bottom, self.width, 1)];
    bottomLineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.7];
    [self addSubview:bottomLineView];
    
    self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.6];
    
    
    
}


- (void)setCycleViews:(NSArray *)cycleViews
{
    _cycleViews = cycleViews;
    _cycleScrollView.page.numberOfPages = cycleViews.count;
    _cycleScrollView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return cycleViews[pageIndex];
    };
    _cycleScrollView.totalPagesCount = ^NSInteger(void){
        return cycleViews.count;
    };

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
