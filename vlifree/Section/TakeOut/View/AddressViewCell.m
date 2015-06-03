//
//  AddressViewCell.m
//  vlifree
//
//  Created by 仙林 on 15/5/29.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "AddressViewCell.h"
#import "AddressModel.h"



@interface AddressViewCell ()

@property (nonatomic, strong)UIImageView * seleteImageView;
@property (nonatomic, strong)UILabel * addressLB;
@property (nonatomic, strong)UILabel * telLabel;



@end




@implementation AddressViewCell



- (void)createSubview:(CGRect)frame
{
    if (!_addressLB) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.seleteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 25, 25)];
//        _seleteImageView.image = [UIImage imageNamed:@"willChange.png"];
        [self.contentView addSubview:_seleteImageView];
        self.addressLB = [[UILabel alloc] initWithFrame:CGRectMake(_seleteImageView.right, 10, frame.size.width - _seleteImageView.right - 10, 25)];
        _addressLB.numberOfLines = 0;
        _addressLB.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_addressLB];
        self.telLabel = [[UILabel alloc] initWithFrame:CGRectMake(_addressLB.left, _addressLB.bottom, _addressLB.width, _addressLB.height)];
        [self.contentView addSubview:_telLabel];
        _seleteImageView.center = CGPointMake(_seleteImageView.centerX, _telLabel.bottom / 2 + 5);
    }
}




- (void)setAddressModel:(AddressModel *)addressModel
{
    _addressModel = addressModel;
//    if (addressModel.selete) {
//        _seleteImageView.image = [UIImage imageNamed:@"willChange.png"];
//    }else
//    {
//        _seleteImageView.image = [UIImage imageNamed:@"didChange.png"];
    
//    }
    self.addressLB.text = [NSString stringWithFormat:@"送餐地址:%@", addressModel.address];
    CGSize size = [_addressLB sizeThatFits:CGSizeMake(_addressLB.width, CGFLOAT_MAX)];
    CGRect addressFram = _addressLB.frame;
    addressFram.size = size;
    _addressLB.frame = addressFram;
    CGRect frame = _telLabel.frame;
    frame.origin.y = _addressLB.bottom;
    _telLabel.frame = frame;
    self.telLabel.text = addressModel.tel;
   
}


+ (CGFloat)cellHeightFrome:(NSString *)address frame:(CGRect)frame
{
    CGSize size = [address boundingRectWithSize:CGSizeMake(frame.size.width - 45, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17], NSFontAttributeName, nil] context:nil].size;
    //    NSLog(@"%g, %g, %g", frame.size.width, size.width, size.height);
    return size.height + 50;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.seleteImageView.image = [UIImage imageNamed:@"didChange.png"];
    }else
    {
        _seleteImageView.image = [UIImage imageNamed:@"willChange.png"];
    }
    // Configure the view for the selected state
}

@end
