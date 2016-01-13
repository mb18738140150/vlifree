//
//  UserViewController.m
//  vlifree
//
//  Created by 仙林 on 15/5/19.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "UserViewController.h"
#import "LogInView.h"
#import "UserViewCell.h"
#import "UserModel.h"
#import "ModifyNameViewController.h"
#import "PasswordViewController.h"
#import "UserTOOrderViewController.h"
#import "GSOrderViewController.h"
#import "RegisterViewController.h"

#import "WXLoginViewController.h"
#import "PhoneViewController.h"

#define CELL_INDENTIFIER @"cell"
#define MODIFY_BUTTON_TAG 1000


@interface UserViewController ()<UITableViewDataSource, UITableViewDelegate, WXApiDelegate, HTTPPostDelegate>

@property (nonatomic, strong)UITableView * userTableView;

@property (nonatomic, strong)NSMutableArray * dataArray;

@property (nonatomic, strong)LogInView * logInView;

@end

@implementation UserViewController

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登陆";
//    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.logInView = [[LogInView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, self.view.width, self.view.height - self.navigationController.navigationBar.bottom)];
//    _logInView.backgroundColor = [UIColor grayColor];
    [_logInView.logInButton addTarget:self action:@selector(userLogInAction:) forControlEvents:UIControlEventTouchUpInside];
    [_logInView.registerButton addTarget:self action:@selector(registerUser:) forControlEvents:UIControlEventTouchUpInside];
    [_logInView.weixinButton addTarget:self action:@selector(weixinLogIn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_logInView];
    
    self.userTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, self.view.width, self.view.height - self.navigationController.navigationBar.bottom - self.tabBarController.tabBar.height) style:UITableViewStylePlain];
    _userTableView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    _userTableView.dataSource = self;
    _userTableView.delegate = self;
    [_userTableView registerClass:[UserViewCell class] forCellReuseIdentifier:CELL_INDENTIFIER];
    _userTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_userTableView];
//    [self fiexdData];
    _userTableView.hidden = YES;
    
    UIView * footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 60)];
    UIButton * exitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    exitButton.frame = CGRectMake(20, 10, self.view.width - 40, 40);
    [exitButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [exitButton setTitle:@"退出登录" forState:UIControlStateNormal];
    exitButton.layer.borderColor = [UIColor orangeColor].CGColor;
    exitButton.layer.borderWidth = 1;
    [exitButton addTarget:self action:@selector(exitLogInAciton:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:exitButton];
    _userTableView.tableFooterView = footView;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:17]
                                                                    };
    self.navigationController.navigationBar.barTintColor = MAIN_COLOR;
    if ([UserInfo shareUserInfo].userId) {
//        [self removeLogInView];
        [self fiexdData];
        _userTableView.hidden = NO;
        _logInView.hidden = YES;
        self.navigationItem.title = @"会员中心";
        self.navigationController.tabBarItem.title = @"我的";
        [_logInView textFiledResignFirstResponder];
    }
    if (![WXApi isWXAppInstalled]) {
        _logInView.weixinButton.hidden = YES;
    }
}

- (void)userLogInAction:(UIButton *)button
{
    if (self.logInView.phoneTF.text.length == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入手机号" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }else if (self.logInView.passwordTF.text.length == 0)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入密码" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }else
    {
        NSDictionary * jsonDic = @{
                                   @"Command":@7,
                                   @"LoginType":@1,
                                   @"Account":self.logInView.phoneTF.text,
                                   @"Password":self.logInView.passwordTF.text,
                                   };
        [self requestDataWithDictionary:jsonDic];
//        [SVProgressHUD showWithStatus:@"登录中..." maskType:SVProgressHUDMaskTypeClear];
    }
    /*
    _userTableView.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
    [UIView commitAnimations];
    _logInView.hidden = YES;
    self.navigationItem.title = @"会员中心";
     */
    
    [_logInView textFiledResignFirstResponder];
    
}


- (void)showUserInfoViewWithCode:(NSString *)code
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
            [self saveAuthorizeDate];//保存获取refresh_token的时间
            //验证授权是否可用(验证access_token)
            NSString * yanzhengURLSTR = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/auth?access_token=%@&openid=%@", [dic objectForKey:@"access_token"], [dic objectForKey:@"openid"]];
            NSURLRequest * yzRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:yanzhengURLSTR]];
            NSData * yzData = [NSURLConnection sendSynchronousRequest:yzRequest returningResponse:nil error:nil];
            if (yzData) {
                NSDictionary * yzDic = [NSJSONSerialization JSONObjectWithData:yzData options:0 error:nil];
                if ([[yzDic objectForKey:@"errcode"] isEqual:@0]) {
                    NSString * infoURLSTR = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@&lang=zh_CN", [dic objectForKey:@"access_token"], [dic objectForKey:@"openid"]];
                    NSURLRequest * infoRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:infoURLSTR]];
                    NSData * infoData = [NSURLConnection sendSynchronousRequest:infoRequest returningResponse:nil error:nil];
                    if (infoData) {
                        NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:infoData options:0 error:nil];
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
                        [self requestDataWithDictionary:jsonDic];
                    }
                }
            }
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

