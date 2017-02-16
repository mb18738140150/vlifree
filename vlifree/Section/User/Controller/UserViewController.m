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
#import "AddressViewController.h"

#import "TOOrderViewCell.h"
#import "DetailsTOOrderViewController.h"
#import "OrderDetailsMD.h"

#import "GSOrderViewCell.h"
#import "DetailsGSOrderViewController.h"
#import "GSPayViewController.h"

#import "HomeViewCell.h"
#import "CollectModel.h"
#import "MGSwipeButton.h"
#import "DetailsGrogshopViewController.h"
#import "DetailTakeOutViewController.h"

#import "MSegmentControl.h"
#import "SettingController.h"

#define TAKEOUT_CELL_INDENTIFIER @"TAKEOUTCELL"
#define HOTEL_CELL_INDENTIFIER @"hotelcell"
#define COLLECT_CELL_INDENTIFIER @"COLLECTcell"
#define MODIFY_BUTTON_TAG 1000

#define TOP_SPACE 10
#define SEPARATE_SPACE 15
#define LEFT_SPACE 10
#define LABEL_HEIGHT 15
#define LABEL_FONT [UIFont systemFontOfSize:15]



@interface UserViewController ()<UITableViewDataSource, UITableViewDelegate, WXApiDelegate, HTTPPostDelegate, MSegmentedControlDelegate, UIScrollViewDelegate>

//@property (nonatomic, strong)UITableView * userTableView;

@property (nonatomic, strong)NSMutableArray * dataArray;

@property (nonatomic, strong)LogInView * logInView;

@property (nonatomic, strong)UIScrollView * myScrollView;// 底部scrollview
@property (nonatomic, strong)UIView * userInformationView;// 用户信息
@property (nonatomic, strong)UILabel * namelabel;
@property (nonatomic, strong)UILabel * phoneLabel;
@property (nonatomic, strong)UIView * addressView;// 管理收货地址
@property (nonatomic, strong)MSegmentControl * mSegmentControl;// 订单切换segment
@property (nonatomic, strong)UIScrollView * orderScrollview;// 订单切换scrollview

// 外卖订单
@property (nonatomic, strong)UITableView * takeOutOrderTableView;
@property (nonatomic, strong)NSMutableArray * takeOutdataArray;
@property (nonatomic, strong)NSNumber * takeoutAllCount;
@property (nonatomic, assign)int takeoutPage;
// 酒店订单
@property (nonatomic, strong)UITableView * gsOrderTableView;
@property (nonatomic, strong)NSMutableArray * gsdataArray;
@property (nonatomic, strong)NSNumber * gsAllCount;
@property (nonatomic, assign)int gsPage;
@property (nonatomic, assign)int gsSlectPage;
// 我的收藏
@property (nonatomic, strong)UITableView * colloctTableView;
@property (nonatomic, strong)NSMutableArray * colloctdataArray;
@property (nonatomic, strong)NSNumber * colloctAllCount;
@property (nonatomic, assign)int colloctPage;
@property (nonatomic, strong)CollectModel * collectModel;

@property (nonatomic, strong)JGProgressHUD * hud;

@property (nonatomic, assign)int pushTocommentVc;

@end

@implementation UserViewController

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)takeOutdataArray
{
    if (!_takeOutdataArray) {
        self.takeOutdataArray = [NSMutableArray array];
    }
    return _takeOutdataArray;
}

- (NSMutableArray *)gsdataArray
{
    if (!_gsdataArray) {
        self.gsdataArray = [NSMutableArray array];
    }
    return _gsdataArray;
}

- (NSMutableArray *)colloctdataArray
{
    if (!_colloctdataArray) {
        self.colloctdataArray = [NSMutableArray array];
    }
    return _colloctdataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
//    self.navigationController.navigationBar.translucent = NO;
    
    self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(collectCountChangeaction:) name:CollectCountCHange object:nil];
    
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"shezhi.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(setupAction:)];
    
    
    self.logInView = [[LogInView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, self.view.width, self.view.height - self.navigationController.navigationBar.bottom)];
//    _logInView.backgroundColor = [UIColor grayColor];
    [_logInView.logInButton addTarget:self action:@selector(userLogInAction:) forControlEvents:UIControlEventTouchUpInside];
    [_logInView.registerButton addTarget:self action:@selector(registerUser:) forControlEvents:UIControlEventTouchUpInside];
    [_logInView.weixinButton addTarget:self action:@selector(weixinLogIn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_logInView];
    
    
    self.myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64 - self.tabBarController.tabBar.height)];
    _myScrollView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    _myScrollView.hidden = YES;
    _myScrollView.delegate = self;
    [self.view addSubview:_myScrollView];
//    self.userTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, self.view.width, self.view.height - self.navigationController.navigationBar.bottom - self.tabBarController.tabBar.height) style:UITableViewStylePlain];
//    _userTableView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
//    _userTableView.dataSource = self;
//    _userTableView.delegate = self;
//    [_userTableView registerClass:[UserViewCell class] forCellReuseIdentifier:CELL_INDENTIFIER];
//    _userTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
////    [self.view addSubview:_userTableView];
////    [self fiexdData];
//    _userTableView.hidden = YES;
//    
//    UIView * footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 60)];
//    UIButton * exitButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    exitButton.frame = CGRectMake(20, 10, self.view.width - 40, 40);
//    [exitButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [exitButton setTitle:@"退出登录" forState:UIControlStateNormal];
//    exitButton.layer.borderColor = [UIColor orangeColor].CGColor;
//    exitButton.layer.borderWidth = 1;
//    [exitButton addTarget:self action:@selector(exitLogInAciton:) forControlEvents:UIControlEventTouchUpInside];
//    [footView addSubview:exitButton];
//    _userTableView.tableFooterView = footView;
    
    
    
    [self creatsubViews];
    
    // Do any additional setup after loading the view.
}

