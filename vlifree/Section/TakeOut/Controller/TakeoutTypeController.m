//
//  TakeoutTypeController.m
//  vlifree
//
//  Created by 仙林 on 16/4/7.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "TakeoutTypeController.h"
#import "TypeView.h"
#import "TakeoutTypeView.h"
#import "TakeoutTypeviewCell.h"
#import "SearchViewController.h"
#import "TakeOutViewCell.h"
#import "TakeOutModel.h"
#import "MGSwipeButton.h"
#import "DetailTakeOutViewController.h"
//#import "StoreTypeModel.h"
#define TYPEBUTTON_TAG 1000
#define SORTBUTTON_TAG 2000
#define ACTIVITYBUTTON_TAG 3000

#define TYPEDROPDOWNVIEW_HEIGHT  _headView.width / 2
#define SORTDROPDOWNVIEW_HEIGHT 160
#define ACTIVITYDROPDOWNVIEW_HEIGHT 160

#define CELL_INDENTIFIER @"takeoutCell"

@interface TakeoutTypeController ()<UITableViewDataSource, UITableViewDelegate, HTTPPostDelegate>

@property (nonatomic, strong)TakeoutTypeView * typeSelectview;
@property (nonatomic, strong)TypeView * typeView;

@property (nonatomic, strong)TakeoutTypeView * sortView;
@property (nonatomic, strong)UITableView * sortTableview;
@property (nonatomic, strong)NSArray * sorttitleArr;

@property (nonatomic, strong)TakeoutTypeView * activityView;
@property (nonatomic, strong)UITableView * activityTableView;
@property (nonatomic, strong)NSArray * activitytitleArr;

@property (nonatomic, strong)UIView * headView;

@property (nonatomic, strong)UIView * typedropdownView;
@property (nonatomic, strong)UIView * sortdropdownView;
@property (nonatomic, strong)UIView * activitydropdownView;
@property (nonatomic, strong)UIView * shadowView;

@property (nonatomic, strong)UITableView * takeoutTableview;
@property (nonatomic, strong)NSMutableArray * takeoutArray;
@property (nonatomic, strong)NSNumber * takeoutAllCount;
@property (nonatomic, assign)int takeoutPage;

@property (nonatomic, strong)TakeOutModel * collectModel;

@property (nonatomic, strong)NSNumber * sortType;
@property (nonatomic, strong)NSNumber * favourableType;

@end

@implementation TakeoutTypeController

- (NSMutableArray *)takeoutArray
{
    if (!_takeoutArray) {
        self.takeoutArray = [NSMutableArray array];
    }
    return _takeoutArray;
}
- (NSArray *)sorttitleArr
{
    if (!_sorttitleArr) {
        self.sorttitleArr = [NSArray array];
    }
    return _sorttitleArr;
}

- (NSArray *)activitytitleArr
{
    if (!_activitytitleArr) {
        self.activitytitleArr = [NSArray array];
    }
    return _activitytitleArr;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchTakeOut:)];
    
    UIButton * backBT = [UIButton buttonWithType:UIButtonTypeCustom];
    backBT.frame = CGRectMake(0, 0, 15, 20);
    [backBT setBackgroundImage:[UIImage imageNamed:@"back_black.png"] forState:UIControlStateNormal];
    [backBT addTarget:self action:@selector(backLastVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBT];
    
    [self creatSubviews];
    _sortType = @0;
    _favourableType = @0;
    _takeoutPage = 1;
    [self downloadDataWithCommand:@6 page:1 count:DATA_COUNT type:_type sortType:_sortType favourrableType:_favourableType];
//    [self.takeoutTableview.header beginRefreshing];
}

