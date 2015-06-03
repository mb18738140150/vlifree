//
//  ClassesViewCell.m
//  vlifree
//
//  Created by 仙林 on 15/5/25.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "ClassesViewCell.h"


#define LABEL_WIDTH 60

@interface ClassesViewCell ()


@property (nonatomic, strong)UILabel * titleLabel;

@end


@implementation ClassesViewCell


- (void)createSubviewWithFrame:(CGRect)frame
{
    if (!_titleLabel) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.7];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, LABEL_WIDTH, 20)];
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;

        _titleLabel.font = [UIFont systemFontOfSize:14];
//        _titleLabel.backgroundColor = [UIColor orangeColor];
//        NSLog(@"===%g", _titleLabel.width);
        [self.contentView addSubview:_titleLabel];
    }
}

+ (CGFloat)cellHeightWithString:(NSString *)string frame:(CGRect)frame
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(LABEL_WIDTH, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, nil] context:nil].size;
//    NSLog(@"%g, %g, %g", frame.size.width, size.width, size.height);
    return size.height + 20;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
    [_titleLabel sizeToFit];
//    [_titleLabel sizeThatFits:CGSizeMake(_titleLabel.width, CGFLOAT_MAX)];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.titleLabel.textColor = [UIColor redColor];
        self.backgroundColor = [UIColor whiteColor];

    }else
    {
        self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.7];
        self.titleLabel.textColor = [UIColor blackColor];
    }
    // Configure the view for the selected state
}

@end
