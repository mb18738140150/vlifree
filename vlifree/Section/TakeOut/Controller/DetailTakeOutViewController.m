
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
#import "CommentViewController.h"
#import "HYSegmentedControl.h"
#import "CommentViewCell.h"
#import "CommentModel.h"
#import "StoreIntroView.h"
#import "GSMapViewController.h"
#import "PropertyModel.h"
#import "PropertyView.h"

#define SECTION_TABLEVIEW_CELL @"SECTIONCELL"
#define MENUS_TABLEVIEW_CELL @"MENUSCELL"
#define COMMENT_TABLEVIEW_CELL @"COMMENTCELL"

#define SUBTRACT_BUTTON_TAG 1000
#define ADD_BUTTON_TAG 2000

#define PROPERTY_BUTTON_TAG 3000

#define SHOPPINGCARVIEW_HEIGHT 55


@interface DetailTakeOutViewController ()<UITableViewDataSource, UITableViewDelegate, HTTPPostDelegate, HYSegmentedControlDelegate, UIScrollViewDelegate>

{
    /**
     *  数据请求的页数
     */
    int _page;
}
/**
 *  菜品类型列表
 */
@property (nonatomic, strong)UITableView * sectionTableView;
/**
 *  菜品列表
 */
@property (nonatomic, strong)UITableView * menusTableView;
/**
 *  购物车
 */
@property (nonatomic, strong)ShoppingCartView * shoppingCarView;
/**
 *  购物车详情
 */
@property (nonatomic, strong)ShoppingDetailsCarView * shoppingCarDetailsView;

/**
 *  分类数据数组
 */
@property (nonatomic, strong)NSMutableArray * classArray;
/**
 *  菜品数据数组
 */
@property (nonatomic, strong)NSMutableArray * menusArray;
//@property (nonatomic, strong)NSNumber * mealBoxMoney;//餐盒费

/**
 *  购物车数组
 */
@property (nonatomic, strong)NSMutableArray * shopArray;
/**
 *  登陆提示页面
 */
@property (nonatomic, strong)AlertLoginView * alertLoginV;
/**
 *  商店公告滚动图
 */
@property (nonatomic, strong)UIScrollView * noticeScrollV;
/**
 *  商店公告文本框
 */
@property (nonatomic, strong)UILabel * noticeLB;
/**
 *  商店公告滚动timer
 */
@property (nonatomic, strong)NSTimer * noticeTimer;
/**
 *  点餐页面和评论页面切换的滚动试图
 */
@property (nonatomic, strong)UIScrollView * aScrollView;
/**
 *  点餐和评论页面切换segment
 */
@property (nonatomic, strong)HYSegmentedControl * segmentC;
/**
 *  评论列表
 */
@property (nonatomic, strong)UITableView * commentTableView;
/**
 *  评论数据数组
 */
@property (nonatomic, strong)NSMutableArray * commentArray;


/**
 *  简介界面
 */
@property (nonatomic, strong)StoreIntroView * introView;

/**
 *  酒店维度
 */
@property (nonatomic, copy)NSString * lat;
/**
 *  酒店经度
 */
@property (nonatomic, copy)NSString * lon;
// 菜品属性弹出框
// 弹出框
@property (nonatomic, strong)UIView * tanchuView;
@property (nonatomic, strong)MenuModel * menuModel;
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

- (NSMutableArray *)commentArray
{
    if (!_commentArray) {
        self.commentArray = [NSMutableArray array];
    }
    return _commentArray;
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
    NSLog(@"销毁店面页面");
//    [self removeObserver:self forKeyPath:@"shopArray"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];


    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSForegroundColorAttributeName: TEXT_COLOR
                                                                    };
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"评论" style:UIBarButtonItemStylePlain target:self action:@selector(lookComment:)];
//    [self addObserver:self forKeyPath:@"shopArray" options:NSKeyValueObservingOptionNew context:nil];
    
    self.segmentC = [[HYSegmentedControl alloc] initWithOriginY:0 Titles:@[@"点菜", @"评论",@"简介"] delegate:self];
//    self.segmentC = [[HYSegmentedControl alloc] initWithOriginY:0 Titles:@[@"点菜", @"评论", @"简介"] delegate:self];
    [self.view addSubview:_segmentC];
    
    self.aScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _segmentC.bottom, self.view.width, self.view.height - self.navigationController.navigationBar.bottom - _segmentC.height)];
//    _aScrollView.backgroundColor = [UIColor redColor];
    _aScrollView.delegate = self;
    _aScrollView.pagingEnabled = YES;
    _aScrollView.showsHorizontalScrollIndicator = NO;
    _aScrollView.contentSize = CGSizeMake(_aScrollView.width * 3, _aScrollView.height);
//    _aScrollView.contentSize = CGSizeMake(_aScrollView.width * 2, _aScrollView.height);
    [self.view addSubview:_aScrollView];
    
    
    
    UIView * noticeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.aScrollView.width, 30)];
