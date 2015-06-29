
//
//  DetailTakeOutViewController.m
//  vlifree
//
//  Created by 仙林 on 15/5/25.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "DetailTakeOutViewController.h"
#import "ClassesViewCell.h"
#import "MenusViewCell.h"
#import "ShoppingCartView.h"
#import "ShoppingDetailsCarView.h"
#import "TakeOutOrderViewController.h"
#import "AlertLoginView.h"
#import "WXLoginViewController.h"

#define SECTION_TABLEVIEW_CELL @"SECTIONCELL"
#define MENUS_TABLEVIEW_CELL @"MENUSCELL"

#define SUBTRACT_BUTTON_TAG 1000
#define ADD_BUTTON_TAG 2000

#define SHOPPINGCARVIEW_HEIGHT 55


@interface DetailTakeOutViewController ()<UITableViewDataSource, UITableViewDelegate, HTTPPostDelegate>


@property (nonatomic, strong)UITableView * sectionTableView;
@property (nonatomic, strong)UITableView * menusTableView;

@property (nonatomic, strong)ShoppingCartView * shoppingCarView;
@property (nonatomic, strong)ShoppingDetailsCarView * shoppingCarDetailsView;


@property (nonatomic, strong)NSMutableArray * classArray;
@property (nonatomic, strong)NSMutableArray * menusArray;

@property (nonatomic, strong)NSMutableArray * shopArray;
@property (nonatomic, strong)AlertLoginView * alertLoginV;

@end

@implementation DetailTakeOutViewController

- (NSMutableArray *)classArray
{
    if (!_classArray) {
        self.classArray = [NSMutableArray array];
    }
    return _classArray;
}

- (NSMutableArray *)menusArray
{
    if (!_menusArray) {
        self.menusArray = [NSMutableArray array];
    }
    return _menusArray;
}


- (NSMutableArray *)shopArray
{
    if (!_shopArray) {
        self.shopArray = [NSMutableArray array];
    }
    return _shopArray;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"key = %@,\n object = %@, \n change = %@", keyPath, object, change);
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"shopArray"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    [self addObserver:self forKeyPath:@"shopArray" options:NSKeyValueObservingOptionNew context:nil];
    
    UIView * noticeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, self.view.width, 30)];
    noticeView.backgroundColor = [UIColor colorWithRed:254 / 255.0 green:231 / 255.0 blue:232 / 255.0 alpha:1];
    [self.view addSubview:noticeView];
    
    UIImageView * aImageV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    aImageV.image = [UIImage imageNamed:@"laba.png"];
    [noticeView addSubview:aImageV];
    
    UILabel * noticeLB = [[UILabel alloc] initWithFrame:CGRectMake(aImageV.right + 5, 5, noticeView.width - aImageV.right - 40, 20)];
    noticeLB.text = @"欢迎商家测试使用";
    [noticeView addSubview:noticeLB];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(noticeLB.right + 10, 5, 20, 20);
    [button setBackgroundImage:[UIImage imageNamed:@"xx.png ≈"] forState:UIControlStateNormal];
    [noticeView addSubview:button];
    
    
    self.sectionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, noticeView.bottom, 80, self.view.height - SHOPPINGCARVIEW_HEIGHT - noticeView.height - self.navigationController.navigationBar.bottom) style:UITableViewStylePlain];
    _sectionTableView.dataSource = self;
    _sectionTableView.delegate = self;
    _sectionTableView.tableFooterView = [[UIView alloc] init];
