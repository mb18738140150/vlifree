//
//  StoreIntroView.m
//  vlifree
//
//  Created by 仙林 on 15/8/25.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "StoreIntroView.h"
#import "AppDelegate.h"
#import "AutoSlideScrollView.h"
#define LEFT_SPACE 10
#define TOP_SPACE 10
//#define LABEL_HEIGHT ([UIScreen mainScreen].bounds.size.height / 15)
#define LABEL_HEIGHT 40
#define RIGHT_LB_WIDTH 75


#define LABEL_FONT [UIFont systemFontOfSize:15]
#define COLOT_TEXT [UIColor colorWithWhite:0.5 alpha:1]

#define ImageHeight ([UIScreen mainScreen].bounds.size.width * 173 / 360)
#define HelpViewHeight 42
@interface StoreIntroView ()<UIScrollViewDelegate>

@property (nonatomic, copy)NSString * tel;
//@property (nonatomic, strong)UILabel * introLB;
//@property (nonatomic, strong)UILabel * typeLB;
//@property (nonatomic, strong)UILabel * openTimeLB;
//@property (nonatomic, strong)UILabel * addressLB;
//@property (nonatomic, strong)UILabel * telNumLB;
//@property (nonatomic, strong)UILabel * sendPriceLB;
//@property (nonatomic, strong)UILabel * outSendLB;
//@property (nonatomic, strong)UILabel * distanceLB;
@property (nonatomic, strong)UIScrollView * myScrollview;
@property (nonatomic, strong)UIImageView * describeImageView;
@property (nonatomic, strong)AutoSlideScrollView * lunboScrollView;
@property (nonatomic, strong)UILabel * startSendLabel;
@property (nonatomic, strong)UILabel * deliveryLabel;
@property (nonatomic, strong)UILabel * averageSendTimeLabel;
@property (nonatomic, strong)UIView * sendInformationView;
@property (nonatomic, strong)StoreIntroHelpView * bussTime;
@property (nonatomic, strong)StoreIntroHelpView * storeType;
@property (nonatomic, strong)StoreIntroHelpView * deliveryDistance;//配送距离
@property (nonatomic, strong)StoreIntroHelpView * serviceDistance;//配送区域

@property (nonatomic, strong)UIView * describeView;
@property (nonatomic, strong)UILabel * describeLabel;

/**
 *  放大比例
 */
@property (nonatomic,assign)CGFloat scale;

@end



@implementation StoreIntroView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createSubview];
    }
    return self;
}

- (void)createSubview
{
    self.myScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.myScrollview.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    _myScrollview.delegate = self;
    [self addSubview:_myScrollview];
    
    self.describeImage = nil;
    
    self.lunboScrollView = [[AutoSlideScrollView alloc]initWithFrame:CGRectMake(0, 0, _myScrollview.width, ImageHeight) animationDuration:2.0];
    
    [_myScrollview addSubview:_lunboScrollView];
    
    self.describeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _myScrollview.width, ImageHeight)];
    _describeImageView.backgroundColor = [UIColor whiteColor];