//    UIView * noticeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, self.aScrollView.width, 30)];
    noticeView.tag = 80000;
    noticeView.backgroundColor = [UIColor colorWithRed:254 / 255.0 green:231 / 255.0 blue:232 / 255.0 alpha:1];
    [self.aScrollView addSubview:noticeView];
    
    UIImageView * aImageV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    aImageV.image = [UIImage imageNamed:@"laba.png"];
    [noticeView addSubview:aImageV];
    
    self.noticeScrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(aImageV.right + 5, 0, noticeView.width - aImageV.right - 40, noticeView.height)];
    _noticeScrollV.showsVerticalScrollIndicator   = NO;
    _noticeScrollV.showsHorizontalScrollIndicator = NO;
    _noticeScrollV.tag = 9001;
    [noticeView addSubview:_noticeScrollV];
    
    self.noticeLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, _noticeScrollV.width, _noticeScrollV.height - 10)];
//    _noticeLB.text = @"欢迎商家测试使用就饿哦JoeNGO弄欧冠哦哦哦个菲菲";
    _noticeLB.textColor = TEXT_COLOR;
//    [_noticeLB sizeToFit];
    [_noticeScrollV addSubview:_noticeLB];
//    _noticeScrollV.contentSize = CGSizeMake(_noticeLB.width + 3, _noticeScrollV.height);
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(_noticeScrollV.right + 10, 5, 20, 20);
    [button setBackgroundImage:[UIImage imageNamed:@"xx.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(removeNoticeView:) forControlEvents:UIControlEventTouchUpInside];
    [noticeView addSubview:button];
//    NSLog(@"point =  %g, %g", noticeScrollV.contentOffset.x, _noticeScrollV.contentOffset.y);
    
    self.sectionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, noticeView.bottom, 80, self.aScrollView.height - SHOPPINGCARVIEW_HEIGHT - noticeView.height) style:UITableViewStylePlain];
//    self.sectionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 80, self.aScrollView.height - SHOPPINGCARVIEW_HEIGHT) style:UITableViewStylePlain];
    self.sectionTableView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.7];
    _sectionTableView.dataSource = self;
    _sectionTableView.delegate = self;
    _sectionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _sectionTableView.tableFooterView = [[UIView alloc] init];