//    [_sectionTableView set]
    [_sectionTableView registerClass:[ClassesViewCell class] forCellReuseIdentifier:SECTION_TABLEVIEW_CELL];
    [_sectionTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
//    _sectionTableView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_sectionTableView];
    
    self.menusTableView = [[UITableView alloc] initWithFrame:CGRectMake(_sectionTableView.right, noticeView.bottom, self.view.width - 80, self.view.height - self.navigationController.navigationBar.bottom - SHOPPINGCARVIEW_HEIGHT - noticeView.height) style:UITableViewStylePlain];
    _menusTableView.delegate = self;
    _menusTableView.dataSource = self;
    _menusTableView.tableFooterView = [[UIView alloc] init];
    [_menusTableView registerClass:[MenusViewCell class] forCellReuseIdentifier:MENUS_TABLEVIEW_CELL];
//    _menusTableView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_menusTableView];
    
    
    self.shoppingCarView = [[ShoppingCartView alloc] initWithFrame:CGRectMake(0, _menusTableView.bottom, self.view.width, SHOPPINGCARVIEW_HEIGHT)];
    _shoppingCarView.backgroundColor = [UIColor whiteColor];
    [_shoppingCarView.shoppingCarBT addTarget:self action:@selector(addShoppingCarDetailsViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [_shoppingCarView.changeButton addTarget:self action:@selector(confirmMenusAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shoppingCarView];
//    _shoppingCarView.backgroundColor = [UIColor greenColor];
    
    UIButton * backBT = [UIButton buttonWithType:UIButtonTypeCustom];
    backBT.frame = CGRectMake(0, 0, 15, 20);
    [backBT setBackgroundImage:[UIImage imageNamed:@"back_r.png"] forState:UIControlStateNormal];
    [backBT addTarget:self action:@selector(backLastVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBT];
    
    
    [self downloadData];
    
//    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    // Do any additional setup after loading the view.
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)confirmMenusAction:(UIButton *)button
{
    if ([UserInfo shareUserInfo].userId) {
        if ([button isEqual:_shoppingCarDetailsView.changeBT]) {
            [self.shoppingCarDetailsView removeFromSuperview];
            [self getAllPrice];
            [self getAllCount];
        }
        NSMutableArray * array = [NSMutableArray array];
        for (NSMutableArray * smallAry in self.shopArray) {
            MenuModel * menuMD = [smallAry firstObject];
            NSDictionary * dic = @{
                                   @"Id":menuMD.Id,
                                   @"Count":[NSNumber numberWithInteger:menuMD.count],
                                   @"Name":menuMD.name,
                                   @"Price":menuMD.price
                                   };
            [array addObject:dic];
        }
        NSDictionary * jsonDic = @{
                                   @"Command":@31,
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"StoreId":self.takeOutID,
                                   @"ShoppingList":array
                                   };
        [self playPostWithDictionary:jsonDic];
    }else
    {
        self.alertLoginV = [[AlertLoginView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_alertLoginV.logInButton addTarget:self action:@selector(userLogInAction:) forControlEvents:UIControlEventTouchUpInside];
        [_alertLoginV.weixinButton addTarget:self action:@selector(weixinLogIn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view.window addSubview:_alertLoginV];
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
//        [alert show];
    }
    
}


- (void)addShoppingCarDetailsViewAction:(UIButton *)button
{
    if (self.shopArray.count > 0) {
        self.shoppingCarDetailsView = [[ShoppingDetailsCarView alloc] initWithFrame:[[UIScreen mainScreen] bounds] withMneusArray:self.shopArray];
        self.shoppingCarDetailsView.sendPrice = self.sendPrice;
        [self.shoppingCarDetailsView.shoppingCarBT addTarget:self action:@selector(removeShoppingCarDetailsViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [_shoppingCarDetailsView.changeBT addTarget:self action:@selector(confirmMenusAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view.window addSubview:_shoppingCarDetailsView];
    }
}


- (void)removeShoppingCarDetailsViewAction:(UIButton *)button
{
    [self.shoppingCarDetailsView removeFromSuperview];
    [self getAllPrice];
    [self getAllCount];
}

#pragma mark - 数据请求
- (void)downloadData
{
    
    NSDictionary * jsonDic = @{
                               @"Command":@12,
                               @"StoreId":self.takeOutID
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
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        if ([[data objectForKey:@"Command"] intValue] == 10012) {
            NSArray * array = [data objectForKey:@"CatalogueList"];
            for (int i = 0; i < array.count; i++) {
                NSDictionary * dic = [array objectAtIndex:i];
                ClassModel * classMD = [[ClassModel alloc] initWithDictionary:dic];
                if (i == 0) {
                    NSDictionary * jsonDic = @{
                                               @"Command" : @13,
                                               @"Id" : classMD.Id
                                               };
                    [self playPostWithDictionary:jsonDic];
                }
                [self.classArray addObject:classMD];
            }
            [self.sectionTableView reloadData];
            [_sectionTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10013])
        {
            self.menusArray = nil;
            NSArray * array = [data objectForKey:@"BusinessList"];
            for (NSDictionary * dic in array) {
                MenuModel * menuMD = [[MenuModel alloc] initWithDictionary:dic];
                if (self.shopArray.count != 0) {
                    for (NSMutableArray * smallAry in self.shopArray) {
                        MenuModel * shopMenuMD = [smallAry firstObject];
                        if ([shopMenuMD.Id isEqualToNumber:menuMD.Id]) {
                            menuMD = shopMenuMD;
                        }
                    }
                }
                [self.menusArray addObject:menuMD];
            }
            [self.menusTableView reloadData];
        }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10009] || [[data objectForKey:@"Command"] isEqualToNumber:@10007]) {
            [[UserInfo shareUserInfo] setValuesForKeysWithDictionary:[data objectForKey:@"UserInfo"]];
            if ([[data objectForKey:@"IsFirst"] isEqualToNumber:@YES]) {
                //                DetailsGrogshopViewController * detailsGSVC = self;
                WXLoginViewController * wxLoginVC = [[WXLoginViewController alloc] init];
                [wxLoginVC refreshUserInfo:^{
                    [self.alertLoginV removeFromSuperview];
                }];
                UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:wxLoginVC];
                [self.navigationController presentViewController:nav animated:YES completion:nil];
            }else
            {
                [self.alertLoginV removeFromSuperview];
            }
            
        }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10031])
        {
            TakeOutOrderViewController * orderVC = [[TakeOutOrderViewController alloc] init];
            orderVC.orderDic = data;
            orderVC.shopArray = self.shopArray;
            orderVC.takeOutId = self.takeOutID;
            [self.navigationController pushViewController:orderVC animated:YES];
        }
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
    }

    [SVProgressHUD dismiss];
}

- (void)failWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    NSLog(@"%@", error);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_sectionTableView]) {
        return self.classArray.count;
        return 15;
    }
    return self.menusArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_sectionTableView]) {
        ClassModel * classMD = [self.classArray objectAtIndex:indexPath.row];
        ClassesViewCell * sectionCell = [tableView dequeueReusableCellWithIdentifier:SECTION_TABLEVIEW_CELL];
        [sectionCell createSubviewWithFrame:tableView.bounds];
        sectionCell.classModel = classMD;
        return sectionCell;
    }
    MenuModel * menuMD = [self.menusArray objectAtIndex:indexPath.row];
    MenusViewCell * cell = [tableView dequeueReusableCellWithIdentifier:MENUS_TABLEVIEW_CELL];
    [cell createSubview:tableView.bounds];
    [cell.subtractBT addTarget:self action:@selector(subtractMenuCount:) forControlEvents:UIControlEventTouchUpInside];
    cell.subtractBT.tag = indexPath.row + SUBTRACT_BUTTON_TAG;
    [cell.addButton addTarget:self action:@selector(addMenuCount:) forControlEvents:UIControlEventTouchUpInside];
    cell.addButton.tag = indexPath.row + ADD_BUTTON_TAG;
    cell.menuModel = menuMD;
