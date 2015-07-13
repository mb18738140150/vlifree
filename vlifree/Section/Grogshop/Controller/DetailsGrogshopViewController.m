//
//  DetailsGrogshopViewController.m
//  vlifree
//
//  Created by 仙林 on 15/5/21.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "DetailsGrogshopViewController.h"
#import "CycleScrollView.h"
#import "DetailsGSHearderView.h"
#import "DetailsFooterView.h"
#import "DetailsGSViewCell.h"
#import "GSOrderPayViewController.h"
#import "DescribeView.h"
#import "GSMapViewController.h"
#import "RoomModel.h"
#import "AlertLoginView.h"
#import "WXLoginViewController.h"
#import "FacilityViewController.h"
#import "HTMLNode.h"
#import "HTMLParser.h"



#define CELL_INDENTIFIER @"CELL"

#define BUTTON_TAG 1000

@interface DetailsGrogshopViewController ()<UITableViewDataSource, UITableViewDelegate, HTTPPostDelegate>

@property (nonatomic, strong)UITableView * detailsTableView;

@property (nonatomic, strong)DetailsGSHearderView * headerView;
@property (nonatomic, strong)DetailsFooterView * footerView;
@property (nonatomic, strong)UIButton * allButton;

//@property (nonatomic, strong)CycleScrollView * cycleScrollView;//轮播图

@property (nonatomic, strong)NSMutableArray * dataArray;

@property (nonatomic, copy)NSString * phoneNumber;

@property (nonatomic, strong)AlertLoginView * alertLoginV;

@property (nonatomic, strong)NSDictionary * detailsDic;

@property (nonatomic, copy)NSString * describe;

@property (nonatomic, strong)NSMutableString * xmlString;

@end