//    [_sectionTableView set]
    [_sectionTableView registerClass:[ClassesViewCell class] forCellReuseIdentifier:SECTION_TABLEVIEW_CELL];
    [_sectionTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
//    _sectionTableView.backgroundColor = [UIColor redColor];
    [self.aScrollView addSubview:_sectionTableView];
    
    self.menusTableView = [[UITableView alloc] initWithFrame:CGRectMake(_sectionTableView.right, noticeView.bottom, self.aScrollView.width - 80, self.aScrollView.height - SHOPPINGCARVIEW_HEIGHT - noticeView.height) style:UITableViewStylePlain];
//    self.menusTableView = [[UITableView alloc] initWithFrame:CGRectMake(_sectionTableView.right, self.navigationController.navigationBar.bottom, self.aScrollView.width - 80, self.aScrollView.height - self.navigationController.navigationBar.bottom - SHOPPINGCARVIEW_HEIGHT) style:UITableViewStylePlain];
    
    _menusTableView.delegate = self;
    _menusTableView.dataSource = self;
    _menusTableView.separatorColor = LINE_COLOR;
    _menusTableView.tableFooterView = [[UIView alloc] init];
    [_menusTableView registerClass:[MenusViewCell class] forCellReuseIdentifier:MENUS_TABLEVIEW_CELL];
//    _menusTableView.backgroundColor = [UIColor orangeColor];
    [self.aScrollView addSubview:_menusTableView];
    
    
    self.shoppingCarView = [[ShoppingCartView alloc] initWithFrame:CGRectMake(0, _menusTableView.bottom, self.aScrollView.width, SHOPPINGCARVIEW_HEIGHT)];
    _shoppingCarView.backgroundColor = [UIColor whiteColor];
    
    if (self.sendPrice != nil) {
        _shoppingCarView.priceLabel.text = [NSString stringWithFormat:@"¥0(%@起送)", self.sendPrice];
    }else
    {
        self.shoppingCarView.priceLabel.text = @"¥0";
    }
//    NSLog(@"=====%@", self.sendPrice);
    [_shoppingCarView.shoppingCarBT addTarget:self action:@selector(addShoppingCarDetailsViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [_shoppingCarView.changeButton addTarget:self action:@selector(confirmMenusAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.aScrollView addSubview:_shoppingCarView];
//    _shoppingCarView.backgroundColor = [UIColor greenColor];
    
    
    
    
    
    
    
    if ([self.storeState isEqualToNumber:@0]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"商家休息中, 暂时不接受新订单." delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        self.shoppingCarView.changeButton.enabled = NO;
        self.shoppingCarDetailsView.changeBT.enabled = NO;
        [self.shoppingCarDetailsView.changeBT setBackgroundImage:[UIImage imageNamed:@"storeState_g.png"] forState:UIControlStateDisabled];
        [self.shoppingCarView.changeButton setBackgroundImage:[UIImage imageNamed:@"storeState_g.png"] forState:UIControlStateDisabled];
    }
    
//    CommentViewController * commentVC = [[CommentViewController alloc] init];
//    commentVC.storeId = self.takeOutID;
//    commentVC.view.frame = CGRectMake(_aScrollView.width, 0, _aScrollView.width, _aScrollView.height);
//    [_aScrollView addSubview:commentVC.view];
    
    self.commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(_aScrollView.width, 0, _aScrollView.width, _aScrollView.height)];
    _commentTableView.delegate = self;
    _commentTableView.dataSource = self;
    [_aScrollView addSubview:_commentTableView];
    _page = 1;
    self.commentTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    [_commentTableView registerClass:[CommentViewCell class] forCellReuseIdentifier:COMMENT_TABLEVIEW_CELL];
    self.commentTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [self downloadDataWithCommand:@39 page:_page count:COUNT];
    self.commentTableView.tableFooterView = [[UIView alloc] init];
    
    
    self.introView = [[StoreIntroView alloc]initWithFrame:CGRectMake(2 * _aScrollView.width, 0, _aScrollView.width, _aScrollView.height)];
    [_aScrollView addSubview:_introView];
    [self.introView.addressBT addTarget:self action:@selector(addressAction:) forControlEvents:UIControlEventTouchUpInside];
    NSDictionary *jsondic = @{
                              @"Command":@43,
                              @"StoreId":self.takeOutID,
                              };
    [self playPostWithDictionary:jsondic];
//    self.introView = [[StoreIntroView alloc] initWithFrame:CGRectMake(_commentTableView.right, 0, _aScrollView.width, _aScrollView.height)];
//    [_aScrollView addSubview:_introView];
    
    
    UIButton * backBT = [UIButton buttonWithType:UIButtonTypeCustom];
    backBT.frame = CGRectMake(0, 0, 15, 20);
    [backBT setBackgroundImage:[UIImage imageNamed:@"back_r.png"] forState:UIControlStateNormal];
    [backBT addTarget:self action:@selector(backLastVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBT];
    
    
    [self downloadData];
    
    self.tanchuView = [[UIView alloc]initWithFrame:self.view.bounds];
    _tanchuView.backgroundColor = [UIColor clearColor];

    
//    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(scrollNotice) userInfo:nil repeats:YES];
//    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    // Do any additional setup after loading the view.
}

#pragma mark - HYSegmentedControl 代理方法
- (void)hySegmentedControlSelectAtIndex:(NSInteger)index
{
//    self.aScrollView.contentOffset = CGPointMake(index * _aScrollView.width, 0);
    [self.aScrollView setContentOffset:CGPointMake(index * _aScrollView.width, 0) animated:YES];
}


- (void)scrollNotice
{
    if (self.noticeScrollV.contentSize.width - self.noticeScrollV.contentOffset.x > self.noticeScrollV.width) {
        self.noticeScrollV.contentOffset = CGPointMake(self.noticeScrollV.contentOffset.x + 1, 0);
    }else
    {
        self.noticeScrollV.contentOffset = CGPointMake(0, 0);
    }
}

- (void)noticeLBText:(NSString *)notice
{
    if (notice.length > 0) {
        self.noticeLB.text = notice;
        CGSize size = [self.noticeLB sizeThatFits:CGSizeMake(CGFLOAT_MAX, self.noticeLB.height)];
        self.noticeLB.width = size.width;
        self.noticeScrollV.contentSize = CGSizeMake(size.width + 5, _noticeScrollV.height);
        if (self.noticeTimer != nil) {
            [self.noticeTimer invalidate];
        }
        self.noticeTimer = nil;
        if (size.width > _noticeScrollV.width) {
            self.noticeTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(scrollNotice) userInfo:nil repeats:YES];
        }
    }else
    {
        [self deleteNOticeView];
    }
    
}


- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = MAIN_COLOR;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}
/**
 *  跳转到评论查看页面
 *
 *  @param sender 评论barButton
 */
- (void)lookComment:(id)sender
{
    CommentViewController * commentVC = [[CommentViewController alloc] init];
    commentVC.storeId = self.takeOutID;
    [self.navigationController pushViewController:commentVC animated:YES];
}

/**
 *  移除商家公告
 *
 *  @param button 商家公告上面的x button
 */
- (void)removeNoticeView:(UIButton *)button
{
    [self deleteNOticeView];
}

- (void)deleteNOticeView
{
    UIView * noticeView = [self.aScrollView viewWithTag:80000];
    self.sectionTableView.top = noticeView.top;
    self.menusTableView.top = noticeView.top;
//    self.menusTableView.top -= noticeView.height;
//    self.sectionTableView.top -= noticeView.height;
    self.sectionTableView.height += noticeView.height;
    self.menusTableView.height += noticeView.height;
    self.noticeLB = nil;
    self.noticeScrollV = nil;
//    self.sectionTableView.frame = CGRectMake(0, 0, 80, self.aScrollView.height - SHOPPINGCARVIEW_HEIGHT);
    [noticeView removeFromSuperview];
    if (self.noticeTimer != nil) {
        [self.noticeTimer invalidate];
        self.noticeTimer = nil;
    }
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
        for (MenuModel * menuMD in self.shopArray) {
            if (menuMD.PropertyList.count != 0) {
                for (PropertyModel * proModel in menuMD.PropertyList) {
                    if (proModel.count != 0) {
                        NSDictionary * dic = @{
                                               @"Id":menuMD.Id,
                                               @"Count":[NSNumber numberWithInteger:proModel.count],
                                               @"Name":menuMD.name,
                                               @"Price":@(proModel.stylePrice),
                                               @"Money":[NSNumber numberWithDouble:proModel.stylePrice * proModel.count],
                                               @"StyleId":@(proModel.styleId),
                                               @"StyleName":proModel.styleName
                                               };
                        [array addObject:dic];
                    }
                }
            }else
            {
                NSDictionary * dic = @{
                                       @"Id":menuMD.Id,
                                       @"Count":[NSNumber numberWithInteger:menuMD.count],
                                       @"Name":menuMD.name,
                                       @"Price":menuMD.price,
                                       @"Money":[NSNumber numberWithDouble:menuMD.price.doubleValue * menuMD.count],
                                       @"StyleId":@(0),
                                       @"StyleName":@""
                                       };
                [array addObject:dic];

            }
        }
        NSDictionary * jsonDic = @{
                                   @"Command":@31,
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"StoreId":self.takeOutID,
                                   @"ShoppingList":array
                                   };
        [self playPostWithDictionary:jsonDic];
//        [SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeClear];
    }else
    {
        self.alertLoginV = [[AlertLoginView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_alertLoginV.logInButton addTarget:self action:@selector(userLogInAction:) forControlEvents:UIControlEventTouchUpInside];
        [_alertLoginV.weixinButton addTarget:self action:@selector(weixinLogIn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view.window addSubview:_alertLoginV];
        if (![WXApi isWXAppInstalled]) {
            _alertLoginV.weixinButton.hidden = YES;
        }
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
//        [alert show];
    }
    
}


- (void)addShoppingCarDetailsViewAction:(UIButton *)button
{
    if (self.shopArray.count > 0 && [self.storeState isEqualToNumber:@1]) {
        self.shoppingCarDetailsView = [[ShoppingDetailsCarView alloc] initWithFrame:[[UIScreen mainScreen] bounds] withMneusArray:self.shopArray];
//        self.shoppingCarDetailsView.mealBoxMoney = self.mealBoxMoney;//这个赋值许在sendPrice前面
        self.shoppingCarDetailsView.sendPrice = self.sendPrice;
        [self.shoppingCarDetailsView.shoppingCarBT addTarget:self action:@selector(removeShoppingCarDetailsViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [_shoppingCarDetailsView.changeBT addTarget:self action:@selector(confirmMenusAction:) forControlEvents:UIControlEventTouchUpInside];
        [_shoppingCarDetailsView.clearCarBT addTarget:self action:@selector(clearShoppingCar:) forControlEvents:UIControlEventTouchUpInside];
        [self.view.window addSubview:_shoppingCarDetailsView];
    }
}


- (void)removeShoppingCarDetailsViewAction:(UIButton *)button
{
    [self.shoppingCarDetailsView removeFromSuperview];
    [self getAllPrice];
    [self getAllCount];
}

#pragma mark - 评论数据刷新

- (void)headerRereshing
{
    _page = 1;
    [self.commentTableView.footer resetNoMoreData];
    [self downloadDataWithCommand:@39 page:_page count:COUNT];
}

- (void)footerRereshing
{
    [self downloadDataWithCommand:@39 page:++_page count:COUNT];
}


#pragma mark - 数据请求

- (void)downloadDataWithCommand:(NSNumber *)command page:(int)page count:(int)count
{
    NSDictionary * jsonDic = @{
                               @"Command":command,
                               @"CurPage":[NSNumber numberWithInt:page],
                               @"CurCount":[NSNumber numberWithInt:count],
                               @"StoreId":self.takeOutID,
                               @"BusType":@2
                               };
    [self playPostWithDictionary:jsonDic];
}


- (void)downloadData
{
//    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    NSDictionary * jsonDic = @{
                               @"Command":@12,
                               @"StoreId":self.takeOutID
                               };
    [self playPostWithDictionary:jsonDic];
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
    [self.commentTableView.header endRefreshing];
    [self.commentTableView.footer endRefreshing];
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        if ([[data objectForKey:@"Command"] intValue] == 10012) {
//            self.mealBoxMoney = [data objectForKey:@"MealBoxMoney"];
//            NSLog(@"餐具费  %@", self.mealBoxMoney);
            [self noticeLBText:[data objectForKey:@"BusinessNotice"]];
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
                    for (MenuModel * shopMenuMD in self.shopArray) {
//                        MenuModel * shopMenuMD = [smallAry firstObject];
                        if ([shopMenuMD.Id isEqualToNumber:menuMD.Id]) {
                            menuMD = shopMenuMD;
                        }
                    }
                }
                [self.menusArray addObject:menuMD];
            }
            [self.menusTableView reloadData];
//            [SVProgressHUD dismiss];
        }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10009] || [[data objectForKey:@"Command"] isEqualToNumber:@10007]) {
            [[UserInfo shareUserInfo] setValuesForKeysWithDictionary:[data objectForKey:@"UserInfo"]];
            UITabBarItem * item = [self.navigationController.tabBarController.tabBar.items lastObject];
            item.title = @"我的";
            [self.alertLoginV removeFromSuperview];
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
                [[NSUserDefaults standardUserDefaults] setValue:[UserInfo shareUserInfo].phoneNumber forKey:@"account"];
                [[NSUserDefaults standardUserDefaults] setValue:[UserInfo shareUserInfo].password forKey:@"password"];
                [[NSUserDefaults standardUserDefaults] setValue:@YES forKey:@"haveLogIn"];
            }
            
        }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10031])
        {
            TakeOutOrderViewController * orderVC = [[TakeOutOrderViewController alloc] init];
            orderVC.orderDic = data;
            orderVC.shopArray = self.shopArray;
            orderVC.takeOutId = self.takeOutID;
            orderVC.storeName = self.storeName;
//            orderVC.mealBoxMoney = [data objectForKey:@"MealBoxMoney"];
            [self.navigationController pushViewController:orderVC animated:YES];
        }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10039])
        {
            NSArray * array = [data objectForKey:@"CommentList"];
            if (_page == 1) {
                self.commentArray = nil;
            }
            for (NSDictionary * dic in array) {
                CommentModel * commentMD  = [[CommentModel alloc] initWithDictionary:dic];
                [self.commentArray addObject:commentMD];
            }
            if ([[data objectForKey:@"AllCur"] intValue] == _page || self.commentArray.count == 0 || self.commentArray.count == [[data objectForKey:@"AllCount"] integerValue]) {
                [self.commentTableView.footer noticeNoMoreData];
            }
            [self.commentTableView reloadData];
        }else if ([[data objectForKey:@"Command"]isEqualToNumber:@10043])
        {
            NSLog(@"***********data = %@", data);
            self.introView.Describe.text = [data objectForKey:@"Describe"];
            self.introView.StoreType.text = [data objectForKey:@"StoreType"];
            self.introView.BusTime.text = [data objectForKey:@"BusTime"];
            self.introView.StoreAdress.text = [data objectForKey:@"StoreAdress"];
            self.introView.StoreTel.text = [data objectForKey:@"StoreTel"];
            self.introView.StartSendMoney.text = [NSString stringWithFormat:@"%@", [data objectForKey:@"StartSendMoney"]];
            self.introView.Delivery.text = [NSString stringWithFormat:@"%@", [data objectForKey:@"Delivery"]];
            self.introView.ServiceDis.text = [NSString stringWithFormat:@"%@", [data objectForKey:@"ServiceDis"]];
            self.introView.DeliveryDis.text = [data objectForKey:@"DeliveryDis"];
            self.lat = [data objectForKey:@"StoreLat"];
            self.lon = [data objectForKey:@"StoreLon"];
        }
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
        if ([[data objectForKey:@"Command"] isEqualToNumber:@10013])
        {
            [self.menusTableView reloadData];
        }