- (void)creatsubViews
{
    if ([UserInfo shareUserInfo].userId) {
        // 个人信息
        if (!self.userInformationView) {
            self.userInformationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _myScrollView.width, 75)];
            _userInformationView.backgroundColor = [UIColor whiteColor];
            [_myScrollView addSubview:_userInformationView];
            
            self.namelabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, SEPARATE_SPACE, 200,LABEL_HEIGHT )];
            _namelabel.backgroundColor = [UIColor whiteColor];
            _namelabel.font = LABEL_FONT;
            _namelabel.text = [NSString stringWithFormat:@"%@", [UserInfo shareUserInfo].name];
            [_userInformationView addSubview:_namelabel];
            
            self.phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, _namelabel.bottom + SEPARATE_SPACE, _namelabel.width, _namelabel.height)];
            _phoneLabel.backgroundColor = [UIColor whiteColor];
            _phoneLabel.font = LABEL_FONT;
            _phoneLabel.text = [NSString stringWithFormat:@"%@", [UserInfo shareUserInfo].phoneNumber];
            [_userInformationView addSubview:_phoneLabel];
            
            UIButton * userInformationBt = [UIButton buttonWithType:UIButtonTypeCustom];
            userInformationBt.frame = CGRectMake(_userInformationView.width - 40, _userInformationView.height / 2 - 15, 30, 30);
            [userInformationBt setImage:[UIImage imageNamed:@"go.png"] forState:UIControlStateNormal];
            [_userInformationView addSubview:userInformationBt];
            [userInformationBt addTarget:self action:@selector(setupUserinformation:) forControlEvents:UIControlEventTouchUpInside];
            
            // 管理地址
            self.addressView = [[UIView alloc]initWithFrame:CGRectMake(0, _userInformationView.bottom + TOP_SPACE, _myScrollView.width, 45)];
            _addressView.backgroundColor = [UIColor whiteColor];
            [_myScrollView addSubview:_addressView];
            
            UIImageView * seleteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, SEPARATE_SPACE - 1, 18, 18)];
            seleteImageView.backgroundColor = [UIColor whiteColor];
            seleteImageView.image = [UIImage imageNamed:@"defaultaddress.png"];
            [self.addressView addSubview:seleteImageView];
            
            UILabel * addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(seleteImageView.right + LEFT_SPACE, SEPARATE_SPACE, 200, LABEL_HEIGHT)];
            addressLabel.text = @"管理收货地址";
            addressLabel.font = LABEL_FONT;
            addressLabel.backgroundColor = [UIColor whiteColor];
            [_addressView addSubview:addressLabel];
            
            UIButton * addressBt = [UIButton buttonWithType:UIButtonTypeCustom];
            addressBt.frame = CGRectMake(_addressView.width - 40, _addressView.height / 2 - 15, 30, 30);
            [addressBt setImage:[UIImage imageNamed:@"go.png"] forState:UIControlStateNormal];
            [_addressView addSubview:addressBt];
            [addressBt addTarget:self action:@selector(changeAddressAction:) forControlEvents:UIControlEventTouchUpInside];
            
            
            // 我的订单及收藏
            NSString * takeoutstr = [NSString stringWithFormat:@"外卖订单(%@)", [UserInfo shareUserInfo].wakeoutOrderCount];
            NSString * gsStr = [NSString stringWithFormat:@"酒店订单(%@)", [UserInfo shareUserInfo].hotelOrderCount];
            NSString * collectCountStr = [NSString stringWithFormat:@"我的收藏(%@)", [UserInfo shareUserInfo].collectCount];
            self.mSegmentControl = [[MSegmentControl alloc] initWithOriginY:_addressView.bottom + TOP_SPACE Titles:@[takeoutstr, gsStr,collectCountStr] delegate:self];
            [self.myScrollView addSubview:_mSegmentControl];
            
            self.orderScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _mSegmentControl.bottom, _myScrollView.width, _myScrollView.height - _mSegmentControl.bottom)];
            self.orderScrollview.contentSize = CGSizeMake(self.view.width * 3, _orderScrollview.height);
            _orderScrollview.backgroundColor = [UIColor whiteColor];
            _orderScrollview.delegate = self;
            _orderScrollview.pagingEnabled = YES;
            [_myScrollView addSubview:_orderScrollview];
            
            // 外卖订单
            self.takeOutOrderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, _orderScrollview.width, _orderScrollview.height)];
            self.takeOutOrderTableView.delegate = self;
            self.takeOutOrderTableView.dataSource = self;
            self.takeOutOrderTableView.scrollsToTop = YES;
            [self.takeOutOrderTableView registerClass:[TOOrderViewCell class] forCellReuseIdentifier:TAKEOUT_CELL_INDENTIFIER];
            self.takeOutOrderTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
            self.takeOutOrderTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
            _takeoutPage = 1;
            //        [self downloadDataWithCommand:@23 page:_takeoutPage count:COUNT];
            [_orderScrollview addSubview:_takeOutOrderTableView];
            
            // 酒店订单
            self.gsOrderTableView = [[UITableView alloc]initWithFrame:CGRectMake(_orderScrollview.width, 0, _orderScrollview.width, _orderScrollview.height)];
            self.gsOrderTableView.delegate = self;
            self.gsOrderTableView.dataSource = self;
            self.gsOrderTableView.scrollsToTop = YES;
            [self.gsOrderTableView registerClass:[GSOrderViewCell class] forCellReuseIdentifier:HOTEL_CELL_INDENTIFIER];
            self.gsOrderTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
            self.gsOrderTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
            _gsPage = 1;
            _gsSlectPage = 0;
            //    self.gsOrderTableView.backgroundColor = [UIColor orangeColor];
            [_orderScrollview addSubview:_gsOrderTableView];
            
            
            // 我的收藏
            self.colloctTableView = [[UITableView alloc]initWithFrame:CGRectMake(_orderScrollview.width * 2, 0, _orderScrollview.width, _orderScrollview.height)];
            self.colloctTableView.delegate = self;
            self.colloctTableView.dataSource = self;
            self.colloctTableView.scrollsToTop = YES;
            _colloctPage = 1;
            [self.colloctTableView registerClass:[HomeViewCell class] forCellReuseIdentifier:COLLECT_CELL_INDENTIFIER];
            self.colloctTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
            self.colloctTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
            //    _colloctTableView.backgroundColor = [UIColor redColor];
            [_orderScrollview addSubview:_colloctTableView];
            
            _myScrollView.contentSize = CGSizeMake(_myScrollView.width, _orderScrollview.bottom + 10);
            
        }else
        {
             _namelabel.text = [NSString stringWithFormat:@"%@", [UserInfo shareUserInfo].name];
            _phoneLabel.text = [NSString stringWithFormat:@"%@", [UserInfo shareUserInfo].phoneNumber];
            NSString * takeoutstr = [NSString stringWithFormat:@"外卖订单(%@)", [UserInfo shareUserInfo].wakeoutOrderCount];
            NSString * gsStr = [NSString stringWithFormat:@"酒店订单(%@)", [UserInfo shareUserInfo].hotelOrderCount];
            NSString * collectCountStr = [NSString stringWithFormat:@"我的收藏(%@)", [UserInfo shareUserInfo].collectCount];
            [self.mSegmentControl changeTitles:@[takeoutstr, gsStr,collectCountStr]];
            
            [self.mSegmentControl changeSegmentedControlWithIndex:0];
            [self.takeOutOrderTableView.header beginRefreshing];
            
            _gsPage = 1;
            [self downloadDataWithCommand:@25 page:_gsPage count:COUNT];
             _colloctPage = 1;
            [self downloadDataWithCommand:@1 page:_colloctPage count:DATA_COUNT];
            
        }
        
    }else
    {
        
    }
    
}

