//
//  TakeoutTypeView.h
//  vlifree
//
//  Created by 仙林 on 16/4/7.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ScreenBlock)(BOOL selectState);

@interface TakeoutTypeView : UIView

@property (nonatomic, strong)UIButton * titleBT;
@property (nonatomic, strong)UIImageView * stateImageView;

- (void)screenAction:(ScreenBlock)block;

@end