@implementation DetailsGrogshopViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.detailsTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _detailsTableView.dataSource = self;
    _detailsTableView.delegate = self;
    _detailsTableView.backgroundColor = [UIColor whiteColor];
    [_detailsTableView registerClass:[DetailsGSViewCell class] forCellReuseIdentifier:CELL_INDENTIFIER];
    [self.view addSubview:_detailsTableView];
    
    
    self.headerView = [[DetailsGSHearderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 280)];
    [_headerView.addressView.button addTarget:self action:@selector(lookOverMapk:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView.phoneView.button addTarget:self action:@selector(callNumberWithPhone:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView.detailsBT addTarget:self action:@selector(lookFacility:) forControlEvents:UIControlEventTouchUpInside];
    DetailsGrogshopViewController * detailsVC = self;
    [_headerView.hotelImage setImageWithURL:[NSURL URLWithString:self.icon] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (error) {
            detailsVC.headerView.hotelImage.image = [UIImage imageNamed:@"load_fail.png"];
        }
    }];
//    _headerView.backgroundColor = [UIColor grayColor];
    self.detailsTableView.tableHeaderView = _headerView;
    
//    NSMutableArray * iary = [@[@"1-1.jpg", @"1-2.jpg", @"1-3.jpg", @"1-4.jpg"] mutableCopy];
//    NSMutableArray * imageViewAry = [NSMutableArray array];
//    for (int i = 0; i < iary.count; i++) {
//        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _headerView.width, 150)];
//        imageView.image = [UIImage imageNamed:[iary objectAtIndex:i]];
//        [imageViewAry addObject:imageView];
//    }
//    _headerView.cycleViews = [imageViewAry copy];
    
    self.allButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _allButton.frame = CGRectMake(0, 0, self.view.width, 35);
    [_allButton addTarget:self action:@selector(unfoldAllRoom:) forControlEvents:UIControlEventTouchUpInside];
    [_allButton setTitle:@"展开全部房型" forState:UIControlStateNormal];
    [_allButton setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
    [_allButton setTitle:@"折叠全部房型" forState:UIControlStateSelected];
    [_allButton setTitleColor:TEXT_COLOR forState:UIControlStateSelected];
    _allButton.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1];
    _allButton.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.4].CGColor;
    _allButton.layer.borderWidth = 0.5;
    _allButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.footerView = [[DetailsFooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
    _footerView.explainString = @"无";
//    [_footerView.allButton addTarget:self action:@selector(unfoldAllRoom:) forControlEvents:UIControlEventTouchUpInside];
//    _footerView.explainArray = @[@"bb", @"22", @"ww"];
    self.detailsTableView.tableFooterView = _footerView;
    
    
    UIButton * backBT = [UIButton buttonWithType:UIButtonTypeCustom];
    backBT.frame = CGRectMake(0, 0, 15, 20);
    [backBT setBackgroundImage:[UIImage imageNamed:@"back_r.png"] forState:UIControlStateNormal];
    [backBT addTarget:self action:@selector(backLastVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBT];
    [self downloadDataWithCommand];

}


- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)unfoldAllRoom:(UIButton *)button
{
    button.selected = !button.selected;
    NSLog(@"%d", button.selected);
    [self.detailsTableView reloadData];
}


- (void)callNumberWithPhone:(UIButton *)button
{
    NSLog(@"打电话");
    UIWebView *callWebView = [[UIWebView alloc] init];
    
    NSURL *telURL = [NSURL URLWithString:@"tel:13788052976"];
    //    [[UIApplication sharedApplication] openURL:telURL];
    [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebView];
}

- (void)lookOverMapk:(UIButton *)button
{
    NSLog(@"查看地图");
    GSMapViewController * gsMapVC = [[GSMapViewController alloc] init];
    gsMapVC.gsName = self.hotelName;
    gsMapVC.address = self.headerView.addressView.titleLable.text;
    gsMapVC.lat = self.lat;
    gsMapVC.lon = self.lon;
    [self.navigationController pushViewController:gsMapVC animated:YES];
}


- (void)lookFacility:(UIButton *)button
{
    FacilityViewController * factlityVC = [[FacilityViewController alloc] init];
    factlityVC.detailsDic = self.detailsDic;
    factlityVC.describe = self.describe;
    [self.navigationController pushViewController:factlityVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)reserveGSRoom:(UIButton *)button
{
    NSLog(@"预定%ld", button.tag - BUTTON_TAG);
    if ([UserInfo shareUserInfo].userId) {
        RoomModel * roomMD = [self.dataArray objectAtIndex:button.tag - BUTTON_TAG];
        GSOrderPayViewController * gsOrderPayVC = [[GSOrderPayViewController alloc] init];
        gsOrderPayVC.roomName = roomMD.suiteName;
        gsOrderPayVC.price = roomMD.suitePrice;
        gsOrderPayVC.roomId = roomMD.suiteId;
        [self.navigationController pushViewController:gsOrderPayVC animated:YES];
    }else
    {
//        UIView * view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.2];
//        [self.view.window addSubview:view];
        self.alertLoginV = [[AlertLoginView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_alertLoginV.logInButton addTarget:self action:@selector(userLogInAction:) forControlEvents:UIControlEventTouchUpInside];
        [_alertLoginV.weixinButton addTarget:self action:@selector(weixinLogIn:) forControlEvents:UIControlEventTouchUpInside];
        [self.detailsTableView.window addSubview:_alertLoginV];
    }
    
}

- (void)userLogInAction:(UIButton *)button
{
    if (self.alertLoginV.phoneTF.text.length == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入手机号" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }else if (self.alertLoginV.passwordTF.text.length == 0)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入密码" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }else
    {
        NSDictionary * jsonDic = @{
                                   @"Command":@7,
                                   @"LoginType":@1,
                                   @"Account":self.alertLoginV.phoneTF.text,
                                   @"Password":self.alertLoginV.passwordTF.text,
                                   };
        [self playPostWithDictionary:jsonDic];
//        [SVProgressHUD showWithStatus:@"登陆中..." maskType:SVProgressHUDMaskTypeClear];
    }
}

- (void)weixinLogIn:(UIButton *)button//微信登陆
{
    NSLog(@"微信登陆");
//    [SVProgressHUD showWithStatus:@"登陆中..." maskType:SVProgressHUDMaskTypeClear];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"refresh_token"]) {
        if ([self compareDate]) {
            [self avoidweixinAuthorizeLogIn];
        }else
        {
            [self weixinAuthorizeLogIn];
        }
    }else
    {
        [self weixinAuthorizeLogIn];
    }
}

#pragma mark - 数据请求
- (void)downloadDataWithCommand
{
//    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    NSDictionary * jsonDic = @{
                               @"Command":@10,
                               @"HotelId":self.hotelID
                               };
    [self playPostWithDictionary:jsonDic];
    /*
     //    NSLog(@"%@, %@", self.classifyId, [UserInfo shareUserInfo].userId);
     NSString * jsonStr = [jsonDic JSONString];
     NSString * str = [NSString stringWithFormat:@"%@231618", jsonStr];
     NSLog(@"%@", str);
     NSString * md5Str = [str md5];
     NSString * urlString = [NSString stringWithFormat:@"http://p.vlifee.com/getdata.ashx?md5=%@",md5Str];
     
     HTTPPost * httpPost = [HTTPPost shareHTTPPost];
     [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
     httpPost.delegate = self;
     */
}

- (void)playPostWithDictionary:(NSDictionary *)dic
{
    NSString * jsonStr = [dic JSONString];
    NSLog(@"%@", jsonStr);
    NSString * str = [NSString stringWithFormat:@"%@231618", jsonStr];
    NSString * md5Str = [str md5];
    NSString * urlString = [NSString stringWithFormat:@"%@%@", POST_URL, md5Str];
    
    HTTPPost * httpPost = [HTTPPost shareHTTPPost];
    [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    httpPost.delegate = self;
}

- (void)refresh:(id)data
{
    NSLog(@"+++%@", data);
    NSLog(@"%@", [data objectForKey:@"ErrorMsg"]);
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        if ([[data objectForKey:@"Command"] isEqualToNumber:@10009] || [[data objectForKey:@"Command"] isEqualToNumber:@10007]) {
            [[UserInfo shareUserInfo] setValuesForKeysWithDictionary:[data objectForKey:@"UserInfo"]];
            [self.alertLoginV removeFromSuperview];
            UITabBarItem * item = [self.navigationController.tabBarController.tabBar.items lastObject];
            item.title = @"我的";
            if ([[data objectForKey:@"IsFirst"] isEqualToNumber:@YES]) {
                __weak DetailsGrogshopViewController * detailsGSVC = self;
                WXLoginViewController * wxLoginVC = [[WXLoginViewController alloc] init];
                [wxLoginVC refreshUserInfo:^{
                    [detailsGSVC.alertLoginV removeFromSuperview];
                }];
                UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:wxLoginVC];
                [self.navigationController presentViewController:nav animated:YES completion:nil];
            }else
            {
                [[NSUserDefaults standardUserDefaults] setValue:[UserInfo shareUserInfo].phoneNumber forKey:@"account"];
                [[NSUserDefaults standardUserDefaults] setValue:[UserInfo shareUserInfo].password forKey:@"password"];
                [[NSUserDefaults standardUserDefaults] setValue:@YES forKey:@"haveLogIn"];
            }

        }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10010])
        {
            NSDictionary * dic = [data objectForKey:@"HotelInfo"];
            self.describe = [dic objectForKey:@"Describe"];
            self.headerView.addressView.titleLable.text = [dic objectForKey:@"Address"];
            self.headerView.phoneView.titleLable.text = [dic objectForKey:@"PhoneNumber"];
            self.detailsDic = [dic objectForKey:@"HotelDetail"];
            if ([[self.detailsDic objectForKey:@"ParkState"] isEqualToNumber:@1]) {
                self.headerView.parkView.image = [UIImage imageNamed:@"P_on.png"];
            }else
            {
                self.headerView.parkView.image = [UIImage imageNamed:@"P_off.png"];
            }
            if ([[self.detailsDic objectForKey:@"RestaurantState"] isEqualToNumber:@1]) {
                self.headerView.foodView.image = [UIImage imageNamed:@"food_on.png"];
            }else
            {
                self.headerView.foodView.image = [UIImage imageNamed:@"food_off.png"];
            }
            if ([[self.detailsDic objectForKey:@"WifiState"] isEqualToNumber:@1]) {
                self.headerView.wifiView.image = [UIImage imageNamed:@"wifi_on.png"];
            }else
            {
                self.headerView.wifiView.image = [UIImage imageNamed:@"wifi_off.png"];
            }
            self.footerView = [[DetailsFooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
            self.footerView.explainString = [self removeHTMLString:[dic objectForKey:@"BookingInstructions"]];
            self.detailsTableView.tableFooterView = _footerView;
            NSArray * array = [dic objectForKey:@"SuiteList"];
            for (NSDictionary * suiteDic in array) {
                RoomModel * roomMD = [[RoomModel alloc] initWithDictionary:suiteDic];
                [self.dataArray addObject:roomMD];
            }
            
            [self.detailsTableView reloadData];
            NSLog(@"解析html = %@", [self removeHTMLString:[dic objectForKey:@"BookingInstructions"]]);
        }
       
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
    }
//    [self.detailsTableView headerEndRefreshing];
//    [self.detailsTableView footerEndRefreshing];
//    [SVProgressHUD dismiss];
}

