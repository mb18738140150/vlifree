
//
//  MenusViewCell.m
//  vlifree
//
//  Created by 仙林 on 15/5/25.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "MenusViewCell.h"

#define IMAGE_SIZE 50
#define LEFT_SPACE 10
#define TOP_SPACE 10
#define BUTTON_SIZE 30
#define LABEL_HEIGHT 20
#define PRICE_LABEL_WIDTH 80

#define HORIZON_TAG 100000

//#define VIEW_COLOR [UIColor orangeColor]
#define VIEW_COLOR [UIColor clearColor]

@interface MenusViewCell ()

@property (nonatomic, strong)UIImageView * iconView;
@property (nonatomic, strong)UILabel * nameLabel;
@property (nonatomic, strong)UILabel * soldCountLB;
@property (nonatomic, strong)UILabel * priceLabel;
@property (nonatomic, strong)UIView * oldPriceView;
@property (nonatomic, strong)UILabel * oldPriceLabel;



@end



@implementation MenusViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addObserver:self forKeyPath:@"menuModel.count" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//    NSLog(@"---- key = %@,\n object = %@, \n change = %@", keyPath, object, change);
    MenusViewCell * cell = (MenusViewCell *)object;
    cell.countLabel.text = [NSString stringWithFormat:@"%@", [change objectForKey:@"new"]];
    
//    if (cell.menuModel.PropertyList.count != 0) {
//        if ([[change objectForKey:@"new"] isEqualToNumber:@0]) {
//            cell.countLabel.hidden = YES;
//            cell.addButton.hidden = YES;
//            cell.subtractBT.hidden = YES;
//            cell.choosePropertyButton.hidden = NO;
//        }else
//        {
//            cell.choosePropertyButton.hidden = YES;
//            cell.addButton.hidden = NO;
//            cell.countLabel.hidden = NO;
//            if (cell.menuModel.PropertyList.count != 0) {
//                cell.subtractBT.hidden = YES;
//            }
//            cell.subtractBT.hidden = NO;
//        }
//    }else
//    {
//        if ([[change objectForKey:@"new"] isEqualToNumber:@0]) {
//            cell.subtractBT.hidden = YES;
//        }else
//        {
//            if (cell.menuModel.PropertyList.count != 0) {
//                cell.subtractBT.hidden = YES;
//            }
//            cell.subtractBT.hidden = NO;
//        }
//    }
    if ([[change objectForKey:@"new"] isEqualToNumber:@0]) {
        cell.subtractBT.hidden = YES;
    }else
    {
        if (cell.menuModel.PropertyList.count != 0) {
            cell.subtractBT.hidden = YES;
        }
        cell.subtractBT.hidden = NO;
    }
}


- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"menuModel.count"];
}

- (void)createSubview:(CGRect)frame
{
    if (!_iconView) {
        
        self.separatorInset = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = NO;
        self.layoutMargins = UIEdgeInsetsZero;
        
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, IMAGE_SIZE, IMAGE_SIZE)];
        _iconView.layer.cornerRadius = 10;
        _iconView.layer.masksToBounds = YES;
        _iconView.backgroundColor = VIEW_COLOR;
        _iconView.image = [UIImage imageNamed:@"home_grogshop.png"];
        [self.contentView addSubview:_iconView];
        
        self.iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _iconButton.frame = _iconView.frame;
        [self.contentView addSubview:_iconButton];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconView.right + LEFT_SPACE, TOP_SPACE, frame.size.width - 2 * LEFT_SPACE - _iconView.right, LABEL_HEIGHT)];
        _nameLabel.text = @"双人套餐水煮牛肉套餐";
        _nameLabel.textColor = TEXT_COLOR;
        _nameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_nameLabel];
        
        self.soldCountLB = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom, _nameLabel.width, LABEL_HEIGHT)];
        _soldCountLB.text = @"月售453份";
        _soldCountLB.font = [UIFont systemFontOfSize:12];
        _soldCountLB.textColor = [UIColor colorWithWhite:0.7 alpha:1];
        [self.contentView addSubview:_soldCountLB];
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, _iconView.bottom, PRICE_LABEL_WIDTH, LABEL_HEIGHT)];
        _priceLabel.text = @"23元/份";
        _priceLabel.textColor = [UIColor redColor];
        _priceLabel.font = [UIFont systemFontOfSize:15];
        _priceLabel.backgroundColor = VIEW_COLOR;
        [self.contentView addSubview:_priceLabel];
        
        self.oldPriceView = [[UIView alloc]initWithFrame:CGRectMake(_priceLabel.right, _priceLabel.top + 5, PRICE_LABEL_WIDTH, LABEL_HEIGHT - 5)];
        self.oldPriceView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_oldPriceView];
        
        self.oldPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _oldPriceView.width, _oldPriceView.height)];
        self.oldPriceLabel.textColor = TEXT_COLOR;
        self.oldPriceLabel.font = [UIFont systemFontOfSize:13];
        [_oldPriceView addSubview:_oldPriceLabel];
        
        UIView * horizonline = [[UIView alloc]initWithFrame:CGRectMake(0,  _oldPriceView.height / 2, _oldPriceView.width, 1)];
        horizonline.backgroundColor = TEXT_COLOR;
        horizonline.tag = HORIZON_TAG;
        [_oldPriceView addSubview:horizonline];
        
        UILabel * unitLabel = [[UILabel alloc]initWithFrame:CGRectMake(_oldPriceView.right, _oldPriceView.top, 40, _oldPriceView.height)];
        unitLabel.text = @"元/份";
        unitLabel.font = [UIFont systemFontOfSize:13];
        unitLabel.textColor = TEXT_COLOR;
        unitLabel.tag = 1111;
        [self.contentView addSubview:unitLabel];
        
        
        self.subtractBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _subtractBT.frame = CGRectMake(_nameLabel.right - 3 * BUTTON_SIZE, _priceLabel.bottom - BUTTON_SIZE, BUTTON_SIZE, BUTTON_SIZE);
        _subtractBT.hidden = YES;