- (void)removeLogInView{
    [self fiexdData];
    _userTableView.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
    [UIView commitAnimations];
    _logInView.hidden = YES;
    self.navigationItem.title = @"会员中心";
    self.navigationController.tabBarItem.title = @"我的";
    [_logInView textFiledResignFirstResponder];
    //    HTTPPost * http = [HTTPPost shareHTTPPost];
    //    http.delegate = self;
    //    NSString * urlString = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=wxaac5e5f7421e84ac&secret=055e7e10c698b7b140511d8d1a73cec4&code=%@&grant_type=authorization_code", code];
    //    [http getWithUrlStr:urlString];
}

- (void)registerUser:(UIButton *)button
{
    
    if ([WXApi isWXAppInstalled]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请使用微信登陆注册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请到官网(www.vlifee.com)进行注册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    

    /*
    RegisterViewController * registerVC = [[RegisterViewController alloc] init];
    UserViewController * userVC = self;
    [registerVC returnSucceedRegister:^{
        [userVC removeLogInView];
//        [userVC fiexdData];
    }];
    registerVC.hidesBottomBarWhenPushed= YES;
    [self.navigationController pushViewController:registerVC animated:YES];
    */
}


- (void)weixinLogIn:(UIButton *)button//微信登陆
{
//    NSLog(@"微信登陆");
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"refresh_token"]) {
//        if ([self compareDate]) {
//            [self avoidweixinAuthorizeLogIn];
//        }else
//        {
            [self weixinAuthorizeLogIn];
//        }
//    }else
//    {
//        [self weixinAuthorizeLogIn];
//    }
}

- (void)exitLogInAciton:(UIButton *)button
{
    _logInView.hidden = NO;
    if (![WXApi isWXAppInstalled]) {
        _logInView.weixinButton.hidden = YES;
    }
    _userTableView.hidden = YES;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:_userTableView cache:YES];
    [UIView commitAnimations];
    self.navigationItem.title = @"会员中心";
    NSLog(@"退出登录");
    [[NSUserDefaults standardUserDefaults] setValue:@NO forKey:@"haveLogIn"];
    self.title = @"登陆";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"registrationID"]) {
        NSDictionary * dic = @{
                               @"Command":@37,
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Device":@1,
                               @"CID":[[NSUserDefaults standardUserDefaults] objectForKey:@"registrationID"]
                               };
        [self requestDataWithDictionary:dic];
    }
    
   
    
    [UserInfo shareUserInfo].userId = nil;
}

- (void)fiexdData
{
    self.dataArray = nil;
    NSArray * titleAry = @[[NSString stringWithFormat:@"%@", [UserInfo shareUserInfo].name], @"密码", [NSString stringWithFormat:@"手机号:%@", [UserInfo shareUserInfo].phoneNumber], @"外卖订单", @"酒店订单", [NSString stringWithFormat:@"客服电话:%@", [UserInfo shareUserInfo].servicePhone]];
    for (int i = 0; i < titleAry.count; i++) {
        UserModel * model = [[UserModel alloc] init];
//        NSLog(@"%@", [titleAry objectAtIndex:i]);
        model.title = [titleAry objectAtIndex:i];
        model.iconStr = [NSString stringWithFormat:@"user_%d", i];
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:@"修改"];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.5 alpha:1] range:NSMakeRange(0, string.length)];
        model.buttonStr = [string copy];
        if (i == 3) {
            NSString * str = [NSString stringWithFormat:@"%@", [UserInfo shareUserInfo].wakeoutOrderCount];
            NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:str];
            [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, attriStr.length)];
            model.buttonStr = [attriStr copy];
        }
        if (i == 4) {
            NSString * str = [NSString stringWithFormat:@"%@", [UserInfo shareUserInfo].hotelOrderCount];
            NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:str];
            [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, attriStr.length)];
            model.buttonStr = [attriStr copy];
        }
        if (i == 5) {
            model.buttonStr = nil;
        }
        [self.dataArray addObject:model];
    }
    [self.userTableView reloadData];

//    NSLog(@"ary = %@", _dataArray);
}


#pragma mark - 数据请求

- (void)requestDataWithDictionary:(NSDictionary *)dic
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
    NSLog(@"%@, error = %@", data, [data objectForKey:@"ErrorMsg"]);