#pragma mark - 刷新
- (void)headerRereshing
{
    if (self.mSegmentControl.selectIndex == 0) {
        _takeoutPage = 1;
        [self downloadDataWithCommand:@23 page:_takeoutPage count:COUNT];
    }else if (self.mSegmentControl.selectIndex == 1)
    {
        _gsPage = 1;
        [self downloadDataWithCommand:@25 page:_gsPage count:COUNT];
    }else if (self.mSegmentControl.selectIndex == 2)
    {
        _colloctPage = 1;
        [self downloadDataWithCommand:@1 page:_colloctPage count:DATA_COUNT];
    }
}

- (void)footerRereshing
{
    if (self.mSegmentControl.selectIndex == 0) {
        // 外卖
        if (self.takeOutdataArray.count < [_takeoutAllCount integerValue]) {
            [self.takeOutOrderTableView.footer resetNoMoreData];
            [self downloadDataWithCommand:@23 page:++_takeoutPage count:COUNT];
        }else
        {
            [self.takeOutOrderTableView.footer noticeNoMoreData];
        }
    }else if (self.mSegmentControl.selectIndex == 1)
    {
        // 酒店
        if (self.gsdataArray.count < [_gsAllCount integerValue]) {
            [self.gsOrderTableView.footer resetNoMoreData];
            [self downloadDataWithCommand:@25 page:++_gsPage count:COUNT];
        }else
        {
            [self.gsOrderTableView.footer noticeNoMoreData];
        }
    }else if (self.mSegmentControl.selectIndex == 2)
    {
        // 我的收藏
        if (self.colloctdataArray.count < [_colloctAllCount integerValue]) {
            [self.colloctTableView.footer resetNoMoreData];
            [self downloadDataWithCommand:@1 page:++_colloctPage count:COUNT];
        }else
        {
            [self.colloctTableView.footer noticeNoMoreData];
        }
    }
    
}
- (void)downloadDataWithCommand:(NSNumber *)command page:(int)page count:(int)count
{
//    [self.hud showInView:self.view];
    if ([command isEqualToNumber:@1]) {
        NSDictionary * jsonDic = @{
                                   @"Command":command,
                                   //                               @"CurPage":[NSNumber numberWithInt:page],
                                   //                               @"CurCount":[NSNumber numberWithInt:count],
                                   @"Lat":[NSNumber numberWithDouble:[UserLocation shareUserLocation].userLocation.latitude],
                                   @"Lon":[NSNumber numberWithDouble:[UserLocation shareUserLocation].userLocation.longitude],
                                   @"UserId":[UserInfo shareUserInfo].userId
                                   };
        [self requestDataWithDictionary:jsonDic];

    }else
    {
        NSDictionary * jsonDic = @{
                                   @"Command":command,
                                   @"CurPage":[NSNumber numberWithInt:page],
                                   @"CurCount":[NSNumber numberWithInt:count],
                                   @"UserId":[UserInfo shareUserInfo].userId
                                   };
        [self requestDataWithDictionary:jsonDic];
    }
}
#pragma mark - 设置个人信息
- (void)setupAction:(UIBarButtonItem *)item
{
    SettingController * setVC = [[SettingController alloc]init];
    setVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setVC animated:YES];
}
- (void)setupUserinformation:(UIButton *)button
{
    NSLog(@"设置个人信息");
    SettingController * setVC = [[SettingController alloc]init];
    setVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setVC animated:YES];
}
#pragma mark - 修改收货地址
- (void)changeAddressAction:(UIButton *)button
{
    AddressViewController * addVC = [[AddressViewController alloc]init];
    addVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addVC animated:YES];
}
#pragma mark - MSegmentedControl 代理方法
- (void)mSegmentedControlSelectAtIndex:(NSInteger)index
{
    [self.orderScrollview setContentOffset:CGPointMake(index * _orderScrollview.width, 0) animated:YES];
    if (index == 0) {
        if (self.takeOutdataArray.count == 0) {
            [self downloadDataWithCommand:@23 page:_takeoutPage count:COUNT];
        }
    }else if (index == 1)
    {
        if (self.gsdataArray.count == 0) {
            [self downloadDataWithCommand:@25 page:_gsPage count:COUNT];
        }
    }else if (index == 2)
    {
        if (self.colloctdataArray.count == 0) {
            [self downloadDataWithCommand:@1 page:_colloctPage count:DATA_COUNT];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSForegroundColorAttributeName: [UIColor blackColor],
                                                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:17]
                                                                    };
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
//    [[NSUserDefaults standardUserDefaults] objectForKey:@"haveLogIn"];
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"haveLogIn"] intValue] == 1) {
//        NSLog(@"已经登录了");
//    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"haveLogIn"] intValue] == 0)
//    {
//        NSLog(@"已经退出了");
//    }
    
    if ([UserInfo shareUserInfo].userId) {
//        [self removeLogInView];
        
        if (self.myScrollView.top != 64) {
            self.navigationController.navigationBar.alpha = 0;
        }else
        {
            [self fiexdData];
            
            
            _myScrollView.hidden = NO;
            _logInView.hidden = YES;
            self.navigationItem.title = @"我的";
            self.navigationController.tabBarItem.title = @"我的";
            [self.navigationItem.rightBarButtonItem setImage:[[UIImage imageNamed:@"shezhi.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            self.navigationItem.rightBarButtonItem.enabled = YES;
            [_logInView textFiledResignFirstResponder];
            
            NSDictionary * dic = @{
                                   @"Command":@27,
                                   @"UserId":[UserInfo shareUserInfo].userId
                                   };
            [self requestDataWithDictionary:dic];
//            self.navigationController.navigationBar.alpha = 1;
        }
        
        
    }else
    {
        _logInView.hidden = NO;
        if (![WXApi isWXAppInstalled]) {
            _logInView.weixinButton.hidden = YES;
        }
        _logInView.passwordTF.text = @"";
        _myScrollView.hidden = YES;
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:1];
//        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:_myScrollView cache:YES];
//        [UIView commitAnimations];
        self.navigationItem.title = @"登录";
        [self.navigationItem.rightBarButtonItem setImage:nil];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    if (![WXApi isWXAppInstalled]) {
        _logInView.weixinButton.hidden = YES;
    }
}

- (void)loginAgainAction
{
    _logInView.hidden = NO;
    if (![WXApi isWXAppInstalled]) {
        _logInView.weixinButton.hidden = YES;
    }
    _logInView.passwordTF.text = @"";
    _myScrollView.hidden = YES;
    //        [UIView beginAnimations:nil context:nil];
    //        [UIView setAnimationDuration:1];
    //        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:_myScrollView cache:YES];
    //        [UIView commitAnimations];
    self.navigationItem.title = @"登录";
    [self.navigationItem.rightBarButtonItem setImage:nil];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    if (![WXApi isWXAppInstalled]) {
        _logInView.weixinButton.hidden = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    
    if ([UserInfo shareUserInfo].userId) {
        if (self.myScrollView.top != 64) {
            self.navigationController.navigationBar.alpha = 0;
        }
        
        if (self.mSegmentControl.selectIndex == 0) {
            [self.takeOutOrderTableView.header beginRefreshing];;
        }else if (self.mSegmentControl.selectIndex == 1)
        {
            [self.gsOrderTableView.header beginRefreshing];
        }else if (self.mSegmentControl.selectIndex == 2)
        {
            [self.colloctTableView.header beginRefreshing];
        }
    }
    
    NSLog(@"******%f", self.myScrollView.top);
    
////    if (self.mSegmentControl.selectIndex == 0) {
////        _takeoutPage = 1;
//        [self downloadDataWithCommand:@23 page:_takeoutPage count:COUNT];
////    }else if (self.mSegmentControl.selectIndex == 1)
////    {
////        _gsPage = 1;
//        [self downloadDataWithCommand:@25 page:_gsPage count:COUNT];
////    }else if (self.mSegmentControl.selectIndex == 2)
////    {
////        _colloctPage = 1;
//        [self downloadDataWithCommand:@1 page:_colloctPage count:DATA_COUNT];
////    }
    
}
#pragma mark - 登录
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
//                        NSLog(@"user info = %@", infoDic);
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
    _myScrollView.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
    [UIView commitAnimations];
    _logInView.hidden = YES;
    self.navigationItem.title = @"我的";
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
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请使用微信登录注册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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


- (void)weixinLogIn:(UIButton *)button//微信登录
{
//    NSLog(@"微信登录");
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
    _myScrollView.hidden = YES;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:_myScrollView cache:YES];
    [UIView commitAnimations];
    self.navigationItem.title = @"我的";
//    NSLog(@"退出登录");
    [[NSUserDefaults standardUserDefaults] setValue:@NO forKey:@"haveLogIn"];
    self.title = @"登录";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"registrationID"]) {
        NSDictionary * dic = @{
                               @"Command":@37,
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Device":@1,
                               @"CID":[[NSUserDefaults standardUserDefaults] objectForKey:@"registrationID"]
                               };
        [self requestDataWithDictionary:dic];
    }else
    {
        NSDictionary * dic = @{
                               @"Command":@37,
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Device":@1,
                               @"CID":[NSNull null]
                               };
        [self requestDataWithDictionary:dic];
    }
    
   
    [self.hud showInView:self.view];
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
    
    self.namelabel.text = [NSString stringWithFormat:@"用户名: %@", [UserInfo shareUserInfo].name];
    self.phoneLabel.text = [NSString stringWithFormat:@"手机号: %@", [UserInfo shareUserInfo].phoneNumber];
    
    
    
//    [self.userTableView reloadData];

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
//    NSLog(@"%@, error = %@", data, [data objectForKey:@"ErrorMsg"]);
//    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
//        [[UserInfo shareUserInfo] setPropertyWithDictionary:[data objectForKey:@"UserInfo"]];
//        [self removeLogInView];
//    }
    [self.hud dismiss];
    NSLog(@"data = %@", data);
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        if ([[data objectForKey:@"Command"] isEqualToNumber:@10007] || [[data objectForKey:@"Command"] isEqualToNumber:@10009]) {
            
            [self.navigationItem.rightBarButtonItem setImage:[[UIImage imageNamed:@"shezhi.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            self.navigationItem.rightBarButtonItem.enabled = YES;
            
            [[UserInfo shareUserInfo] setValuesForKeysWithDictionary:[data objectForKey:@"UserInfo"]];
            
            if ([[data objectForKey:@"IsFirst"] isEqualToNumber:@YES]) {
                __weak UserViewController * userVC = self;
                WXLoginViewController * wxLoginVC = [[WXLoginViewController alloc] init];
                [wxLoginVC refreshUserInfo:^{
                    [userVC removeLogInView];
                    [userVC creatsubViews];
                }];
                UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:wxLoginVC];
                [self.navigationController presentViewController:nav animated:YES completion:nil];
            }else
            {
                [self removeLogInView];
                [self creatsubViews];
                [[NSUserDefaults standardUserDefaults] setValue:[UserInfo shareUserInfo].phoneNumber forKey:@"account"];
                [[NSUserDefaults standardUserDefaults] setValue:[UserInfo shareUserInfo].password forKey:@"password"];
                [[NSUserDefaults standardUserDefaults] setValue:@YES forKey:@"haveLogIn"];
            }
        }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10037])
        {
            NSLog(@"解除绑定");
        }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10027])
        {
            [[UserInfo shareUserInfo] setValuesForKeysWithDictionary:[data objectForKey:@"UserInfo"]];
            [self fiexdData];
            
//            if (self.mSegmentControl.selectIndex == 0) {
////                _takeoutPage = 1;
//                [self downloadDataWithCommand:@23 page:_takeoutPage count:COUNT];
//            }else if (self.mSegmentControl.selectIndex == 1)
//            {
////                _takeoutPage = 1;
//                [self downloadDataWithCommand:@25 page:_gsPage count:COUNT];
//            }else if (self.mSegmentControl.selectIndex == 2)
//            {
////                _colloctPage = 1;
//                [self downloadDataWithCommand:@1 page:_colloctPage count:DATA_COUNT];
//            }
            
        }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10023])
        {
            [self.takeOutOrderTableView.header endRefreshing];
            [self.takeOutOrderTableView.footer endRefreshing];
//            NSLog(@"%@", [data objectForKey:@"ErrorMsg"]);
            NSArray * array = [data objectForKey:@"WakeOutOrderList"];
            self.takeoutAllCount = [data objectForKey:@"AllCount"];
            [self.mSegmentControl changetakeoutorderCount:[data objectForKey:@"AllCount"]];
            if(_takeoutPage == 1)
            {
                _takeOutdataArray = nil;
            }
            for (NSDictionary * dic in array) {
                TakeOutOrderMD * takeOutOrderMD = [[TakeOutOrderMD alloc] initWithDictionary:dic];
                [self.takeOutdataArray addObject:takeOutOrderMD];
            }
            [self.takeOutOrderTableView reloadData];
            if (self.takeOutdataArray.count < [_takeoutAllCount integerValue])
            {
                [self.takeOutOrderTableView.footer resetNoMoreData];
            }else
            {
                [self.takeOutOrderTableView.footer noticeNoMoreData];
            }
        }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10025])
        {
            [self.gsOrderTableView.header endRefreshing];
            [self.gsOrderTableView.footer endRefreshing];
//                NSLog(@"%@", [data objectForKey:@"ErrorMsg"]);
                self.gsAllCount = [data objectForKey:@"AllCount"];
            [self.mSegmentControl changeorderCount:[data objectForKey:@"AllCount"]];
                NSArray * array = [data objectForKey:@"HotelOrderList"];
                if(_gsPage == 1)
                {
                    self.gsdataArray = nil;
                }
            
            if (self.gsdataArray.count / COUNT >= _gsSlectPage && _gsSlectPage != 0) {
                for (int i = (_gsSlectPage - 1) * COUNT; i < _gsSlectPage * COUNT; i++) {
                    GrogshopOrderMD * grogshopMD = [[GrogshopOrderMD alloc] initWithDictionary:array[i - (_gsSlectPage - 1) * COUNT]];
                    [self.gsdataArray replaceObjectAtIndex:i withObject:grogshopMD];
                }
                _gsSlectPage = 0;
            }else
            {
                
                for (NSDictionary * dic in array) {
                    GrogshopOrderMD * grogshopMD = [[GrogshopOrderMD alloc] initWithDictionary:dic];
                    
                    [self.gsdataArray addObject:grogshopMD];
                }
            }
            
                [self.gsOrderTableView reloadData];
                if (self.gsdataArray.count < [_gsAllCount integerValue])
                {
                    [self.gsOrderTableView.footer resetNoMoreData];
                }else
                {
                    [self.gsOrderTableView.footer noticeNoMoreData];
                }

        }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10001])
        {
            [self.colloctTableView.header endRefreshing];
            [self.colloctTableView.footer endRefreshing];
            NSArray * array = [data objectForKey:@"BusinessList"];
//            [self.mSegmentControl changecollectCount:[NSNumber numberWithInteger:array.count]];
            if(_colloctPage == 1)
            {
                _colloctdataArray = nil;
            }
            for (NSDictionary * dic in array) {
                CollectModel * collectMD = [[CollectModel alloc] initWithDictionary:dic];
                [self.colloctdataArray addObject:collectMD];
            }
            [self.colloctTableView reloadData];
        }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10029])
        {
            [UserInfo shareUserInfo].collectCount = [NSNumber numberWithInt:([UserInfo shareUserInfo].collectCount.intValue - 1)];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"删除成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
            [self downloadDataWithCommand:@1 page:_colloctPage count:COUNT];
        }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10024])
        {
            OrderDetailsMD * orderDetailsMD = [[OrderDetailsMD alloc] initWithDictionary:data];
            DetailTakeOutViewController * detailTakeOutVC = [[DetailTakeOutViewController alloc] init];
            detailTakeOutVC.takeOutID = orderDetailsMD.storeId;
            detailTakeOutVC.sendPrice = orderDetailsMD.sendPrice;
            detailTakeOutVC.storeState = orderDetailsMD.storeState;
            detailTakeOutVC.storeName = orderDetailsMD.storeName;
            detailTakeOutVC.navigationItem.title = orderDetailsMD.storeName;
            self.navigationController.navigationBar.alpha = 1;
            detailTakeOutVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailTakeOutVC animated:YES];
            
        }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10046])
        {
            [self downloadDataWithCommand:@25 page:_gsSlectPage count:COUNT];
            
        }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10048])
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:[data objectForKey:@"删除成功"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
            _takeoutPage = 1;
            [self downloadDataWithCommand:@23 page:_takeoutPage count:COUNT];
        }
        
    }else
    {
        
        if ([self.takeOutOrderTableView.header isRefreshing]) {
            [self.takeOutOrderTableView.header endRefreshing];
        }else if ([self.takeOutOrderTableView.footer isRefreshing])
        {
            [self.takeOutOrderTableView.footer endRefreshing];
        }
        
        if ([self.gsOrderTableView.header isRefreshing]) {
            [self.gsOrderTableView.header endRefreshing];
        }else if ([self.gsOrderTableView.footer isRefreshing])
        {
            [self.gsOrderTableView.footer endRefreshing];
        }
        
        if ([self.colloctTableView.header isRefreshing]) {
            [self.colloctTableView.header endRefreshing];
        }else if ([self.colloctTableView.footer isRefreshing])
        {
            [self.colloctTableView.footer endRefreshing];
        }
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }
//    [SVProgressHUD dismiss];
}
- (void)failWithError:(NSError *)error
{
    [self.hud dismiss];
    
    if ([self.takeOutOrderTableView.header isRefreshing]) {
        [self.takeOutOrderTableView.header endRefreshing];
    }else if ([self.takeOutOrderTableView.footer isRefreshing])
    {
        [self.takeOutOrderTableView.footer endRefreshing];
    }
    
    if ([self.gsOrderTableView.header isRefreshing]) {
        [self.gsOrderTableView.header endRefreshing];
    }else if ([self.gsOrderTableView.footer isRefreshing])
    {
        [self.gsOrderTableView.footer endRefreshing];
    }
    
    if ([self.colloctTableView.header isRefreshing]) {
        [self.colloctTableView.header endRefreshing];
    }else if ([self.colloctTableView.footer isRefreshing])
    {
        [self.colloctTableView.footer endRefreshing];
    }
    
    
    NSLog(@"%@", error);
}