- (void)creatSubviews
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
    _headView.backgroundColor = [UIColor whiteColor];
    
    
    self.takeoutTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, _headView.bottom , self.view.width, self.view.height - self.tabBarController.tabBar.height - _headView.height) style:UITableViewStylePlain];
    _takeoutTableview.dataSource = self;
    _takeoutTableview.delegate = self;
    self.takeoutTableview.tableFooterView = [[UIView alloc] init];
    self.takeoutTableview.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    self.takeoutTableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [self.takeoutTableview registerClass:[TakeOutViewCell class] forCellReuseIdentifier:CELL_INDENTIFIER];
    [self.view addSubview:_takeoutTableview];

    
    self.typeSelectview = [[TakeoutTypeView alloc]initWithFrame:CGRectMake(0, 0, _headView.width / 3, _headView.height)];
    [self.typeSelectview.titleBT setTitle:self.takeoutType forState:UIControlStateNormal];
    [_headView addSubview:_typeSelectview];
    
    __weak TakeoutTypeController * takeouttypeVC = self;
    [self.typeSelectview screenAction:^(BOOL selectState) {
        
        takeouttypeVC.sortView.titleBT.selected = NO;
        takeouttypeVC.activityView.titleBT.selected = NO;
        
        if (selectState) {
            
            takeouttypeVC.shadowView.alpha = 0;
            takeouttypeVC.shadowView.hidden = YES;
            if (!takeouttypeVC.sortdropdownView.hidden) {
                takeouttypeVC.sortdropdownView.frame = CGRectMake(0, _headView.bottom - SORTDROPDOWNVIEW_HEIGHT, _headView.width, SORTDROPDOWNVIEW_HEIGHT);
                takeouttypeVC.sortdropdownView.hidden = YES;
            }
            if (!takeouttypeVC.activitydropdownView.hidden) {
                takeouttypeVC.activitydropdownView.frame = CGRectMake(0, _headView.bottom - ACTIVITYDROPDOWNVIEW_HEIGHT, _headView.width, ACTIVITYDROPDOWNVIEW_HEIGHT);
                takeouttypeVC.activitydropdownView.hidden = YES;
            }
            
            takeouttypeVC.shadowView.hidden = NO;
            takeouttypeVC.typedropdownView.hidden = NO;
            [UIView animateWithDuration:0.3 animations:^{
                takeouttypeVC.shadowView.alpha = .5;
                takeouttypeVC.typedropdownView.alpha = 1;
                takeouttypeVC.typedropdownView.frame = CGRectMake(0, _headView.bottom , _headView.width, TYPEDROPDOWNVIEW_HEIGHT);
            } completion:^(BOOL finished) {
                takeouttypeVC.shadowView.hidden = NO;
                takeouttypeVC.typedropdownView.hidden = NO;
            }];
        }else
        {
            [UIView animateWithDuration:0.3 animations:^{
                takeouttypeVC.shadowView.alpha = 0;
                takeouttypeVC.typedropdownView.alpha = 0;
                takeouttypeVC.typedropdownView.frame = CGRectMake(0, _headView.bottom - TYPEDROPDOWNVIEW_HEIGHT, _headView.width, TYPEDROPDOWNVIEW_HEIGHT);
            } completion:^(BOOL finished) {
                takeouttypeVC.shadowView.hidden = YES;
                takeouttypeVC.typedropdownView.hidden = YES;
            }];
        }
        
//        NSLog(@"type");
    }];
    
    
    self.sortView = [[TakeoutTypeView alloc]initWithFrame:CGRectMake(_typeSelectview.right, 0, _typeSelectview.width, _typeSelectview.height)];
    [self.sortView.titleBT setTitle:@"综合排序" forState:UIControlStateNormal];
    [_headView addSubview:_sortView];
    [self.sortView screenAction:^(BOOL selectState){
        takeouttypeVC.typeSelectview.titleBT.selected = NO;
        takeouttypeVC.activityView.titleBT.selected = NO;
        
        if (selectState) {
            takeouttypeVC.shadowView.alpha = 0;
            takeouttypeVC.shadowView.hidden = YES;
            if (!takeouttypeVC.typedropdownView.hidden) {
                takeouttypeVC.typedropdownView.frame = CGRectMake(0, _headView.bottom - TYPEDROPDOWNVIEW_HEIGHT, _headView.width, TYPEDROPDOWNVIEW_HEIGHT);
                takeouttypeVC.typedropdownView.hidden = YES;
            }
            if (!takeouttypeVC.activitydropdownView.hidden) {
                takeouttypeVC.activitydropdownView.frame = CGRectMake(0, _headView.bottom - ACTIVITYDROPDOWNVIEW_HEIGHT, _headView.width, ACTIVITYDROPDOWNVIEW_HEIGHT);
                takeouttypeVC.activitydropdownView.hidden = YES;
            }
            
            takeouttypeVC.shadowView.hidden = NO;
            takeouttypeVC.sortdropdownView.hidden = NO;
            [UIView animateWithDuration:0.3 animations:^{
                takeouttypeVC.shadowView.alpha = .5;
                takeouttypeVC.sortdropdownView.alpha = 1;
                takeouttypeVC.sortdropdownView.frame = CGRectMake(0, _headView.bottom , _headView.width, SORTDROPDOWNVIEW_HEIGHT);
            } completion:^(BOOL finished) {
                takeouttypeVC.shadowView.hidden = NO;
                takeouttypeVC.sortdropdownView.hidden = NO;
            }];
        }else
        {
            [UIView animateWithDuration:0.3 animations:^{
                takeouttypeVC.shadowView.alpha = 0;
                takeouttypeVC.sortdropdownView.alpha = 0;
                takeouttypeVC.sortdropdownView.frame = CGRectMake(0, _headView.bottom - SORTDROPDOWNVIEW_HEIGHT, _headView.width, SORTDROPDOWNVIEW_HEIGHT);
            } completion:^(BOOL finished) {
                takeouttypeVC.shadowView.hidden = YES;
                takeouttypeVC.sortdropdownView.hidden = YES;
            }];
        }
        
//        NSLog(@"sort");
    }];
    
    self.activityView = [[TakeoutTypeView alloc]initWithFrame:CGRectMake(_sortView.right, 0, _typeSelectview.width, _typeSelectview.height)];
    [self.activityView.titleBT setTitle:@"全部" forState:UIControlStateNormal];
    [_headView addSubview:_activityView];
    [self.activityView screenAction:^(BOOL selectState){
        takeouttypeVC.sortView.titleBT.selected = NO;
        takeouttypeVC.typeSelectview.titleBT.selected = NO;
        
        if (selectState) {
            takeouttypeVC.shadowView.alpha = 0;
            takeouttypeVC.shadowView.hidden = YES;
            if (!takeouttypeVC.typedropdownView.hidden) {
                takeouttypeVC.typedropdownView.frame = CGRectMake(0, _headView.bottom - TYPEDROPDOWNVIEW_HEIGHT, _headView.width, TYPEDROPDOWNVIEW_HEIGHT);
                takeouttypeVC.typedropdownView.hidden = YES;
            }
            if (!takeouttypeVC.sortdropdownView.hidden) {
                takeouttypeVC.sortdropdownView.frame = CGRectMake(0, _headView.bottom - SORTDROPDOWNVIEW_HEIGHT, _headView.width, SORTDROPDOWNVIEW_HEIGHT);
                takeouttypeVC.sortdropdownView.hidden = YES;
            }
            takeouttypeVC.shadowView.hidden = NO;
            takeouttypeVC.activitydropdownView.hidden = NO;

            [UIView animateWithDuration:0.3 animations:^{
                takeouttypeVC.shadowView.alpha = .5;
                takeouttypeVC.activitydropdownView.alpha = 1;
                takeouttypeVC.activitydropdownView.frame = CGRectMake(0, _headView.bottom, _headView.width, ACTIVITYDROPDOWNVIEW_HEIGHT);
            } completion:^(BOOL finished) {
                takeouttypeVC.shadowView.hidden = NO;
                takeouttypeVC.activitydropdownView.hidden = NO;
            }];
        }else
        {
            [UIView animateWithDuration:0.3 animations:^{
                takeouttypeVC.shadowView.alpha = 0;
                takeouttypeVC.activitydropdownView.alpha = 0;
                takeouttypeVC.activitydropdownView.frame = CGRectMake(0, _headView.bottom - ACTIVITYDROPDOWNVIEW_HEIGHT, _headView.width, ACTIVITYDROPDOWNVIEW_HEIGHT);
            } completion:^(BOOL finished) {
                takeouttypeVC.shadowView.hidden = YES;
                takeouttypeVC.activitydropdownView.hidden = YES;
            }];
        }
        
//        NSLog(@"activity");
    }];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, _headView.bottom - 1.5, _headView.width, 1.5)];
    lineView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [_headView addSubview:lineView];
    
    self.shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, _headView.bottom, _headView.width, self.view.height - _headView.bottom)];
    _shadowView.backgroundColor = [UIColor colorWithWhite:.5 alpha:.4];
    _shadowView.hidden = YES;
    _shadowView.alpha = 0;
    [self.view addSubview:_shadowView];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [_shadowView addGestureRecognizer:tap];
    
    // 分类下拉框
    self.typedropdownView = [[UIView alloc]initWithFrame:CGRectMake(0, _headView.bottom - TYPEDROPDOWNVIEW_HEIGHT, _headView.width, TYPEDROPDOWNVIEW_HEIGHT)];
    self.typedropdownView.backgroundColor = [UIColor whiteColor];
    self.typedropdownView.hidden = YES;
    _typedropdownView.alpha = 0;
    [self.view addSubview:_typedropdownView];
    UIScrollView * typedropdownScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, _typedropdownView.width, _typedropdownView.height)];
    typedropdownScrollview.backgroundColor = [UIColor whiteColor];
    [_typedropdownView addSubview:typedropdownScrollview];
    
    self.typeView = [[TypeView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, TYPEDROPDOWNVIEW_HEIGHT )];
    for (int i = 0; i < 8; i++) {
        UIButton * button = (UIButton *)[self.typeView viewWithTag:9000 + i];
        [button addTarget:self action:@selector(selectTakeOutType:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.typedropdownView addSubview:self.typeView];
    
    // 排序下拉框
    self.sortdropdownView = [[UIView alloc]initWithFrame:CGRectMake(0, _headView.bottom - SORTDROPDOWNVIEW_HEIGHT, _headView.width, SORTDROPDOWNVIEW_HEIGHT)];
    self.sortdropdownView.backgroundColor = [UIColor whiteColor];
    self.sortdropdownView.hidden = YES;
    _sortdropdownView.alpha = 0;
    [self.view addSubview:_sortdropdownView];
    self.sorttitleArr = @[@"综合排序", @"销量排序", @"评分排序", @"起送价排序"];
    self.sortTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, _sortdropdownView.width, _sortdropdownView.height) style:UITableViewStylePlain];
    [self.sortdropdownView addSubview:_sortTableview];
    [self.sortTableview registerClass:[TakeoutTypeviewCell class] forCellReuseIdentifier:@"cell"];
    _sortTableview.dataSource = self;
    _sortTableview.delegate = self;

    
    // 优惠下拉框
    self.activitydropdownView = [[UIView alloc]initWithFrame:CGRectMake(0, _headView.bottom - ACTIVITYDROPDOWNVIEW_HEIGHT, _headView.width, ACTIVITYDROPDOWNVIEW_HEIGHT)];
    self.activitydropdownView.backgroundColor = [UIColor whiteColor];
    self.activitydropdownView.hidden = YES;
    _activitydropdownView.alpha = 0;
    [self.view addSubview:_activitydropdownView];
    self.activitytitleArr = @[@"全部", @"首单立减", @"满减优惠", @"优惠券"];
    self.activityTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, _activitydropdownView.width, _activitydropdownView.height) style:UITableViewStylePlain];
    [self.activitydropdownView addSubview:_activityTableView];
    [self.activityTableView registerClass:[TakeoutTypeviewCell class] forCellReuseIdentifier:@"cell"];
    _activityTableView.dataSource = self;
    _activityTableView.delegate = self;

    [self.view addSubview:_headView];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    self.navigationController.navigationBar.tintColor = MAIN_COLOR;
    //    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self.takeoutTableview.header beginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}
- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - search
- (void)searchTakeOut:(id)sender
{
    //    NSLog(@"搜索");
    SearchViewController * searchVC = [[SearchViewController alloc] init];
//    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}


#pragma mark - 轻拍移除下拉框
- (void)tapAction:(UITapGestureRecognizer *)sender
{
    if (self.typeSelectview.titleBT.selected) {
        self.typeSelectview.titleBT.selected = !self.typeSelectview.titleBT.selected;
        [UIView animateWithDuration:0.3 animations:^{
            self.shadowView.alpha = 0;
            self.typedropdownView.alpha = 0;
            self.typedropdownView.frame = CGRectMake(0, _headView.bottom - TYPEDROPDOWNVIEW_HEIGHT, _headView.width, TYPEDROPDOWNVIEW_HEIGHT);
        } completion:^(BOOL finished) {
            self.shadowView.hidden = YES;
            self.typedropdownView.hidden = YES;
        }];
        
    }else if (self.sortView.titleBT.selected)
    {
        self.sortView.titleBT.selected = !self.sortView.titleBT.selected;
        [UIView animateWithDuration:0.3 animations:^{
            self.shadowView.alpha = 0;
            self.sortdropdownView.alpha = 0;
            self.sortdropdownView.frame = CGRectMake(0, _headView.bottom - SORTDROPDOWNVIEW_HEIGHT, _headView.width, SORTDROPDOWNVIEW_HEIGHT);
        } completion:^(BOOL finished) {
            self.shadowView.hidden = YES;
            self.sortdropdownView.hidden = YES;
        }];
    }else if (self.activityView.titleBT.selected)
    {
        self.activityView.titleBT.selected = !self.activityView.titleBT.selected;
        [UIView animateWithDuration:0.3 animations:^{
            self.shadowView.alpha = 0;
            self.activitydropdownView.alpha = 0;
            self.activitydropdownView.frame = CGRectMake(0, _headView.bottom - ACTIVITYDROPDOWNVIEW_HEIGHT, _headView.width, ACTIVITYDROPDOWNVIEW_HEIGHT);
        } completion:^(BOOL finished) {
            self.shadowView.hidden = YES;
            self.activitydropdownView.hidden = YES;
        }];
    }
}
#pragma mark - 分类选择
-(void)selectTakeOutType:(UIButton *)button
{
    switch (button.tag) {
        case 9000:
        {
            [self.typeSelectview.titleBT setTitle:@"美食" forState:UIControlStateNormal];
            _type = 1;
        }
            break;
        case 9001:
        {
            [self.typeSelectview.titleBT setTitle:@"甜品饮食" forState:UIControlStateNormal];
            _type = 2;
        }
            break;
        case 9002:
        {
           [self.typeSelectview.titleBT setTitle:@"水果" forState:UIControlStateNormal];
            _type = 3;
        }
            break;
        case 9003:
        {
            [self.typeSelectview.titleBT setTitle:@"超市" forState:UIControlStateNormal];
            _type = 4;
        }
            break;
        case 9004:
        {
            [self.typeSelectview.titleBT setTitle:@"零食小吃" forState:UIControlStateNormal];
            _type = 5;
            
        }
            break;
        case 9005:
        {
            [self.typeSelectview.titleBT setTitle:@"鲜花蛋糕" forState:UIControlStateNormal];
            _type = 6;
            
        }
            break;
        case 9006:
        {
            [self.typeSelectview.titleBT setTitle:@"送药上门" forState:UIControlStateNormal];
            _type = 7;
            
        }
            break;
        case 9007:
        {
           [self.typeSelectview.titleBT setTitle:@"蔬菜" forState:UIControlStateNormal];
            _type = 8;
        }
            break;
            
        default:
            break;
    }
    
    self.typeSelectview.titleBT.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.shadowView.alpha = 0;
        self.typedropdownView.alpha = 0;
        self.typedropdownView.frame = CGRectMake(0, _headView.bottom - TYPEDROPDOWNVIEW_HEIGHT, _headView.width, TYPEDROPDOWNVIEW_HEIGHT);
    } completion:^(BOOL finished) {
        self.shadowView.hidden = YES;
        self.typedropdownView.hidden = YES;
    }];
    _takeoutPage = 1;
    [self downloadDataWithCommand:@6 page:1 count:DATA_COUNT type:_type sortType:_sortType favourrableType:_favourableType];
    [self.takeoutTableview.header beginRefreshing];

}

