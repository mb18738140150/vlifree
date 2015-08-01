//
//  DetailsGSHearderView.m
//  vlifree
//
//  Created by 仙林 on 15/5/22.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "DetailsGSHearderView.h"
#import "AutoSlideScrollView.h"
#import "DescribeView.h"



#define CYCLESCROLLVIEW_HEIGHT 150
#define DESCRIBEVIEW_HEIGHT 40
#define LABEL_HEIGHT 20

#define IMAGE_SIZE 10

@interface DetailsGSHearderView ()


@property (nonatomic, strong)AutoSlideScrollView * cycleScrollView;//轮播图






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
    
    self.cycleScrollView = [[AutoSlideScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, CYCLESCROLLVIEW_HEIGHT) animationDuration:3];
    _cycleScrollView.backgroundColor = [UIColor redColor];
    [self addSubview:_cycleScrollView];
    
//    self.hotelImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, CYCLESCROLLVIEW_HEIGHT)];
//    [self addSubview:_hotelImage];
    
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _cycleScrollView.height - 1, self.width, 1)];
    lineView.backgroundColor = LINE_COLOR;
    [self addSubview:lineView];
    self.addressView = [[DescribeView alloc] initWithFrame:CGRectMake(0, _cycleScrollView.bottom, self.width, DESCRIBEVIEW_HEIGHT)];
    _addressView.iconView.image = [UIImage imageNamed:@"addressIcon.png"];
//    _addressView.titleLable.text = @"新环西路56号高新工业园区1号楼";
    
    _addressView.backgroundColor = [UIColor whiteColor];
//    _addressView.backgroundColor = [UIColor orangeColor];
    [self addSubview:_addressView];
    self.phoneView = [[DescribeView alloc] initWithFrame:CGRectMake(0, _addressView.bottom, self.width, DESCRIBEVIEW_HEIGHT)];
    _phoneView.iconView.image = [UIImage imageNamed:@"phoneIcon.png"];
//    _phoneView.titleLable.text = @"18530053345";
    _phoneView.backgroundColor = [UIColor whiteColor];
//    _phoneView.backgroundColor = [UIColor magentaColor];
    [self addSubview:_phoneView];
    
    
    
    UIView * labelView = [[UIView alloc] initWithFrame:CGRectMake(0, _phoneView.bottom, self.width, DESCRIBEVIEW_HEIGHT)];
    labelView.backgroundColor = [UIColor whiteColor];
    [self addSubview:labelView];
    
    UILabel * aLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 80, LABEL_HEIGHT)];
    aLabel.text = @"查看详情";
    aLabel.textColor = TEXT_COLOR;
    aLabel.font = [UIFont systemFontOfSize:14];
    [labelView addSubview:aLabel];
    
    self.wifiView = [[UIImageView alloc] initWithFrame:CGRectMake(aLabel.right + 5, (labelView.height - IMAGE_SIZE) / 2, IMAGE_SIZE, IMAGE_SIZE)];
    _wifiView.image = [UIImage imageNamed:@"wifi_on.png"];
    [labelView addSubview:_wifiView];
    
    
    self.parkView = [[UIImageView alloc] initWithFrame:CGRectMake(_wifiView.right + 5, _wifiView.top, IMAGE_SIZE, IMAGE_SIZE)];
    _parkView.image = [UIImage imageNamed:@"P_on.png"];
    [labelView addSubview:_parkView];
    
    self.foodView = [[UIImageView alloc] initWithFrame:CGRectMake(_parkView.right + 5, _wifiView.top, IMAGE_SIZE, IMAGE_SIZE)];
    _foodView.image = [UIImage imageNamed:@"food_on.png"];
    [labelView addSubview:_foodView];
    
    self.detailsBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _detailsBT.frame = CGRectMake(0, _phoneView.bottom, self.width, DESCRIBEVIEW_HEIGHT);
//    _detailsBT.backgroundColor = [UIColor whiteColor];
    [self addSubview:_detailsBT];
    
    UIView * bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, labelView.bottom, self.width, 1)];
    bottomLineView.backgroundColor = LINE_COLOR;
//    [self addSubview:bottomLineView];
    
    self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.4];
    
    
    
}


- (void)setIconUrlStingAry:(NSArray *)iconUrlStingAry
{
    _iconUrlStingAry = iconUrlStingAry;
    NSMutableArray * viewsAry = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < iconUrlStingAry.count; i++) {
        UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDHT, CYCLESCROLLVIEW_HEIGHT)];
        imageV.backgroundColor = [UIColor greenColor];
        __weak UIImageView * iconV = imageV;
        [imageV setImageWithURL:[NSURL URLWithString:[iconUrlStingAry objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"placeholderIM.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (error) {
                iconV.image = [UIImage imageNamed:@"load_fail.png"];
            }
        }];
        [viewsAry addObject:imageV];
    }
    self.cycleScrollView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return [viewsAry objectAtIndex:pageIndex];
    };
    self.cycleScrollView.totalPagesCount = ^NSInteger(void){
        return viewsAry.count;
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