//    cell.textLabel.text = @"menu";
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_sectionTableView]) {
        ClassModel * classMD = [self.classArray objectAtIndex:indexPath.row];
        return [ClassesViewCell cellHeightWithString:classMD.title frame:tableView.bounds];
    }
    return [MenusViewCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.sectionTableView]) {
        ClassModel * classMD = [self.classArray objectAtIndex:indexPath.row];
        NSDictionary * dic = @{
                               @"Command" : @13,
                               @"Id" : classMD.Id
                               };
        [self playPostWithDictionary:dic];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_menusTableView]) {
        return NO;
    }
    return YES;
}


#pragma mark - 加减选菜个数

- (void)subtractMenuCount:(UIButton *)button
{
//    MenusViewCell * cell = (MenusViewCell *)[self.menusTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag - SUBTRACT_BUTTON_TAG inSection:0]];
    MenuModel * menuMD = [self.menusArray objectAtIndex:button.tag - SUBTRACT_BUTTON_TAG];
    menuMD.count -= 1;
//    NSInteger count = [self.shoppingCarView.countLabel.text integerValue];
//    cell.countLabel.text = [NSString stringWithFormat:@"%ld", [cell.countLabel.text integerValue] - 1];
//    if ([cell.countLabel.text integerValue] == 0) {
//        button.hidden = YES;
//    }
//    if (count == 1) {
//        self.shoppingCarView.changeButton.enabled = NO;
//    }
    double allPrice = 0;
//    NSLog(@"/// %@, %@", self.shopArray, [self.shopArray firstObject]);
    for (int i = 0; i < self.shopArray.count; i++) {
        NSMutableArray * ary = [self.shopArray objectAtIndex:i];
        MenuModel * menuMD1 = [ary firstObject];
        if ([menuMD1 isEqual:menuMD]) {
            [ary removeLastObject];
        }
        if (ary.count == 0) {
            [self.shopArray removeObject:ary];
            continue;
        }
        for (MenuModel * menuMD2 in ary) {
            allPrice += [menuMD2.price doubleValue];
        }
    }
    NSLog(@"-- shop = %@", self.shopArray);
    if (allPrice < [self.sendPrice doubleValue]) {
        self.shoppingCarView.changeButton.enabled = NO;
    }
    
    self.shoppingCarView.priceLabel.text = [NSString stringWithFormat:@"¥%g元", allPrice];
    self.shoppingCarView.countLabel.text = [NSString stringWithFormat:@"%ld", [self.shoppingCarView.countLabel.text integerValue] - 1];
}