#pragma mark - tableviewdelegete and tableviewdatesource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.sortTableview]) {
        return self.sorttitleArr.count;
    }else if ([tableView isEqual:self.activityTableView])
    {
        return self.activitytitleArr.count;
    }else
    {
        return self.takeoutArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.sortTableview]) {
        
        TakeoutTypeviewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.titleLabel.text = self.sorttitleArr[indexPath.row];

        return cell;
    }else if ([tableView isEqual:self.activityTableView])
    {
        NSArray * iconarr = @[@"全部.png", @"shou_jian.png", @"man_jian.png", @"you_jian.png"];
        TakeoutTypeviewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.titleLabel.text = self.activitytitleArr[indexPath.row];
        cell.iconImageview.image = [UIImage imageNamed:iconarr[indexPath.row]];

        return cell;
    }else
    {
        TakeOutModel * takeOutMD = [self.takeoutArray objectAtIndex:indexPath.row];
        TakeOutViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_INDENTIFIER];
        if (!cell) {
            cell = [[TakeOutViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_INDENTIFIER];
        }
        [cell createSubview:tableView.bounds activityCount:(int)takeOutMD.activityArray.count];
        cell.separatorInset = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
        cell.layoutMargins = UIEdgeInsetsZero;
        __weak TakeoutTypeController * takeOutVC = self;
        cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"关注商店" backgroundColor:[UIColor redColor] callback:^BOOL(MGSwipeTableCell *sender) {
            if ([UserInfo shareUserInfo].userId) {
                self.collectModel = takeOutMD;
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@28,
                                           @"Flag":@2,
                                           @"Id":takeOutMD.storeId
                                           };
                [takeOutVC playPostWithDictionary:jsonDic];
            }else
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"收藏需要先登录" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
            }
            return YES;
        }]];
        [cell.IconButton addTarget:self action:@selector(lookBigImage:) forControlEvents:UIControlEventTouchUpInside];
        cell.takeOutModel = takeOutMD;
        cell.IconButton.tag = 5000000 + indexPath.row + indexPath.section * 1000;
        return cell;

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.sortTableview] || [tableView isEqual:self.activityTableView]) {
        return 40;
    }else
    {
        TakeOutModel * takoOutMD = [self.takeoutArray  objectAtIndex:indexPath.row];
        return [TakeOutViewCell cellHeightWithTakeOutModel:takoOutMD];
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.sortTableview] || [tableView isEqual:self.activityTableView]) {
        return 40;
    }else
    {
        return 10;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.sortTableview]) {
        
        TakeoutTypeviewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        [self.sortView.titleBT setTitle:cell.titleLabel.text forState:UIControlStateNormal];
        self.sortView.titleBT.selected = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.shadowView.alpha = 0;
            self.sortdropdownView.alpha = 0;
            self.sortdropdownView.frame = CGRectMake(0, _headView.bottom - SORTDROPDOWNVIEW_HEIGHT, _headView.width, SORTDROPDOWNVIEW_HEIGHT);
        } completion:^(BOOL finished) {
            self.shadowView.hidden = YES;
            self.sortdropdownView.hidden = YES;
        }];
        
        _sortType = @(indexPath.row);
        _takeoutPage = 1;
        [self downloadDataWithCommand:@6 page:1 count:DATA_COUNT type:_type sortType:_sortType favourrableType:_favourableType];
        
    }else if ([tableView isEqual:self.activityTableView])
    {
        TakeoutTypeviewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        [self.activityView.titleBT setTitle:cell.titleLabel.text forState:UIControlStateNormal];
        self.activityView.titleBT.selected = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.shadowView.alpha = 0;
            self.activitydropdownView.alpha = 0;
            self.activitydropdownView.frame = CGRectMake(0, _headView.bottom - ACTIVITYDROPDOWNVIEW_HEIGHT, _headView.width, ACTIVITYDROPDOWNVIEW_HEIGHT);
        } completion:^(BOOL finished) {
            self.shadowView.hidden = YES;
            self.activitydropdownView.hidden = YES;
        }];
        
        _favourableType = @(indexPath.row);
        _takeoutPage = 1;
        [self downloadDataWithCommand:@6 page:1 count:DATA_COUNT type:_type sortType:_sortType favourrableType:_favourableType];
        
    }else
    {
        TakeOutModel * takeOutMD = [self.takeoutArray  objectAtIndex:indexPath.row];
        DetailTakeOutViewController * detailTakeOutVC = [[DetailTakeOutViewController alloc] init];
        detailTakeOutVC.takeOutID = takeOutMD.storeId;
        detailTakeOutVC.sendPrice = takeOutMD.sendPrice;
        detailTakeOutVC.outSentMoney = takeOutMD.outSentMoney;
        detailTakeOutVC.storeState = takeOutMD.storeState;
        detailTakeOutVC.storeName = takeOutMD.storeName;
        detailTakeOutVC.iConimageURL = takeOutMD.icon;
        detailTakeOutVC.navigationItem.title = takeOutMD.storeName;
        [self.navigationController pushViewController:detailTakeOutVC animated:YES];
    }
}