//    [_lunboScrollView addSubview:_describeImageView];
    
    self.scale = self.describeImageView.width / self.describeImageView.height;
    
    self.sendInformationView = [[UIView alloc]initWithFrame:CGRectMake(0, _lunboScrollView.bottom, _myScrollview.width, 84)];
    _sendInformationView.backgroundColor = [UIColor whiteColor];
    [_myScrollview addSubview:_sendInformationView];
    
    UILabel * startSendLB = [[UILabel alloc]initWithFrame:CGRectMake(0, TOP_SPACE + 9, _myScrollview.width / 3, 12)];
    startSendLB.textColor = [UIColor grayColor];
    startSendLB.textAlignment = NSTextAlignmentCenter;
    startSendLB.font = [UIFont systemFontOfSize:12];
    startSendLB.text = @"起送价";
    [_sendInformationView addSubview:startSendLB];
    
    self.startSendLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, startSendLB.bottom + TOP_SPACE, _myScrollview.width / 3, 22)];
    _startSendLabel.textColor = [UIColor grayColor];
    _startSendLabel.textAlignment = NSTextAlignmentCenter;
    _startSendLabel.font = [UIFont systemFontOfSize:12];
    _startSendLabel.text = @"￥";
    [_sendInformationView addSubview:_startSendLabel];
    
    
    UILabel * deliveryLB = [[UILabel alloc]initWithFrame:CGRectMake(startSendLB.right, startSendLB.top, _myScrollview.width / 3, startSendLB.height)];
    deliveryLB.textColor = [UIColor grayColor];
    deliveryLB.textAlignment = NSTextAlignmentCenter;
    deliveryLB.font = [UIFont systemFontOfSize:12];
    deliveryLB.text = @"配送价";
    [_sendInformationView addSubview:deliveryLB];
    
    self.deliveryLabel = [[UILabel alloc]initWithFrame:CGRectMake(_startSendLabel.right, deliveryLB.bottom + TOP_SPACE, _myScrollview.width / 3, 22)];
    _deliveryLabel.textColor = [UIColor grayColor];
    _deliveryLabel.textAlignment = NSTextAlignmentCenter;
    _deliveryLabel.font = [UIFont systemFontOfSize:12];
    _deliveryLabel.text = @"￥";
    [_sendInformationView addSubview:_deliveryLabel];
    
    UILabel * averageSendTimeLB = [[UILabel alloc]initWithFrame:CGRectMake(deliveryLB.right, startSendLB.top, _myScrollview.width / 3, startSendLB.height)];
    averageSendTimeLB.textColor = [UIColor grayColor];
    averageSendTimeLB.textAlignment = NSTextAlignmentCenter;
    averageSendTimeLB.font = [UIFont systemFontOfSize:12];
    averageSendTimeLB.text = @"平均配送时间";
    [_sendInformationView addSubview:averageSendTimeLB];
    
    self.averageSendTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_deliveryLabel.right, averageSendTimeLB.bottom + TOP_SPACE, _myScrollview.width / 3, 22)];
    _averageSendTimeLabel.textColor = [UIColor grayColor];
    _averageSendTimeLabel.textAlignment = NSTextAlignmentCenter;
    _averageSendTimeLabel.font = [UIFont systemFontOfSize:12];
    _averageSendTimeLabel.text = @"￥";
    [_sendInformationView addSubview:_averageSendTimeLabel];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(startSendLB.right, startSendLB.bottom, 1, 30)];
    line1.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [_sendInformationView addSubview:line1];
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(deliveryLB.right, startSendLB.bottom, 1, 30)];
    line2.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [_sendInformationView addSubview:line2];
    
    self.bussTime = [[StoreIntroHelpView alloc]initWithFrame:CGRectMake(0, _sendInformationView.bottom + TOP_SPACE, _myScrollview.width, HelpViewHeight)];
    _bussTime.titleLabel.text = @"营业时间";
    [self.myScrollview addSubview:_bussTime];
    
    self.storeType = [[StoreIntroHelpView alloc]initWithFrame:CGRectMake(0, _bussTime.bottom + 1, _myScrollview.width, HelpViewHeight)];
    _storeType.titleLabel.text = @"店铺类型";
    [self.myScrollview addSubview:_storeType];
    
    self.deliveryDistance = [[StoreIntroHelpView alloc]initWithFrame:CGRectMake(0, _storeType.bottom + 1, _myScrollview.width, HelpViewHeight)];
    _deliveryDistance.titleLabel.text = @"配送距离";
    [self.myScrollview addSubview:_deliveryDistance];
    
    self.serviceDistance = [[StoreIntroHelpView alloc]initWithFrame:CGRectMake(0, _deliveryDistance.bottom + 1, _myScrollview.width, HelpViewHeight)];
    _serviceDistance.titleLabel.text = @"配送区域";
    [_serviceDistance.button setBackgroundImage:[UIImage imageNamed:@"icon_hua.png"] forState:UIControlStateNormal];
    [_serviceDistance.button addTarget:self action:@selector(telAction:) forControlEvents:UIControlEventTouchUpInside];
    [_myScrollview addSubview:_serviceDistance];
    
    self.storeAddress = [[StoreIntroHelpView alloc]initWithFrame:CGRectMake(0, _serviceDistance.bottom + 1, _myScrollview.width, HelpViewHeight)];
    _storeAddress.titleLabel.text = @"店铺地址";
    [_storeAddress.button setBackgroundImage:[UIImage imageNamed:@"addressIcon.png"] forState:UIControlStateNormal];
    [_myScrollview addSubview:_storeAddress];
    
    self.describeView = [[UIView alloc]initWithFrame:CGRectMake(0, _storeAddress.bottom + TOP_SPACE, _myScrollview.width, 130)];
    _describeView.backgroundColor = [UIColor whiteColor];
    [_myScrollview addSubview:_describeView];
    
    UILabel * describelB = [[UILabel alloc]initWithFrame:CGRectMake(TOP_SPACE, TOP_SPACE, _describeView.width - 2 * TOP_SPACE, 14)];
    describelB.text = @"商家介绍";