- (void)failWithError:(NSError *)error
{
//    [self.groshopTabelView headerEndRefreshing];
//    [self.groshopTabelView footerEndRefreshing];
//    [SVProgressHUD dismiss];
    NSLog(@"%@", error);
}



#pragma mark - tableView 


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.allButton.selected) {
        return self.dataArray.count;
    }else
    {
        if (self.dataArray.count > 2) {
            return 2;
        }else
        {
            return _dataArray.count;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RoomModel * roomMD = [self.dataArray objectAtIndex:indexPath.row];
    DetailsGSViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_INDENTIFIER];
    [cell createSubviewWithFrame:tableView.bounds];
    [cell.reserveButton addTarget:self action:@selector(reserveGSRoom:) forControlEvents:UIControlEventTouchUpInside];
    cell.reserveButton.tag = BUTTON_TAG + indexPath.row;
    cell.roomModel = roomMD;
    [cell.iconButton addTarget:self action:@selector(lookBigImage:) forControlEvents:UIControlEventTouchUpInside];
    cell.iconButton.tag = 10000 + indexPath.row;
//    cell.textLabel.text = @"222";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DetailsGSViewCell cellHeight];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"精品推荐";
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 35)];
    sectionView.backgroundColor = [UIColor whiteColor];
    UILabel * titleLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 2.5, self.view.width - 30, 30)];
    titleLB.text = @"精品推荐";
    titleLB.textColor = TEXT_COLOR;
    titleLB.font = [UIFont systemFontOfSize:15];
    [sectionView addSubview:titleLB];
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(15, sectionView.height - 1, titleLB.width, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
//    [sectionView addSubview:lineView];
    return sectionView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.allButton;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma marc - 微信登陆

//发送授权请求
- (void)weixinAuthorizeLogIn
{
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        SendAuthReq * req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"123456789";
        BOOL isSend = [WXApi sendReq:req];
        if (!isSend) {
//            [SVProgressHUD dismiss];
        }
//        [WXApi sendAuthReq:req viewController:self delegate:self];
    }else if([WXApi isWXAppInstalled] == NO)
    {
//        [SVProgressHUD dismiss];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"你的设备还没安装微信,请先安装微信" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }else if([WXApi isWXAppSupportApi] == NO)
    {
//        [SVProgressHUD dismiss];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"你的微信版本不支持,请更新微信" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }
    
}


- (BOOL)compareDate
{
    NSString * dateStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"tokenDate"];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * date = [formatter dateFromString:dateStr];
    
    NSCalendar *userCalendar = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitDay;
    NSDateComponents *components = [userCalendar components:unitFlags fromDate:date toDate:[NSDate date] options:0];
    NSInteger days = [components day];
    if (days > 28) {
        return NO;
    }
    return YES;
}


- (void)avoidweixinAuthorizeLogIn
{
    NSString * tokenUrl = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@", APP_ID_WX, [[NSUserDefaults standardUserDefaults] objectForKey:@"refresh_token"]];
    NSURLRequest * tokenRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:tokenUrl]];
    //将请求的url数据放到NSData对象中
    NSData * tokenData = [NSURLConnection sendSynchronousRequest:tokenRequest returningResponse:nil error:nil];
    if (tokenData) {
        NSDictionary * tokenDic = [NSJSONSerialization JSONObjectWithData:tokenData options:0 error:nil];
        if ([tokenDic objectForKey:@"access_token"]) {
            NSString * yanzhengURLSTR = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/auth?access_token=%@&openid=%@", [tokenDic objectForKey:@"access_token"], [tokenDic objectForKey:@"openid"]];
            NSURLRequest * yzRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:yanzhengURLSTR]];
            NSData * yzData = [NSURLConnection sendSynchronousRequest:yzRequest returningResponse:nil error:nil];
            if (yzData) {
                NSDictionary * yzDic = [NSJSONSerialization JSONObjectWithData:yzData options:0 error:nil];
                if ([[yzDic objectForKey:@"errcode"] isEqual:@0]) {
                    NSString * infoURLSTR = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", [tokenDic objectForKey:@"access_token"], [tokenDic objectForKey:@"openid"]];
                    NSURLRequest * infoRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:infoURLSTR]];
                    NSData * infoData = [NSURLConnection sendSynchronousRequest:infoRequest returningResponse:nil error:nil];
                    if (infoData) {
                        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:infoData options:0 error:nil];
                        //                        [self removeLogInView];
                        NSLog(@"user info = %@", infoDic);
                        NSDictionary * jsonDic = @{
                                                   @"Openid":[infoDic objectForKey:@"openid"],
                                                   @"Nickname":[infoDic objectForKey:@"nickname"],
                                                   @"Sex":[infoDic objectForKey:@"sex"],
                                                   @"City":[infoDic objectForKey:@"city"],
                                                   @"Province":[infoDic objectForKey:@"province"],
                                                   @"Country":[infoDic objectForKey:@"country"],
                                                   @"HeadimgUrl":[infoDic objectForKey:@"headimgurl"],
                                                   @"Unionid":[infoDic objectForKey:@"unionid"],
                                                   @"Command":@9,
                                                   @"LoginType":@2
                                                   };
                        [self playPostWithDictionary:jsonDic];
                    }
                }
            }
        }
    }
}