#pragma mark - 数据请求
- (void)downloadDataWithCommand:(NSNumber *)command page:(int)page count:(int)count type:(int)type sortType:(NSNumber *)sortType favourrableType:(NSNumber *)favourableType
{
    if ([UserLocation shareUserLocation].city) {
        NSDictionary * jsonDic = @{
                                   @"Command":command,
                                   @"CurPage":[NSNumber numberWithInt:page],
                                   @"CurCount":[NSNumber numberWithInt:count],
                                   @"Lat":[NSNumber numberWithDouble:[UserLocation shareUserLocation].userLocation.latitude],
                                   @"Lon":[NSNumber numberWithDouble:[UserLocation shareUserLocation].userLocation.longitude],
                                   @"City":[UserLocation shareUserLocation].city,
                                   @"WakeoutType":[NSNumber numberWithInt:type],
                                   @"SortType":sortType,
                                   @"Favourableactivity":favourableType
                                   };
        [self playPostWithDictionary:jsonDic];
    }
    
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
    [self.takeoutTableview.header endRefreshing];
    [self.takeoutTableview.footer endRefreshing];
        NSLog(@"+++%@", data);
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        NSLog(@"%@", [data objectForKey:@"ErrorMsg"]);
        if ([[data objectForKey:@"Command"] isEqualToNumber:@10006]) {
            self.takeoutAllCount = [data objectForKey:@"AllCount"];
            NSArray * array = [data objectForKey:@"StoreList"];
            if(_takeoutPage == 1)
            {
                _takeoutArray = nil;
            }
            NSInteger count = 0;
            for (NSDictionary * dic in array) {
                TakeOutModel * takeOutMD = [[TakeOutModel alloc] initWithDictionary:dic];
                [self.takeoutArray addObject:takeOutMD];

                count++;
            }
            
            [self.takeoutTableview reloadData];
            if (count > 0) {
                [self.takeoutTableview.footer resetNoMoreData];
            }else
            {
                [self.takeoutTableview.footer noticeNoMoreData];
            }
            
            
        }else if([[data objectForKey:@"Command"] isEqualToNumber:@10028])
        {
            
            [UserInfo shareUserInfo].collectCount = [NSNumber numberWithInt:([UserInfo shareUserInfo].collectCount.intValue + 1)];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"收藏成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
        }
    }else
    {
        if (((NSString *)[data objectForKey:@"ErrorMsg"]).length == 0) {
            ;
        }else
        {
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
        }
    }
}