//    describelB.font = [UIFont fontWithName:@"Georgia-BoldItalic" size:describelB.height];
    [_describeView addSubview:describelB];
    
    UIView * describeLine = [[UIView alloc]initWithFrame:CGRectMake(TOP_SPACE, describelB.bottom + TOP_SPACE, _describeView.width - 2 * TOP_SPACE, 1)];
    describeLine.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [_describeView addSubview:describeLine];
    
    self.describeLabel = [[UILabel alloc]initWithFrame:CGRectMake(TOP_SPACE, describeLine.bottom + TOP_SPACE, _describeView.width - 2 * TOP_SPACE, 60)];
    _describeLabel.textColor = [UIColor grayColor];
    _describeLabel.backgroundColor = [UIColor whiteColor];
    [_describeView addSubview:_describeLabel];
    
    self.myScrollview.contentSize = CGSizeMake(self.myScrollview.width, _describeView.bottom);
}

- (void)setDescribeImage:(NSString *)describeImage
{
    __weak UIImageView * iconV = self.describeImageView;
    [self.describeImageView setImageWithURL:[NSURL URLWithString:describeImage] placeholderImage:[UIImage imageNamed:@"placeholderIM.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (error) {
            iconV.image = [UIImage imageNamed:@"load_fail.png"];
        }
    }];
}

- (void)creatSoreWithDic:(NSDictionary *)dic
{
    NSDictionary * attribute = @{NSForegroundColorAttributeName:BACKGROUNDCOLOR, NSFontAttributeName:[UIFont systemFontOfSize:20]};
    
    NSString * startSend = [NSString stringWithFormat:@"￥%@", [dic objectForKey:@"StartSendMoney"]];
    NSMutableAttributedString * startSendM = [[NSMutableAttributedString alloc]initWithString:startSend];
    [startSendM setAttributes:attribute range:NSMakeRange(1, startSend.length - 1)];
    
    self.startSendLabel.attributedText = startSendM;
    NSString * delivery = [NSString stringWithFormat:@"￥%@", [dic objectForKey:@"Delivery"]];
    NSMutableAttributedString * deliveryM = [[NSMutableAttributedString alloc]initWithString:delivery];
    [deliveryM setAttributes:attribute range:NSMakeRange(1, delivery.length - 1)];
    
    self.deliveryLabel.attributedText = deliveryM;
    NSString * averageSendTime = [NSString stringWithFormat:@"%@分钟", [dic objectForKey:@"AverageSendtime"]];
    NSMutableAttributedString *averageSendTimeM = [[NSMutableAttributedString alloc]initWithString:averageSendTime];
    [averageSendTimeM setAttributes:attribute range:NSMakeRange(0, averageSendTime.length - 2)];
    self.averageSendTimeLabel.attributedText = averageSendTimeM;
    
    NSString * busstimeStr = [dic objectForKey:@"BusTime"];
    NSArray * timeArr = [busstimeStr componentsSeparatedByString:@"-"];
    NSString * str1 = [NSString stringWithFormat:@"%@:%@", [[[timeArr objectAtIndex:0] componentsSeparatedByString:@":"] objectAtIndex:0], [[[[timeArr objectAtIndex:0] componentsSeparatedByString:@":"] objectAtIndex:1] substringToIndex:2]];
    NSString * str2 = [NSString stringWithFormat:@"%@:%@", [[[timeArr objectAtIndex:1] componentsSeparatedByString:@":"] objectAtIndex:0], [[[[timeArr objectAtIndex:1] componentsSeparatedByString:@":"] objectAtIndex:1] substringToIndex:2]];
//    NSLog(@"%@***%@***", [timeArr objectAtIndex:0], [[[timeArr objectAtIndex:0] componentsSeparatedByString:@":"] objectAtIndex:0]);
    
    self.bussTime.informationLabel.text = [NSString stringWithFormat:@"%@ - %@", str1, str2];
    
    self.storeType.informationLabel.text = [dic objectForKey:@"StoreType"];
    [self.storeType.button setTitle:[NSString stringWithFormat:@"%@分", [dic objectForKey:@"StoreScore"]] forState:UIControlStateNormal];
    [self.storeType.button setTitleColor:BACKGROUNDCOLOR forState:UIControlStateNormal];
    self.storeType.button.titleLabel.font = [UIFont systemFontOfSize:12];
    CGRect buttonRect = [self.storeType.button.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.storeType.button.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    self.storeType.button.frame = CGRectMake(self.width - TOP_SPACE - buttonRect.size.width, self.storeType.button.top, buttonRect.size.width, self.storeType.button.height);
    
    self.deliveryDistance.informationLabel.text = [NSString stringWithFormat:@"%@公里", [dic objectForKey:@"ServiceDis"]];
    self.serviceDistance.informationLabel.text = [dic objectForKey:@"DeliveryDis"];
    CGRect serverDisRect = [self.serviceDistance.informationLabel.text boundingRectWithSize:CGSizeMake(self.storeAddress.informationLabel.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    if (serverDisRect.size.height > 14) {
        self.serviceDistance.informationLabel.height = serverDisRect.size.height;
        self.serviceDistance.height = self.storeAddress.height + serverDisRect.size.height - 14;
        self.serviceDistance.button.top = self.serviceDistance.height / 2 - 10;
        _storeAddress.top = _serviceDistance.bottom + 1;
    }
    
    self.storeAddress.informationLabel.text = [dic objectForKey:@"StoreAdress"];
    CGRect addressRect = [self.storeAddress.informationLabel.text boundingRectWithSize:CGSizeMake(self.storeAddress.informationLabel.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    if (addressRect.size.height > 14) {
        self.storeAddress.informationLabel.height = addressRect.size.height;
        self.storeAddress.height = self.storeAddress.height + addressRect.size.height - 14;
        self.storeAddress.button.top = self.storeAddress.height / 2 - 10;
        self.describeView.top = self.storeAddress.bottom + TOP_SPACE;
    }
    NSMutableArray * viewsAry = [NSMutableArray arrayWithCapacity:1];
    if ([dic objectForKey:@"StorePhotos"]) {
        NSArray * photosarr = [dic objectForKey:@"StorePhotos"];
        for (int i = 0; i < photosarr.count; i++) {
            NSString * imageStr = [photosarr objectAtIndex:i];
            UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 0, _lunboScrollView.width, _lunboScrollView.height)];
            __weak UIImageView * imageView_block = imageview;
            [imageview setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"placeholderIM.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                if (error) {
                    imageView_block.image = [UIImage imageNamed:@"load_fail.png"];
                }
            }];
            [viewsAry addObject:imageview];
        }
        
    }else
    {
        [viewsAry addObject:self.describeImageView];

    }
    
    self.lunboScrollView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return [viewsAry objectAtIndex:pageIndex];
    };
    self.lunboScrollView.totalPagesCount = ^NSInteger(void){
        return viewsAry.count;
    };
    
    self.describeLabel.text = [dic objectForKey:@"Describe"];
    self.tel = [dic objectForKey:@"StoreTel"];
    self.myScrollview.contentSize = CGSizeMake(self.myScrollview.width, self.describeView.bottom + TOP_SPACE);
}