//    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
//        [[UserInfo shareUserInfo] setPropertyWithDictionary:[data objectForKey:@"UserInfo"]];
//        [self removeLogInView];
//    }
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        if ([[data objectForKey:@"Command"] isEqualToNumber:@10007] || [[data objectForKey:@"Command"] isEqualToNumber:@10009]) {
            [[UserInfo shareUserInfo] setValuesForKeysWithDictionary:[data objectForKey:@"UserInfo"]];
            if ([[data objectForKey:@"IsFirst"] isEqualToNumber:@YES]) {
                __weak UserViewController * userVC = self;
                WXLoginViewController * wxLoginVC = [[WXLoginViewController alloc] init];
                [wxLoginVC refreshUserInfo:^{
                    [userVC removeLogInView];
                }];
                UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:wxLoginVC];
                [self.navigationController presentViewController:nav animated:YES completion:nil];
            }else
            {
                [self removeLogInView];
                [[NSUserDefaults standardUserDefaults] setValue:[UserInfo shareUserInfo].phoneNumber forKey:@"account"];
                [[NSUserDefaults standardUserDefaults] setValue:[UserInfo shareUserInfo].password forKey:@"password"];
                [[NSUserDefaults standardUserDefaults] setValue:@YES forKey:@"haveLogIn"];
            }
        }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10037])
        {
            NSLog(@"解除绑定");
        }
        
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }
//    [SVProgressHUD dismiss];
}
- (void)failWithError:(NSError *)error
{
    NSLog(@"%@", error);
}


#pragma mark - tabelView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserModel * userModel = [self.dataArray objectAtIndex:indexPath.row];
    UserViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_INDENTIFIER];
    [cell createSubviewWithFrame:tableView.bounds];
    cell.modifyBT.tag = MODIFY_BUTTON_TAG + indexPath.row;
    [cell.modifyBT addTarget:self action:@selector(modifyAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.userModel = userModel;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UserViewCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        NSLog(@"外卖订单");
        UserTOOrderViewController * TOOrderVC = [[UserTOOrderViewController alloc] init];
        TOOrderVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:TOOrderVC animated:YES];
    }else if (indexPath.row == 4)
    {
        NSLog(@"酒店订单");
        GSOrderViewController * gsOrderVC = [[GSOrderViewController alloc] init];
        gsOrderVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:gsOrderVC animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3 | indexPath.row == 4) {
        return YES;
    }
    return NO;
}


- (void)modifyAction:(UIButton *)button
{
    __weak UserViewController * userVC = self;
    switch (button.tag) {
        case MODIFY_BUTTON_TAG:
        {
            NSLog(@"名称");
            ModifyNameViewController * nameVC = [[ModifyNameViewController alloc] init];
            [nameVC refreshUserName:^{
                [userVC fiexdData];
            }];
            nameVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:nameVC animated:YES];
        }
            break;
        
        case MODIFY_BUTTON_TAG + 1:
        {
             NSLog(@"密码");
            PasswordViewController * passwordVC = [[PasswordViewController alloc] init];
            passwordVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:passwordVC animated:YES];
        }
            break;
        case MODIFY_BUTTON_TAG + 2:
        {
             NSLog(@"手机号");
            PhoneViewController * phoneVC = [[PhoneViewController alloc] init];
            [phoneVC refreshUserInfo:^{
                [userVC fiexdData];
            }];
            [self.navigationController pushViewController:phoneVC animated:YES];
        }
            break;
        case MODIFY_BUTTON_TAG + 3:
        {
//             NSLog(@"外卖订单");
//            UserTOOrderViewController * TOOrderVC = [[UserTOOrderViewController alloc] init];
//            TOOrderVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:TOOrderVC animated:YES];
        }
            break;
        case MODIFY_BUTTON_TAG + 4:
        {
//             NSLog(@"酒店订单");
//            GSOrderViewController * gsOrderVC = [[GSOrderViewController alloc] init];
//            gsOrderVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:gsOrderVC animated:YES];
        }
            break;
        default:
            break;
    }
}


#pragma marc - 微信登陆

//发送授权请求
- (void)weixinAuthorizeLogIn
{
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        SendAuthReq * req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"123456789";
        //    [WXApi sendReq:req];
        [WXApi sendAuthReq:req viewController:self delegate:self];
    }else if([WXApi isWXAppInstalled] == NO)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"你的设备还没安装微信,请先安装微信" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }else if([WXApi isWXAppSupportApi] == NO)
    {
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
                        [self requestDataWithDictionary:jsonDic];
                    }
                }
            }
        }
    }
}

/*
#pragma mark - 手机号码验证
+ (BOOL)isTelPhoneNub:(NSString *)str
{
    if (str.length < 11)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    else
    {
        NSString *regex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isMatch = [pred evaluateWithObject:str];
        if (!isMatch) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
        else
        {
            return YES;
        }
    }
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