#pragma mark - tabelView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_takeOutOrderTableView]) {
        return self.takeOutdataArray.count;
    }else if ([tableView isEqual:_gsOrderTableView])
    {
        return self.gsdataArray.count;
    }else
    {
        return self.colloctdataArray.count;
    }
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UserModel * userModel = [self.dataArray objectAtIndex:indexPath.row];
//    UserViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_INDENTIFIER];
//    [cell createSubviewWithFrame:tableView.bounds];
//    cell.modifyBT.tag = MODIFY_BUTTON_TAG + indexPath.row;
//    [cell.modifyBT addTarget:self action:@selector(modifyAction:) forControlEvents:UIControlEventTouchUpInside];
//    cell.userModel = userModel;
//    return cell;
    
    if ([tableView isEqual:_takeOutOrderTableView]) {
        TakeOutOrderMD * takeOutMD = [self.takeOutdataArray objectAtIndex:indexPath.row];
        TOOrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TAKEOUT_CELL_INDENTIFIER forIndexPath:indexPath];
        cell.separatorInset = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
        cell.layoutMargins = UIEdgeInsetsZero;
        [cell crateSubview:tableView.bounds];
        cell.takeOutOrderMD = takeOutMD;
        
        [cell deleteOrderAction:^{
            NSLog(@"删除 * %@ - %@", takeOutMD.storeName, takeOutMD.time);
            if (takeOutMD.orderState.intValue == 4 || takeOutMD.orderState.intValue == 6 || takeOutMD.orderState.intValue == 7) {
                NSDictionary * dic = @{
                                       @"Command":@48,
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"OrderId":takeOutMD.orderID
                                       };
                [self requestDataWithDictionary:dic];
            }else
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"该订单暂不可删除" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            }
        }];
        
        [cell againOrderAction:^{
//            DetailTakeOutViewController * detailTakeOutVC = [[DetailTakeOutViewController alloc] init];
//            detailTakeOutVC.takeOutID = takeOutMD.storeId;
//            detailTakeOutVC.sendPrice = takeOutMD.sendPrice;
//            detailTakeOutVC.storeState = takeOutMD.storeState;
//            detailTakeOutVC.storeName = takeOutMD.storeName;
//            detailTakeOutVC.navigationItem.title = self.orderDetailsMD.storeName;
//            //    detailTakeOutVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:detailTakeOutVC animated:YES];
            NSDictionary * jsonDic = @{
                                       @"Command":@24,
                                       @"Id":takeOutMD.orderID,
                                       };
            [self requestDataWithDictionary:jsonDic];
        }];
        
        [cell.iconButton addTarget:self action:@selector(lookBigImage:) forControlEvents:UIControlEventTouchUpInside];
        cell.iconButton.tag = 10000 + indexPath.row;
        // Configure the cell...
        return cell;
    }else if ([tableView isEqual:_gsOrderTableView])
    {
        GrogshopOrderMD * grogshopMD = [self.gsdataArray objectAtIndex:indexPath.row];
        GSOrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HOTEL_CELL_INDENTIFIER forIndexPath:indexPath];
        [cell createSubview:tableView.bounds];