//        [_subtractBT setTitleColor:[UIColor colorWithWhite:0.6 alpha:1] forState:UIControlStateNormal];
//        [_subtractBT setTitle:@"-" forState:UIControlStateNormal];
        [_subtractBT setBackgroundImage:[UIImage imageNamed:@"subtract.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:_subtractBT];
        
        self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(_subtractBT.right, _subtractBT.top, _subtractBT.width, _subtractBT.height)];
        _countLabel.text = @"0";
        _countLabel.textColor = TEXT_COLOR;
        _countLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_countLabel];
        
        self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.frame = CGRectMake(_countLabel.right, _priceLabel.bottom - BUTTON_SIZE, BUTTON_SIZE, BUTTON_SIZE);
        [_addButton setBackgroundImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
//        [_addButton setTitle:@"+" forState:UIControlStateNormal];
//        [_addButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_addButton];
        
        
        
        self.choosePropertyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _choosePropertyButton.frame = CGRectMake(_nameLabel.right - 60, _priceLabel.bottom - BUTTON_SIZE, 60, BUTTON_SIZE);
        _choosePropertyButton.backgroundColor = [UIColor whiteColor];
        _choosePropertyButton.layer.cornerRadius = 15;
        _choosePropertyButton.layer.masksToBounds = YES;
        _choosePropertyButton.layer.borderColor = [UIColor colorWithWhite:.7 alpha:1].CGColor;
        _choosePropertyButton.layer.borderWidth = .5;
        [_choosePropertyButton setTitle:@"选口味" forState:UIControlStateNormal];
        _choosePropertyButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_choosePropertyButton setTitleColor:BACKGROUNDCOLOR forState:UIControlStateNormal];
        [self.contentView addSubview:_choosePropertyButton];
        _choosePropertyButton.hidden = YES;
    }
}


+ (CGFloat)cellHeight
{
    return IMAGE_SIZE + LABEL_HEIGHT + 2 * TOP_SPACE;
}


- (void)setMenuModel:(MenuModel *)menuModel
{
    _menuModel = menuModel;
    [self.iconView setImageWithURL:[NSURL URLWithString:menuModel.icon] placeholderImage:[UIImage imageNamed:@"placeholderIM.png"]];
    self.nameLabel.text = menuModel.name;
    self.soldCountLB.text = [NSString stringWithFormat:@"%@", menuModel.commodityDescription];
    
    NSString * priceStr = [NSString stringWithFormat:@"%@", menuModel.price];
    NSDictionary * priceDic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGRect priceRect = [priceStr boundingRectWithSize:CGSizeMake(MAXFLOAT, self.priceLabel.height) options:NSStringDrawingTruncatesLastVisibleLine attributes:priceDic context:nil];
    self.priceLabel.frame = CGRectMake(LEFT_SPACE, _iconView.bottom, priceRect.size.width, LABEL_HEIGHT);
    self.priceLabel.text = priceStr;
    
    NSString * oldPriceStr = [NSString stringWithFormat:@"%@", menuModel.oldPrice];
    NSDictionary * oldpriceDic = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    CGRect oldpriceRect = [oldPriceStr boundingRectWithSize:CGSizeMake(MAXFLOAT, self.priceLabel.height) options:NSStringDrawingTruncatesLastVisibleLine attributes:oldpriceDic context:nil];
    self.oldPriceView.frame = CGRectMake(_priceLabel.right, _priceLabel.top + 5, oldpriceRect.size.width + 4, LABEL_HEIGHT - 5);
    self.oldPriceLabel.frame = CGRectMake(2, 0, oldpriceRect.size.width, _oldPriceView.height);
    self.oldPriceLabel.text = oldPriceStr;
    
    UIView * horizonline = [_oldPriceView viewWithTag:HORIZON_TAG];
    horizonline.frame = CGRectMake(0, _oldPriceView.height / 2, _oldPriceView.width, 1);
    
    UILabel * unitLabel = [self.contentView viewWithTag:1111];
    unitLabel.frame = CGRectMake(_oldPriceView.right, _oldPriceView.top, 40, _oldPriceView.height);
    
//    if (menuModel.PropertyList.count != 0) {
//        self.choosePropertyButton.hidden = NO;
//        self.addButton.hidden = YES;
//        self.countLabel.hidden = YES;
//    }
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
