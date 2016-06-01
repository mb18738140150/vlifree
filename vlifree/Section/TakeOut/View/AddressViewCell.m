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
        
        self.telLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 10, frame.size.width - 35 - 100, 25)];
        _telLabel.textColor = TEXT_COLOR;
        [self.contentView addSubview:_telLabel];
        
        self.defaultAddressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _defaultAddressButton.frame = CGRectMake(self.width - 100, 12, 60, 20);
        _defaultAddressButton.backgroundColor = BACKGROUNDCOLOR;
        [_defaultAddressButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_defaultAddressButton setTitle:@"设为默认" forState:UIControlStateNormal];
        _defaultAddressButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        _defaultAddressButton.layer.cornerRadius = 5;
        _defaultAddressButton.layer.masksToBounds = YES;
        [self.contentView addSubview:_defaultAddressButton];
        
        
        self.addressLB = [[UILabel alloc] initWithFrame:CGRectMake(45, _telLabel.bottom, frame.size.width - 35 - 50, 25)];
        _addressLB.numberOfLines = 0;
        _addressLB.textColor = [UIColor colorWithWhite:.7 alpha:1];
        _addressLB.font = [UIFont systemFontOfSize:14];
        _addressLB.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_addressLB];
        
        self.seleteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, _addressLB.top, 25, 25)];
        _seleteImageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_seleteImageView];
        
        self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _editButton.frame = CGRectMake(frame.size.width - 40, _addressLB.top - 15, 30, 30);
        [_editButton setImage:[UIImage imageNamed:@"go.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:_editButton];
        
    }
}




- (void)setAddressModel:(AddressModel *)addressModel
{
    _addressModel = addressModel;
    if ([addressModel.isDefault isEqualToNumber:@0]) {
        _seleteImageView.image = [UIImage imageNamed:@""];
        self.defaultAddressButton.backgroundColor = BACKGROUNDCOLOR;
        [_defaultAddressButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_defaultAddressButton setTitle:@"设为默认" forState:UIControlStateNormal];
        _defaultAddressButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    }else
    {
        _seleteImageView.image = [UIImage imageNamed:@"defaultaddress.png"];
        self.defaultAddressButton.backgroundColor = [UIColor whiteColor];
        [_defaultAddressButton setTitleColor:BACKGROUNDCOLOR forState:UIControlStateNormal];
        [_defaultAddressButton setTitle:@"默认" forState:UIControlStateNormal];
        _defaultAddressButton.titleLabel.adjustsFontSizeToFitWidth = NO;
        _defaultAddressButton.titleLabel.font = [UIFont systemFontOfSize:15];
        
    }
    self.addressLB.text = [NSString stringWithFormat:@"送餐地址:%@", addressModel.address];
//    [_addressLB sizeToFit];
//    CGRect rect = [_addressLB.text boundingRectWithSize:CGSizeMake(_addressLB.width, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17], NSFontAttributeName, nil] context:nil];
//    _addressLB.height = rect.size.height;
    CGSize size = [_addressLB sizeThatFits:CGSizeMake(_addressLB.width, CGFLOAT_MAX)];
    CGRect addressrect = [_addressLB.text boundingRectWithSize:CGSizeMake(self.addressLB.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    _addressLB.height = addressrect.size.height;
    self.seleteImageView.frame = CGRectMake(10, (addressrect.size.height + 50 ) / 2- 12.5, 25, 25);
    self.telLabel.text = [NSString stringWithFormat:@"%@ | %@", addressModel.receiveName, addressModel.phoneNumber];
    CGRect rect = [self.telLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.telLabel.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    self.telLabel.width = rect.size.width;
   _editButton.frame = CGRectMake(_editButton.left, (addressrect.size.height + 50) / 2 - 15, 30, 30);
    
}


+ (CGFloat)cellHeightFrome:(NSString *)address frame:(CGRect)frame
{
    CGSize size = [address boundingRectWithSize:CGSizeMake(frame.size.width - 95, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, nil] context:nil].size;
    //    NSLog(@"%g, %g, %g", frame.size.width, size.width, size.height);
    return size.height + 50;
}

- (void)awakeFromNib {
    // Initialization code
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//    if (selected) {
//        self.seleteImageView.image = [UIImage imageNamed:@"didChange.png"];
//        self.defaultAddressButton.backgroundColor = [UIColor whiteColor];
//        [_defaultAddressButton setTitleColor:BACKGROUNDCOLOR forState:UIControlStateNormal];
//        [_defaultAddressButton setTitle:@"默认" forState:UIControlStateNormal];
//    }else
//    {
//        _seleteImageView.image = [UIImage imageNamed:@"willChange.png"];
//        self.defaultAddressButton.backgroundColor = BACKGROUNDCOLOR;
//        [_defaultAddressButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_defaultAddressButton setTitle:@"设为默认" forState:UIControlStateNormal];
//    }
//    // Configure the view for the selected state
//}

@end