- (void)addMenuCount:(UIButton *)button
{
//    MenusViewCell * cell = (MenusViewCell *)[self.menusTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag - ADD_BUTTON_TAG inSection:0]];
    MenuModel * menuMD = [self.menusArray objectAtIndex:button.tag - ADD_BUTTON_TAG];
    menuMD.count += 1;
//    NSInteger count = [cell.countLabel.text integerValue];
//    cell.countLabel.text = [NSString stringWithFormat:@"%ld", count + 1];
//    cell.subtractBT.hidden = NO;
    self.shoppingCarView.countLabel.text = [NSString stringWithFormat:@"%ld", [self.shoppingCarView.countLabel.text integerValue] + 1];
    if (self.shopArray.count == 0) {
        NSMutableArray * array = [NSMutableArray array];
        [array addObject:menuMD];
        [self.shopArray addObject:array];
        if ([menuMD.price doubleValue] > [self.sendPrice doubleValue] || [menuMD.price doubleValue] == [self.sendPrice doubleValue]) {
            self.shoppingCarView.changeButton.enabled = YES;
        }
        self.shoppingCarView.priceLabel.text = [NSString stringWithFormat:@"¥%@元", menuMD.price];
    }else
    {
        BOOL have = NO;
        for (NSMutableArray * smallAry in self.shopArray) {
            if ([[smallAry firstObject] isEqual:menuMD]) {
                [smallAry addObject:menuMD];
                have = YES;
                break;
            }
        }
        if (!have) {
            NSMutableArray * smallAry = [NSMutableArray array];
            [smallAry addObject:menuMD];
            [self.shopArray addObject:smallAry];
        }
        [self getAllPrice];
    }
    NSLog(@"shop = %@", self.shopArray);
    CGRect cellFrame = [self.menusTableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag - ADD_BUTTON_TAG inSection:0]];
    CGRect btFrame = button.frame;
    btFrame.origin.x = btFrame.origin.x + self.menusTableView.left;
    btFrame.origin.y = cellFrame.origin.y - self.menusTableView.contentOffset.y + button.origin.y + self.menusTableView.top;
    [self countLBAnimateWithFromeFrame:btFrame];
    
}

- (void)getAllPrice
{
    double allPrice = 0;
    for (NSMutableArray * smallAry in self.shopArray) {
        for (MenuModel * menuMD1 in smallAry) {
            allPrice += [menuMD1.price doubleValue];
        }
    }
    if (allPrice < [self.sendPrice doubleValue]) {
        self.shoppingCarView.changeButton.enabled = NO;
    }else
    {
        self.shoppingCarView.changeButton.enabled = YES;
    }
    self.shoppingCarView.priceLabel.text = [NSString stringWithFormat:@"¥%g元", allPrice];
}


- (void)getAllCount
{
    NSInteger allCount = 0;
    for (NSMutableArray * smallAry in self.shopArray) {
        allCount += smallAry.count;
    }
    self.shoppingCarView.countLabel.text = [NSString stringWithFormat:@"%ld", allCount];
}

- (void)countLBAnimateWithFromeFrame:(CGRect)frame
{
    UILabel * redView = [[UILabel alloc] initWithFrame:frame];
    redView.size = CGSizeMake(20, 20);
    redView.text = @"1";
    redView.textAlignment = NSTextAlignmentCenter;
    redView.textColor = [UIColor whiteColor];
    redView.layer.backgroundColor = [UIColor redColor].CGColor;
    redView.layer.cornerRadius = 10;
    [self.view addSubview:redView];
    CGRect rect = CGRectMake(65, _shoppingCarView.top - 10, 20, 20);
    [UIView animateWithDuration:0.8 animations:^{
        redView.frame = rect;
    }];
    [redView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.8];
}


#pragma mark - 提示登陆页面

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
    }
}

- (void)weixinLogIn:(UIButton *)button//微信登陆
{
    NSLog(@"微信登陆");
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

//发送授权请求
- (void)weixinAuthorizeLogIn
{
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        SendAuthReq * req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"123456789";
        [WXApi sendReq:req];
        //        [WXApi sendAuthReq:req viewController:self delegate:self];
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
                        [self playPostWithDictionary:jsonDic];
                        [SVProgressHUD showWithStatus:@"登录中..." maskType:SVProgressHUDMaskTypeBlack];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
