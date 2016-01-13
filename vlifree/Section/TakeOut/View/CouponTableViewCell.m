//
//  CouponTableViewCell.m
//  vlifree
//
//  Created by 仙林 on 15/10/19.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "CouponTableViewCell.h"

#define TOP_SPACE 10    
#define LEFT_SPACE 10
#define NAMELB_HEIGHT 30
#define DATELB_HEIGHT 20


@implementation CouponTableViewCell


- (void)createSubview:(CGRect)frame
{
    if (!_nameLabel) {
        
        self.imageStateview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 25, 30, 30)];
        _imageStateview.image = [UIImage imageNamed:@"check_list.png"];
        _imageStateview.hidden = YES;
        [self addSubview:_imageStateview];
        
        UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(60, 5, frame.size.width - 100, 1)];
        line1.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self addSubview:line1];
        
        UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(60, 6, 1, 68)];
        line2.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self addSubview:line2];
        
        UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(60, 74, frame.size.width - 100, 1)];
        line3.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self addSubview:line3];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60 + LEFT_SPACE, TOP_SPACE + 5, frame.size.width - 2 * LEFT_SPACE - 120 - 60, 30)];
        [self addSubview:_nameLabel];
        
        self.dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(60 + LEFT_SPACE, _nameLabel.bottom, _nameLabel.width, 28)];
        _dateLabel.textColor = [UIColor grayColor];
        _dateLabel.font = [UIFont systemFontOfSize:12];
        _dateLabel.numberOfLines = 0;
        [self addSubview:_dateLabel];
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(_nameLabel.right, 5, frame.size.width - 60 - LEFT_SPACE - _nameLabel.width -  LEFT_SPACE, 70)];
        imageView.image = [UIImage imageNamed:@"hong_bao_bg.png"];
        [self addSubview:imageView];
        
        self.faceLabel = [[UILabel alloc]init];
        _faceLabel.frame = imageView.frame;
        _faceLabel.textColor = [UIColor whiteColor];
        _faceLabel.font = [UIFont systemFontOfSize:25];
        [self addSubview:_faceLabel];
        
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

- (void)setCouponModel:(CouponModel *)couponModel
{
    self.nameLabel.text = [NSString stringWithFormat:@"%d", couponModel.couponId];
    self.dateLabel.text = [NSString stringWithFormat:@"%@", couponModel.couponDate];
    self.faceLabel.text = [NSString stringWithFormat:@"¥%.2f", couponModel.couponFace];
    self.faceLabel.textAlignment = NSTextAlignmentCenter;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