#warning cell_block_test
//        [cell.payButton addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell setBlock:^{
            GSPayViewController * gsPayVC = [[GSPayViewController alloc] init];
            gsPayVC.orderID = grogshopMD.orderSn;
            self.navigationController.navigationBar.alpha = 1;
            gsPayVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:gsPayVC animated:YES];
        }];
        
        [cell cancleOrderAction:^{
            NSLog(@"取消订单");
            self.gsSlectPage = indexPath.row / COUNT + 1;
            NSDictionary * dic = @{
                                   @"Command":@46,
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"OrderId":grogshopMD.orderSn
                                   };
            [self requestDataWithDictionary:dic];
        }];
        
        cell.payButton.tag = indexPath.row + 4000;
        cell.grogshopOrderMD = grogshopMD;
        //    cell.textLabel.text = @"244";
        // Configure the cell...
        return cell;
    }else
    {
        CollectModel * collectMD = [self.colloctdataArray objectAtIndex:indexPath.row];
        HomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:COLLECT_CELL_INDENTIFIER forIndexPath:indexPath];
        [cell createSubview:tableView.bounds];
        cell.separatorInset = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.collectModel = collectMD;
        [cell.IconButton addTarget:self action:@selector(lookBigImage:) forControlEvents:UIControlEventTouchUpInside];
        cell.IconButton.tag = 5000 + indexPath.row;
        __weak UserViewController * homeVC = self;
        cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"取消收藏" backgroundColor:[UIColor redColor] callback:^BOOL(MGSwipeTableCell *sender) {
            if ([UserInfo shareUserInfo].userId) {
                self.collectModel = collectMD;
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@29,
                                           @"Flag":collectMD.businessType,
                                           @"Id":collectMD.businessId
                                           };
                [homeVC requestDataWithDictionary:jsonDic];
            }
            return YES;
        }]];
        //    cell.textLabel.text = @"23";
        // Configure the cell...
        
        return cell;
    }
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_takeOutOrderTableView]) {
        return [TOOrderViewCell cellHeight];
    }else if ([tableView isEqual:_gsOrderTableView])
    {
        GrogshopOrderMD * grogshopMD = [self.gsdataArray objectAtIndex:indexPath.row];
        if ([grogshopMD.orderState isEqualToNumber:@6]) {
            return 110;
        }else if ([grogshopMD.orderState isEqualToNumber:@4])
        {
            return 110;
        }else
        {
            if ([grogshopMD.payState isEqualToNumber:@1]) {
               return 110;
            }else
            {
               return 155;
            }
            
        }
//        return 90;
    }else if ([tableView isEqual:_colloctTableView])
    {
        return [HomeViewCell cellHeigth];
    }
    return [UserViewCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_takeOutOrderTableView]) {
        TakeOutOrderMD * takeOutOrderMD = [self.takeOutdataArray objectAtIndex:indexPath.row];
        DetailsTOOrderViewController * detailsVC = [[DetailsTOOrderViewController alloc] init];
        detailsVC.takeOutOrderMD = takeOutOrderMD;
        self.navigationController.navigationBar.alpha = 1;
        detailsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailsVC animated:YES];
    }else if ([tableView isEqual:_gsOrderTableView])
    {
        self.pushTocommentVc = 1;
        GrogshopOrderMD * grogshopMD = [self.gsdataArray objectAtIndex:indexPath.row];
        DetailsGSOrderViewController * detailsGSODVC = [[DetailsGSOrderViewController alloc] init];
        detailsGSODVC.orderID = grogshopMD.orderSn;
        self.navigationController.navigationBar.alpha = 1;
        detailsGSODVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailsGSODVC animated:YES];
    }else if ([tableView isEqual:_colloctTableView])
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        CollectModel * collectMD = [self.colloctdataArray objectAtIndex:indexPath.row];
        if ([collectMD.businessType isEqualToNumber:@2]) {
            DetailTakeOutViewController * detaiTOVC = [[DetailTakeOutViewController alloc] init];
            detaiTOVC.takeOutID = collectMD.businessId;
            detaiTOVC.sendPrice = collectMD.sendPrice;
            detaiTOVC.storeState = collectMD.storeState;
            detaiTOVC.iConimageURL = collectMD.icon;
            self.navigationController.navigationBar.alpha = 1;
            detaiTOVC.hidesBottomBarWhenPushed = YES;
            detaiTOVC.navigationItem.title = collectMD.businessName;
            [self.navigationController pushViewController:detaiTOVC animated:YES];
        }else
        {
            DetailsGrogshopViewController * detailsGSVC = [[DetailsGrogshopViewController alloc] init];
            detailsGSVC.hidesBottomBarWhenPushed = YES;
            self.navigationController.navigationBar.alpha = 1;
            detailsGSVC.hotelID = collectMD.businessId;
            detailsGSVC.lat = collectMD.businessLat;
            detailsGSVC.lon = collectMD.businessLon;
            detailsGSVC.icon = collectMD.icon;
            detailsGSVC.navigationItem.title = collectMD.businessName;
            [self.navigationController pushViewController:detailsGSVC animated:YES];
        }

    }
    