//        if ([[data objectForKey:@"Command"] isEqualToNumber:@10039])
//        {
//            [self.commentTableView.header endRefreshing];
//            [self.commentTableView.footer endRefreshing];
//        }
    }
    
//    [SVProgressHUD dismiss];
}

- (void)failWithError:(NSError *)error
{
    [self.commentTableView.header endRefreshing];
    [self.commentTableView.footer endRefreshing];
//    [SVProgressHUD dismiss];
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
//        return 15;
    }else if ([tableView isEqual:_commentTableView])
    {
        return self.commentArray.count;
    }
    return self.menusArray.count;
//    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_sectionTableView]) {
        
        ClassesViewCell * sectionCell = [tableView dequeueReusableCellWithIdentifier:SECTION_TABLEVIEW_CELL];
        [sectionCell createSubviewWithFrame:tableView.bounds];
        if (self.classArray.count) {
            ClassModel * classMD = [self.classArray objectAtIndex:indexPath.row];
            sectionCell.classModel = classMD;
        }
        return sectionCell;
    }else if ([tableView isEqual:_commentTableView])
    {
        CommentViewCell * commentCell = [tableView dequeueReusableCellWithIdentifier:COMMENT_TABLEVIEW_CELL forIndexPath:indexPath];
        CommentModel * commentMD = [self.commentArray objectAtIndex:indexPath.row];
        commentCell.commentMD = commentMD;
        return commentCell;
    }
    MenuModel * menuMD = [self.menusArray objectAtIndex:indexPath.row];
    MenusViewCell * cell = [tableView dequeueReusableCellWithIdentifier:MENUS_TABLEVIEW_CELL];
    [cell createSubview:tableView.bounds];
    [cell.subtractBT addTarget:self action:@selector(subtractMenuCount:) forControlEvents:UIControlEventTouchUpInside];
    cell.subtractBT.tag = indexPath.row + SUBTRACT_BUTTON_TAG;
    [cell.addButton addTarget:self action:@selector(addMenuCount:) forControlEvents:UIControlEventTouchUpInside];
    [cell.iconButton addTarget:self action:@selector(lookBigImage:) forControlEvents:UIControlEventTouchUpInside];
    cell.iconButton.tag = indexPath.row + 10000;
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
//        return [ClassesViewCell cellHeightWithString:@"和覅和合格后二极管" frame:tableView.bounds];
    }else if ([tableView isEqual:_commentTableView])
    {
        CommentModel * commentMD = [self.commentArray objectAtIndex:indexPath.row];
        return [CommentViewCell cellHeightWithCommentMD:commentMD];
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
    if ([tableView isEqual:_sectionTableView]) {
        return YES;
    }
    return NO;
}