- (void)failWithError:(NSError *)error
{
    [self.takeoutTableview.header endRefreshing];
    [self.takeoutTableview.footer endRefreshing];
    //    [SVProgressHUD dismiss];
    NSLog(@"%@", error);
}

#pragma mark - 数据刷新,加载更多

- (void)headerRereshing
{
    [self.takeoutTableview.footer resetNoMoreData];
    [self downloadDataWithCommand:@6 page:1 count:DATA_COUNT type:_type sortType:_sortType favourrableType:_favourableType];
    _takeoutPage = 1;
}

- (void)footerRereshing
{
//        NSInteger count = 0;
//        for (NSMutableArray * array in self.takeoutArray) {
//            count += array.count;
//        }
//        if (self.takeoutArray.count < [_takeoutAllCount integerValue]) {
//    //        self.takeOutTabelView.footerRefreshingText = @"正在加载数据";
//            [self.takeoutTableview.footer resetNoMoreData];
    [self downloadDataWithCommand:@6 page:++_takeoutPage count:DATA_COUNT type:_type sortType:_sortType favourrableType:_favourableType];
//        }else
//        {
//    //        self.takeOutTabelView.footerRefreshingText = @"数据已经加载完";
//            [self.takeoutTableview.footer noticeNoMoreData];
//            [self.takeoutTableview performSelector:@selector(footerEndRefreshing) withObject:nil afterDelay:1.5];
//        }
    
}
#pragma mark - 点击图片放大