//    if (indexPath.row == 3) {
//        NSLog(@"外卖订单");
//        UserTOOrderViewController * TOOrderVC = [[UserTOOrderViewController alloc] init];
//        TOOrderVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:TOOrderVC animated:YES];
//    }else if (indexPath.row == 4)
//    {
//        NSLog(@"酒店订单");
//        GSOrderViewController * gsOrderVC = [[GSOrderViewController alloc] init];
//        gsOrderVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:gsOrderVC animated:YES];
//    }
}

//- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row == 3 | indexPath.row == 4) {
//        return YES;
//    }
//    return NO;
//}


- (void)modifyAction:(UIButton *)button
{
    __weak UserViewController * userVC = self;
    switch (button.tag) {
        case MODIFY_BUTTON_TAG:
        {
            NSLog(@"名称");
            ModifyNameViewController * nameVC = [[ModifyNameViewController alloc] init];
//            [nameVC refreshUserName:^{
//                [userVC fiexdData];
//            }];
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


#pragma marc - 微信登录

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
//                        NSLog(@"user info = %@", infoDic);
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


#pragma mark - 点击图片放大

- (void)lookBigImage:(UIButton *)button
{
//    NSLog(@"******class = %@", [button.superview.superview class]);
    if ([button.superview.superview isKindOfClass:[TOOrderViewCell class]]) {
        int section = 0;
        NSInteger row = button.tag - 10000;
        TakeOutOrderMD * takeOutOrderMd = [self.takeOutdataArray objectAtIndex:row];
        CGPoint point = self.takeOutOrderTableView.contentOffset;
        CGRect cellRect = [self.takeOutOrderTableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
        CGRect btFrame = button.frame;
        btFrame.origin.y = cellRect.origin.y - point.y + button.frame.origin.y + self.mSegmentControl.top + self.mSegmentControl.height;
        btFrame.origin.x = self.takeOutOrderTableView.left + button.left;
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
        [imageView setImageWithURL:[NSURL URLWithString:takeOutOrderMd.storeIcon] placeholderImage:[UIImage imageNamed:@"placeholderIM.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (error) {
                imageV.image = [UIImage imageNamed:@"load_fail.png"];
            }
        }];
        [UIView animateWithDuration:1 animations:^{
            imageView.frame = imageFrame;
        }];
        
//        NSLog(@",  %g, %g", cellRect.origin.x, cellRect.origin.y);
    }else if ([button.superview.superview isKindOfClass:[HomeViewCell class]])
    {
        CollectModel * collectMD = [self.colloctdataArray objectAtIndex:button.tag - 5000];
        CGPoint point = self.colloctTableView.contentOffset;
        CGRect cellRect = [self.colloctTableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag - 5000 inSection:0]];
        CGRect btFrame = button.frame;
        btFrame.origin.y = cellRect.origin.y - point.y + button.frame.origin.y + self.mSegmentControl.top + self.mSegmentControl.height;
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBigImage)];
        
        UIView * view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        view.tag = 70000;
        [view addGestureRecognizer:tapGesture];
        view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.3];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width - 100, self.view.width - 100)];
        imageView.center = view.center;
        imageView.layer.cornerRadius = 30;
        imageView.layer.masksToBounds = YES;
        __weak UIImageView * imageV = imageView;
        [imageView setImageWithURL:[NSURL URLWithString:collectMD.icon] placeholderImage:[UIImage imageNamed:@"placeholderIM.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (error) {
                imageV.image = [UIImage imageNamed:@"load_fail.png"];
            }
        }];
        CGRect imageFrame = imageView.frame;
        imageView.frame = btFrame;
        //    imageView.image = [UIImage imageNamed:@"superMarket.png"];
        [view addSubview:imageView];
        [self.view.window addSubview:view];
        
        [UIView animateWithDuration:1 animations:^{
            imageView.frame = imageFrame;
        }];
        