#pragma mark - 无属性加减选菜个数

- (void)subtractMenuCount:(UIButton *)button
{

    MenuModel * menuMD = [self.menusArray objectAtIndex:button.tag - SUBTRACT_BUTTON_TAG];
//    menuMD.count -= 1;

    self.menuModel = menuMD;
    if (menuMD.PropertyList.count != 0) {
        [self tanchuPropertyWithModel:menuMD];
    }else
    {
        
        for (int i = 0; i < self.shopArray.count; i++) {
            MenuModel * menuMD1 = [self.shopArray objectAtIndex:i];
            //        MenuModel * menuMD1 = [ary firstObject];
            if ([menuMD1 isEqual:menuMD]) {
                //            [ary removeLastObject];
                menuMD1.count -= 1;
            }
            if (menuMD1.count == 0) {
                [self.shopArray removeObject:menuMD1];
                continue;
            }
        }
    }
    
    NSLog(@"-- shop = %@", self.shopArray);
    [self getAllPrice];
    [self getAllCount];
}

- (void)addMenuCount:(UIButton *)button
{

    MenuModel * menuMD = [self.menusArray objectAtIndex:button.tag - ADD_BUTTON_TAG];
    self.menuModel = menuMD;
    if (menuMD.PropertyList.count != 0) {
        [self tanchuPropertyWithModel:menuMD];
    }else
    {
        
//        menuMD.count += 1;
        self.shoppingCarView.countLabel.text = [NSString stringWithFormat:@"%ld", [self.shoppingCarView.countLabel.text integerValue] + 1];
        if (self.shopArray.count == 0) {
//            NSMutableArray * array = [NSMutableArray array];
//            [array addObject:menuMD];
            [self.shopArray addObject:menuMD];
            menuMD.count += 1;
            if ([menuMD.price doubleValue] > [self.sendPrice doubleValue] || [menuMD.price doubleValue] == [self.sendPrice doubleValue]) {
                self.shoppingCarView.changeButton.enabled = YES;
            }
        }else
        {
            BOOL have = NO;
            for (MenuModel * menuMOdel in self.shopArray) {
                if ([menuMOdel isEqual:menuMD]) {
//                    [smallAry addObject:menuMD];
                    menuMD.count += 1;
                    have = YES;
                    break;
                }
            }
            if (!have) {
//                NSMutableArray * smallAry = [NSMutableArray array];
//                [smallAry addObject:menuMD];
                [self.shopArray addObject:menuMD];
                menuMD.count += 1;
            }
        }
        [self getAllPrice];
        NSLog(@"shop = %@", self.shopArray);
        CGRect cellFrame = [self.menusTableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag - ADD_BUTTON_TAG inSection:0]];
        CGRect btFrame = button.frame;
        btFrame.origin.x = btFrame.origin.x + self.menusTableView.left;
        btFrame.origin.y = cellFrame.origin.y - self.menusTableView.contentOffset.y + button.origin.y + self.menusTableView.top;
        [self countLBAnimateWithFromeFrame:btFrame];
    }
    
    
}