- (void)telAction:(UIButton *)button
{
    if (self.tel.length != 0) {
        UIWebView * callWebView = [[UIWebView alloc]init];
        NSURL * telUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.tel]];
        [callWebView loadRequest:[NSURLRequest requestWithURL:telUrl]];
        AppDelegate * appdelegate = [UIApplication sharedApplication].delegate;
        [appdelegate.window addSubview:callWebView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y;
    if (scrollView.contentOffset.y<0) {
        // 高度宽度同时拉伸，从中心放大
        CGFloat imgH = ImageHeight - scrollView.contentOffset.y * 2;
        CGFloat imgW = imgH * self.scale;
        if (self.lunboScrollView.scrollView.subviews.count == 1) {
            self.lunboScrollView.frame =  CGRectMake(scrollView.contentOffset.y * self.scale, scrollView.contentOffset.y , imgW, imgH);
            
            for (UIImageView * imageView in self.lunboScrollView.scrollView.subviews) {
                imageView.frame = CGRectMake(0, 0 , _lunboScrollView.width, _lunboScrollView.height);
            }
            
            [self aginlayout];
        }else
        {
            
        }
        
        
    }
     NSLog(@"%0.0f",scrollView.contentOffset.y);
}
- (void)aginlayout
{
    self.sendInformationView.frame = CGRectMake(self.sendInformationView.left, CGRectGetMaxY(self.lunboScrollView.frame), self.sendInformationView.width, self.sendInformationView.height);
    self.bussTime.top = self.sendInformationView.bottom + TOP_SPACE;
    self.storeType.top = self.bussTime.bottom + 1;
    self.deliveryDistance.top = self.storeType.bottom + 1;
    self.serviceDistance.top = self.deliveryDistance.bottom + 1;
    self.storeAddress.top = self.serviceDistance.bottom + 1;
    self.describeView.top = self.storeAddress.bottom + TOP_SPACE;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