//        NSLog(@",  %g, %g", cellRect.origin.x, cellRect.origin.y);

    }
}

- (void)removeBigImage
{
    UIView * view = [self.view.window viewWithTag:70000];
    [view removeFromSuperview];
}

#pragma mark - 酒店订单支付
- (void)payAction:(UIButton *)button
{
//    NSLog(@"支付%d", button.tag - 4000);
    GrogshopOrderMD * grogshopMD = [self.gsdataArray objectAtIndex:button.tag - 4000];
    GSPayViewController * gsPayVC = [[GSPayViewController alloc] init];
    gsPayVC.orderID = grogshopMD.orderSn;
    self.navigationController.navigationBar.alpha = 1;
    gsPayVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:gsPayVC animated:YES];
    /*
     DetailsGSOrderViewController * detailsGSODVC = [[DetailsGSOrderViewController alloc] init];
     detailsGSODVC.orderID = grogshopMD.orderSn;
     detailsGSODVC.isPay = NO;
     [self.navigationController pushViewController:detailsGSODVC animated:YES];
     */
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_orderScrollview]) {
        [self.mSegmentControl changeSegmentedControlWithIndex:(scrollView.contentOffset.x / _orderScrollview.width)];
    }else if ([scrollView isEqual:_takeOutOrderTableView] || [scrollView isEqual:_gsOrderTableView] || [scrollView isEqual:_colloctTableView])
    {
//        NSLog(@"移动的列表");
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_takeOutOrderTableView] || [scrollView isEqual:_gsOrderTableView] || [scrollView isEqual:_colloctTableView])
    {
        if (scrollView.contentOffset.y>0) {
//            NSLog(@"****scrollViewDidScroll - scrollView.contentOffset.y > 0");
            if (self.myScrollView.top == 64) {
                self.mSegmentControl.top = self.addressView.bottom + 20;
                self.orderScrollview.top = self.mSegmentControl.bottom;
                self.orderScrollview.height = self.view.height - _mSegmentControl.height - 20;
                self.takeOutOrderTableView.height = self.view.height - _mSegmentControl.height - 20;
                self.gsOrderTableView.height = self.view.height - _mSegmentControl.height - 20;
                self.colloctTableView.height = self.view.height - _mSegmentControl.height - 20 ;
                [UIView animateWithDuration:.5 animations:^{
                    self.navigationController.navigationBar.alpha = 0;
                    self.myScrollView.frame = CGRectMake(0, -130, self.view.width, self.view.height - 64 - self.tabBarController.tabBar.height + 64 + 140);
                } completion:^(BOOL finished) {
                    ;
                }];
                
            }
            else
            {
//                NSLog(@"****scrollViewDidScroll - scrollView.contentOffset.y > 0 - self.myScrollView.top != 64");
            }
        }else
        {
//            if (self.myScrollView.top != 64) {
//                NSLog(@"****scrollViewDidScroll - scrollView.contentOffset.y < 0");
//                [UIView animateWithDuration:.5 animations:^{
//                    self.navigationController.navigationBar.alpha = 1;
//                    self.myScrollView.frame = CGRectMake(0, 64, self.view.width, self.view.height - 64 - self.tabBarController.tabBar.height );
//                } completion:^(BOOL finished) {
//                    ;
//                }];
//            }else
//            {
//                NSLog(@"****scrollViewDidScroll - scrollView.contentOffset.y < 0 - self.myScrollView.top == 64");
//            }
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <0)
    {
        if (self.myScrollView.top != 64) {
//            NSLog(@"****scrollViewWillBeginDragging - scrollView.contentOffset.y < 0");
            self.mSegmentControl.top = self.addressView.bottom + 10;
            self.orderScrollview.top = self.mSegmentControl.bottom;
            [UIView animateWithDuration:.5 animations:^{
                self.navigationController.navigationBar.alpha = 1;
                self.myScrollView.frame = CGRectMake(0, 64, self.view.width, self.view.height - 64 - self.tabBarController.tabBar.height );
            } completion:^(BOOL finished) {
                ;
            }];
        }else
        {
//            NSLog(@"****scrollViewWillBeginDragging - scrollView.contentOffset.y < 0 - self.myScrollView.top == 64");
        }
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <0)
    {
        if (self.myScrollView.top != 64) {
//            NSLog(@"****scrollViewWillBeginDragging - scrollView.contentOffset.y < 0");
            self.mSegmentControl.top = self.addressView.bottom + 10;
            self.orderScrollview.top = self.mSegmentControl.bottom;
            [UIView animateWithDuration:.5 animations:^{
                self.navigationController.navigationBar.alpha = 1;
                self.myScrollView.frame = CGRectMake(0, 64, self.view.width, self.view.height - 64 - self.tabBarController.tabBar.height );
            } completion:^(BOOL finished) {
                ;
            }];
        }else
        {
//            NSLog(@"****scrollViewWillBeginDragging - scrollView.contentOffset.y < 0 - self.myScrollView.top == 64");
        }
    }
}
#pragma mark - 收藏个数改变通知
- (void)collectCountChangeaction:(NSNotification *)notification
{
    [self.mSegmentControl changecollectCount:[notification.userInfo objectForKey:@"newCollectCount"]];
//    NSLog(@"^^^^^^^^^^%@^^^^^^^^", [notification.userInfo objectForKey:@"newCollectCount"]);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:CollectCountCHange object:nil];
    NSLog(@"移除通知");
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
