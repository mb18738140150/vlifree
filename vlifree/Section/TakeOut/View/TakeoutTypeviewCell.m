//
//  TakeoutTypeviewCell.m
//  vlifree
//
//  Created by 仙林 on 16/4/7.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "TakeoutTypeviewCell.h"

@implementation TakeoutTypeviewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatSubviews];
    }
    return self;
}
- (void)creatSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    
    
    self.iconImageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, (self.height - 20) / 2, 20, 20)];
    self.iconImageview.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_iconImageview];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_iconImageview.right + 10, (self.height - 15) / 2, self.width - 90, 15)];
    self.titleLabel.backgroundColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    if (self.selected) {
        self.titleLabel.textColor = BACKGROUNDCOLOR;
    }else
    {
        self.titleLabel.textColor = [UIColor blackColor];
    }
    [self.contentView addSubview:_titleLabel];
    
    self.selectStateImageview = [[UIImageView alloc]initWithFrame:CGRectMake(_titleLabel.right, 0, 40, 40)];
    self.selectStateImageview.backgroundColor = [UIColor whiteColor];
    if (self.selected) {
        self.selectStateImageview.image = [UIImage imageNamed:@"check_list.png"];
    }else
    {
        self.selectStateImageview.image = nil;
    }
    [self.contentView addSubview:self.selectStateImageview];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    NSLog(@"%@", self.titleLabel.text);@[@"综合排序", @"销量排序", @"评分排序", @"起送价排序"]
    if (selected ) {
        self.titleLabel.textColor = BACKGROUNDCOLOR;
        self.selectStateImageview.image = [UIImage imageNamed:@"check_list.png"];
        
        if ([self.titleLabel.text isEqualToString:@"综合排序"]) {
            self.iconImageview.image = [UIImage imageNamed:@"container2_icon2_2.png"];
        }else if ([self.titleLabel.text isEqualToString:@"销量排序"]) {
            self.iconImageview.image = [UIImage imageNamed:@"container2_icon4_2.png"];
        }else if ([self.titleLabel.text isEqualToString:@"评分排序"]) {
            self.iconImageview.image = [UIImage imageNamed:@"container2_icon1_2.png"];
        }else if ([self.titleLabel.text isEqualToString:@"起送价排序"]) {
            self.iconImageview.image = [UIImage imageNamed:@"container2_icon3_2.png"];
        }
        
    }else
    {
        self.titleLabel.textColor = [UIColor blackColor];
        self.selectStateImageview.image = nil;
        if ([self.titleLabel.text isEqualToString:@"综合排序"]) {
            self.iconImageview.image = [UIImage imageNamed:@"container2_icon2_1.png"];
        }else if ([self.titleLabel.text isEqualToString:@"销量排序"]) {
            self.iconImageview.image = [UIImage imageNamed:@"container2_icon4_1.png"];
        }else if ([self.titleLabel.text isEqualToString:@"评分排序"]) {
            self.iconImageview.image = [UIImage imageNamed:@"container2_icon1_1.png"];
        }else if ([self.titleLabel.text isEqualToString:@"起送价排序"]) {
            self.iconImageview.image = [UIImage imageNamed:@"container2_icon3_1.png"];
        }
    }
}


@end