- (void)getAccessToken:(NSString *)code
{
    //根据授权获取 access_token
    NSString * urlString = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=wxaac5e5f7421e84ac&secret=055e7e10c698b7b140511d8d1a73cec4&code=%@&grant_type=authorization_code", code];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (response) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        //        NSLog(@"++++++%@", dic);
        if ([dic objectForKey:@"access_token"]) {
            [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"refresh_token"] forKey:@"refresh_token"];//保存 refresh_token
            [self saveAuthorizeDate];
            [self avoidweixinAuthorizeLogIn];
        }
    }
}

- (void)saveAuthorizeDate
{
    NSDateFormatter * formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSString * dateStr = [formater stringFromDate:[NSDate date]];
    [[NSUserDefaults standardUserDefaults] setObject:dateStr forKey:@"tokenDate"];
}


#pragma mark - 点击图片放大

- (void)lookBigImage:(UIButton *)button
{
    int section = 0;
    int row = button.tag - 10000;
    RoomModel * roomMd = [self.dataArray objectAtIndex:row];
    CGPoint point = self.detailsTableView.contentOffset;
    CGRect cellRect = [self.detailsTableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    CGRect btFrame = button.frame;
    btFrame.origin.y = cellRect.origin.y - point.y + button.frame.origin.y + self.detailsTableView.top;
    btFrame.origin.x = self.detailsTableView.left + button.left;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBigImage)];
    
    UIView * view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.tag = 70000;
    [view addGestureRecognizer:tapGesture];
    view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.3];
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    imageView.center = view.center;
    imageView.layer.cornerRadius = 30;
    imageView.layer.masksToBounds = YES;
    CGRect imageFrame = imageView.frame;
    imageView.frame = btFrame;
    imageView.image = [UIImage imageNamed:@"superMarket.png"];
    [view addSubview:imageView];
    [self.view.window addSubview:view];
    __weak UIImageView * imageV = imageView;
    [imageView setImageWithURL:[NSURL URLWithString:roomMd.icon] placeholderImage:[UIImage imageNamed:@"placeholderIM.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (error) {
            imageV.image = [UIImage imageNamed:@"load_fail.png"];
        }
    }];
    [UIView animateWithDuration:1 animations:^{
        imageView.frame = imageFrame;
    }];
    
    NSLog(@",  %g, %g", cellRect.origin.x, cellRect.origin.y);
}