// 菜品属性弹出
- (void)tanchuPropertyWithModel:(MenuModel *)model
{
    [self.view addSubview:_tanchuView];
    
    [_tanchuView removeAllSubviews];
    
    
    UIView * backView = [[UIView alloc]init];
    backView.frame = _tanchuView.frame;
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = .5;
    [_tanchuView addSubview:backView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeTanchuAction)];
    [backView addGestureRecognizer:tap];
    
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, _tanchuView.width - 40, self.view.height / 2)];
    scrollView.backgroundColor = [UIColor whiteColor];
    
    UILabel * topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, scrollView.width, 50)];
    topLabel.text = @"菜品属性";
    topLabel.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:topLabel];
    
    for (int i = 0; i < model.PropertyList.count; i++) {
        PropertyModel * propertymodel = [model.PropertyList objectAtIndex:i];
        PropertyView * propertyview = [[PropertyView alloc]initWithFrame:CGRectMake(0, 50 + 30 * i, scrollView.width, 30)];
        propertyview.nameLabel.text = propertymodel.styleName;
        propertyview.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", propertymodel.stylePrice];
        propertyview.integralLabel.text = [NSString stringWithFormat:@"积%d", propertymodel.styleIntegral];
        propertyview.countLabel.text = [NSString stringWithFormat:@"%d", propertymodel.count];
        propertyview.addButton.tag = PROPERTY_BUTTON_TAG + i;
        [propertyview.addButton addTarget:self action:@selector(addMenuPropertyAcyion:) forControlEvents:UIControlEventTouchUpInside];
        propertyview.subtractButton.tag = PROPERTY_BUTTON_TAG + i;
        [propertyview.subtractButton addTarget:self action:@selector(substractMenuPropertyAction:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:propertyview];
    }
    
    if (model.PropertyList.count > 5) {
        scrollView.frame = CGRectMake(0, 0, _tanchuView.width - 40 , 5 * 30 + 50);
        scrollView.contentSize = CGSizeMake(scrollView.width, model.PropertyList.count * 30 + 50);
    }else
    {
        scrollView.frame = CGRectMake(0, 0, _tanchuView.width - 40 , model.PropertyList.count * 30 + 50);
    }
    
    scrollView.center = _tanchuView.center;
    
    UIButton * sureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    sureButton.frame = CGRectMake(scrollView.left, scrollView.bottom, scrollView.width, 50);
    [sureButton setTitle:@"确认" forState:UIControlStateNormal];
    [sureButton setTintColor:[UIColor redColor]];
    sureButton.backgroundColor = [UIColor whiteColor];
    [sureButton addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    [_tanchuView addSubview:sureButton];
    
    [_tanchuView addSubview:scrollView];
    
    [self animateIn];

}
#pragma mark - 有属性加减菜个数

- (void)addMenuPropertyAcyion:(UIButton *)button
{
    if (self.shopArray.count == 0) {
        [self.shopArray addObject:self.menuModel];
        PropertyView * propertyView = (PropertyView *)[button superview];
        PropertyModel * model = [self.menuModel.PropertyList objectAtIndex:button.tag - PROPERTY_BUTTON_TAG ];
        
        model.count++;
        propertyView.countLabel.text = [NSString stringWithFormat:@"%d", model.count];
        
        self.menuModel.count++;
        NSInteger allPrice = [self getAllPrice];
        if (allPrice > [self.sendPrice doubleValue] || allPrice == [self.sendPrice doubleValue]) {
            self.shoppingCarView.changeButton.enabled = YES;
        }
        
    }else
    {
        BOOL isHave = NO;
        for (MenuModel * model in self.shopArray) {
            if ([model isEqual:self.menuModel]) {
                isHave = YES;
                break;
            }
        }
        if (!isHave) {
            [self.shopArray addObject:self.menuModel];
        }
        PropertyView * propertyView = (PropertyView *)[button superview];
        PropertyModel * model = [self.menuModel.PropertyList objectAtIndex:button.tag - PROPERTY_BUTTON_TAG ];
        
        model.count++;
        propertyView.countLabel.text = [NSString stringWithFormat:@"%d", model.count];
        
        self.menuModel.count++;
    }
    [self getAllPrice];
    [self getAllCount];
}

- (void)substractMenuPropertyAction:(UIButton *)button
{
    PropertyView * propertyView = (PropertyView *)[button superview];
    PropertyModel * model = [self.menuModel.PropertyList objectAtIndex:button.tag - PROPERTY_BUTTON_TAG ];
    if (model.count == 0) {
        ;
    }else
    {
        model.count--;
        int count = [propertyView.countLabel.text intValue];
        count--;
        propertyView.countLabel.text = [NSString stringWithFormat:@"%d", count];
        
        self.menuModel.count--;
    }
    
    propertyView.countLabel.text = [NSString stringWithFormat:@"%d", model.count];
    if (self.menuModel.count == 0) {
        [self.shopArray removeObject:self.menuModel];
    }
    
    [self getAllPrice];
    [self getAllCount];

}
#pragma mark 弹出框动画
- (void)animateIn
{
    self.tanchuView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.tanchuView.alpha = 0;
    [UIView animateWithDuration:0.35 animations:^{
        self.tanchuView.alpha = 1;
        self.tanchuView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}
#pragma mark - 移除弹出框
- (void)removeTanchuAction
{
    [_tanchuView removeFromSuperview];
}
- (void)sureAction:(UIButton *)button
{
    [_tanchuView removeFromSuperview];
}
- (void)clearShoppingCar:(UIButton *)button
{
    for (MenuModel * menuMD in self.shopArray) {
//        MenuModel * menuMD = [array firstObject];
        menuMD.count = 0;
        if (menuMD.PropertyList.count != 0) {
            for (PropertyModel * model in menuMD.PropertyList) {
                model.count = 0;
            }
        }
    }
    [self.shopArray removeAllObjects];
    [self.shoppingCarDetailsView removeFromSuperview];
    [self getAllCount];
    [self getAllPrice];
}

- (NSInteger)getAllPrice
{
    double allPrice = 0;
    for (MenuModel * model in self.shopArray) {
//        for (MenuModel * menuMD1 in smallAry) {
//            allPrice += [menuMD1.price doubleValue];
//        }
        if (model.PropertyList.count!= 0) {
            for (PropertyModel * propertyModel in model.PropertyList) {
                allPrice += propertyModel.stylePrice * propertyModel.count;
            }
        }else
        {
            allPrice += [model.price doubleValue] * model.count;
        }
    }
    if (allPrice < [self.sendPrice doubleValue] || [self getAllCount] == 0) {
        if ([self.storeState isEqualToNumber:@0]) {
            self.shoppingCarView.changeButton.enabled = NO;
            self.shoppingCarDetailsView.changeBT.enabled = NO;
            [self.shoppingCarDetailsView.changeBT setBackgroundImage:[UIImage imageNamed:@"storeState_g.png"] forState:UIControlStateDisabled];
            [self.shoppingCarView.changeButton setBackgroundImage:[UIImage imageNamed:@"storeState_g.png"] forState:UIControlStateDisabled];
        }
    }else
    {
        if ([self.storeState isEqualToNumber:@0]) {
            self.shoppingCarView.changeButton.enabled = NO;
            self.shoppingCarDetailsView.changeBT.enabled = NO;
//            [self.shoppingCarDetailsView.changeBT setBackgroundImage:[UIImage imageNamed:@"storeState_g.png"] forState:UIControlStateDisabled];
//            [self.shoppingCarView.changeButton setBackgroundImage:[UIImage imageNamed:@"storeState_g.png"] forState:UIControlStateDisabled];
        }else
        {
            self.shoppingCarView.changeButton.enabled = YES;
        }
    }
//    allPrice += self.mealBoxMoney.doubleValue * [self getAllCount] + self.outSentMoney.doubleValue;
    if (self.sendPrice != nil) {
       self.shoppingCarView.priceLabel.text = [NSString stringWithFormat:@"¥%g(¥%@起送)", allPrice, self.sendPrice];
    }else
    {
        self.shoppingCarView.priceLabel.text = [NSString stringWithFormat:@"¥%g", allPrice];
    }
    
    return allPrice;
}


- (NSInteger)getAllCount
{
    NSInteger allCount = 0;
    for (MenuModel * model in self.shopArray) {
        if (model.PropertyList.count != 0) {
            for (PropertyModel * pModel in model.PropertyList) {
                allCount += pModel.count;
            }
        }else
        {
            allCount += model.count;
        }
    }
    self.shoppingCarView.countLabel.text = [NSString stringWithFormat:@"%ld", (long)allCount];
    return allCount;
}

- (void)countLBAnimateWithFromeFrame:(CGRect)frame
{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    
//    CGContextSetRGBFillColor (context,  100, 0, 0, 1.0);//设置填充颜色

    
    UILabel * redView = [[UILabel alloc] initWithFrame:frame];
    redView.size = CGSizeMake(20, 20);
    redView.text = @"1";
    redView.textAlignment = NSTextAlignmentCenter;
    redView.textColor = [UIColor whiteColor];
    redView.layer.backgroundColor = [UIColor redColor].CGColor;
    redView.layer.cornerRadius = 10;
    [self.aScrollView addSubview:redView];
    CGRect rect = CGRectMake(65, _shoppingCarView.top - 10, 20, 20);
    
//    CGContextMoveToPoint(context, frame.origin.x, frame.origin.y);
//    CGContextAddQuadCurveToPoint(context, frame.origin.x, frame.origin.y, rect.origin.x, rect.origin.y);
//    CGContextStrokePath(context);
    
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
//            [SVProgressHUD showWithStatus:@"登录中..." maskType:SVProgressHUDMaskTypeClear];
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
//                        [SVProgressHUD showWithStatus:@"登录中..." maskType:SVProgressHUDMaskTypeClear];
                    }else
                    {
//                        [SVProgressHUD dismiss];
                    }
                }else
                {
//                    [SVProgressHUD dismiss];
                }
            }
        }else
        {
//            [SVProgressHUD dismiss];
        }
    }else
    {
//        [SVProgressHUD dismiss];
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
    NSInteger row = button.tag - 10000;
    MenuModel * menuMd = [self.menusArray objectAtIndex:row];
    CGPoint point = self.menusTableView.contentOffset;
    CGRect cellRect = [self.menusTableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    CGRect btFrame = button.frame;
    btFrame.origin.y = cellRect.origin.y - point.y + button.frame.origin.y + self.menusTableView.top;
    btFrame.origin.x = self.menusTableView.left + button.left;
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
    [imageView setImageWithURL:[NSURL URLWithString:menuMd.icon] placeholderImage:[UIImage imageNamed:@"placeholderIM.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
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


#pragma mark - scrollView Deletage 

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [self.segmentC changeSegmentedControlWithIndex:(scrollView.contentOffset.x + scrollView.width / 2) / scrollView.width];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_aScrollView]) {
        [self.segmentC changeSegmentedControlWithIndex:scrollView.contentOffset.x / scrollView.width];
    }
}

#pragma mark - 商家简介地址点击事件
- (void)addressAction:button
{
//    NSLog(@"查询商家地址");
    
    GSMapViewController *gsMapVC = [[GSMapViewController alloc]init];
    gsMapVC.gsName = self.storeName;
    gsMapVC.address = self.introView.StoreAdress.text;
    gsMapVC.lat = self.lat;
    gsMapVC.lon = self.lon;
    [self.navigationController pushViewController:gsMapVC animated:YES];
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