- (void)lookBigImage:(UIButton *)button
{
    NSInteger section = (button.tag - 5000000) / 1000;
    NSInteger row = (button.tag - 5000000) % 1000;
    TakeOutModel * takeOutMd = [self.takeoutArray  objectAtIndex:row];
    CGPoint point = self.takeoutTableview.contentOffset;
    CGRect cellRect = [self.takeoutTableview rectForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    CGRect btFrame = button.frame;
    btFrame.origin.y = cellRect.origin.y - point.y + button.frame.origin.y  + self.headView.height;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBigImage)];
    
    UIView * view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.tag = 70000;
    [view addGestureRecognizer:tapGesture];
    view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.3];
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    imageView.center = view.center;
    imageView.layer.cornerRadius = 30;
    imageView.layer.masksToBounds = YES;
    
    imageView.image = [UIImage imageNamed:@"superMarket.png"];
    __weak UIImageView * imageV = imageView;
    [imageView setImageWithURL:[NSURL URLWithString:takeOutMd.icon] placeholderImage:[UIImage imageNamed:@"placeholderIM.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (error) {
            imageV.image = [UIImage imageNamed:@"load_fail.png"];
        }
    }];
    CGRect imageFrame = imageView.frame;
    imageView.frame = btFrame;
    
    [view addSubview:imageView];
    [self.view.window addSubview:view];
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

//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([tableView isEqual:self.sortTableview]) {
//        
//        TakeoutTypeviewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
//        cell.selected = NO;
//        
//    }else if ([tableView isEqual:self.activityTableView])
//    {
//        TakeoutTypeviewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
//        cell.selected = NO;
//       
//    }
//}

@end