- (void)removeBigImage
{
    UIView * view = [self.view.window viewWithTag:70000];
    [view removeFromSuperview];
}



- (NSString *)removeHTMLString:(NSString *)string
{
    NSMutableString * str = [[NSString stringWithFormat:@"<body>%@<body>", string] mutableCopy];
    [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    while ([str rangeOfString:@"<"].location != NSNotFound) {
        NSRange range1 = [str rangeOfString:@"<"];
        NSRange range2 = [str rangeOfString:@">"];
        NSRange strRange = NSMakeRange(range1.location, range2.location - range1.location + 1);
        [str replaceCharactersInRange:strRange withString:@""];
//        NSLog(@"%d, %d", strRange.location, strRange.length);
    }
    /*
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:string error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error);
        return nil;
    }
    
    HTMLNode *bodyNode = [parser body];
    NSLog(@"111 = %@", bodyNode.contents);
    NSArray *inputNodes = [bodyNode children];
    for (HTMLNode * node in inputNodes) {
        NSLog(@"qq = %@", node.allContents);
        NSArray *childNodes = [node children];
        if (childNodes.count > 0) {
            if (childNodes.count == 1) {
                NSLog(@"2222");
            }
            for (HTMLNode * node1 in childNodes) {
                
//                if (node1.nodetype == HTMLTextNode) {
                    NSLog(@"pppp = %@", node1.allContents);
//                }
                for (HTMLNode * node2 in [node1 children]) {
                    
                }
            }
        }
    }
     */
    return [str copy];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
