//
//  IntegralView.h
//  vlifree
//
//  Created by 仙林 on 15/10/19.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailsIntegralView.h"

@interface IntegralView : UIView

@property (nonatomic, strong)UIButton * backButton;
@property (nonatomic, strong)UILabel * titleLabel;

@property (nonatomic, strong)DetailsIntegralView * giveupview;
@property (nonatomic, strong)DetailsIntegralView * useTotalview;
@property (nonatomic, strong)DetailsIntegralView * choseIntegralview;

@property (nonatomic, strong)UILabel * totalLabel;
@property (nonatomic, strong)UILabel * totalLB;

@end
