//
//  SearchViewController.m
//  vlifree
//
//  Created by 仙林 on 15/5/19.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "SearchViewController.h"
#import "ResultViewController.h"
#import "TakeOutViewCell.h"
#import "TakeOutModel.h"
#import "DetailTakeOutViewController.h"

@interface SearchViewController ()<UISearchBarDelegate, UISearchResultsUpdating, HTTPPostDelegate>

{
    /**
     *  数据请求页数
     */
    int _page;
}
/**
 *  搜索框
 */
//@property (nonatomic, strong)UISearchBar * searchBar;
/**
 *  搜索VC
 */
@property (nonatomic, strong)UISearchController * searchVC;
/**
 *  模糊搜索词展示列表
 */
@property (nonatomic, strong)ResultViewController * resultVC;
/**
 *  数据数组
 */
@property (nonatomic, strong)NSMutableArray * dataArray;


@end

@implementation SearchViewController


- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 5, 150, 30)];
//    self.searchBar.center = CGPointMake(self.view.centerX, self.searchBar.centerY);
//    self.searchBar.placeholder = @"关键字";
//    [self.navigationController.navigationBar addSubview:self.searchBar];
    UIView * searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    searchView.backgroundColor = [UIColor greenColor];
    
    self.resultVC = [[ResultViewController alloc] init];
    _resultVC.action = @selector(searchHotTaglibWithKeyWord:);
    _resultVC.target = self;
    self.searchVC = [[UISearchController alloc] initWithSearchResultsController:_resultVC];
    _searchVC.hidesNavigationBarDuringPresentation = NO;
    [self.searchVC.searchBar sizeThatFits:CGSizeMake(150, 30)];
    //直接将搜索框放到UITableView的headerView上
    [searchView addSubview:_searchVC.searchBar];
//    searchView = _searchVC.searchBar;
    self.navigationItem.titleView = _searchVC.searchBar;
    self.definesPresentationContext = YES;
    //_searchController.searchResultsUpdater = self.resultVC;
    _searchVC.searchResultsUpdater = self;
    _searchVC.searchBar.delegate = self;
    _searchVC.searchResultsUpdater = self.resultVC;
    _searchVC.searchBar.placeholder = @"请输入关键字";
    
    [self.tableView registerClass:[TakeOutViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    UIButton * backBT = [UIButton buttonWithType:UIButtonTypeCustom];
    backBT.frame = CGRectMake(0, 0, 15, 20);
    [backBT setBackgroundImage:[UIImage imageNamed:@"back_w.png"] forState:UIControlStateNormal];
    [backBT addTarget:self action:@selector(backLastVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBT];
    
    
    // Do any additional setup after loading the view.
}



- (void)searchHotTaglibWithKeyWord:(NSString *)keyWords
{
    NSLog(@"%@", keyWords);
    _page = 1;
    NSDictionary * jsonDic = @{
                               @"Command":@19,
                               @"KeyWord":keyWords,
                               @"CurPage":@1,
                               @"CurCount":[NSNumber numberWithInt:COUNT],
                               @"City":[UserLocation shareUserLocation].city
                               };
    [self playPostWithDictionary:jsonDic];
    self.searchVC.active = NO;
}


- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = MAIN_COLOR;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.searchBar.hidden = YES;
//    [self.searchBar resignFirstResponder];
//
//    NSLog(@"%@", self.searchBar);
}

- (void)dealloc
{
//    NSLog(@"%@", self.searchBar);
//    [_searchBar removeFromSuperview];
//    NSLog(@"%@", _searchBar);
}


#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TakeOutModel * takeOutModel = [self.dataArray objectAtIndex:indexPath.row];
    TakeOutViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell createSubview:tableView.bounds activityCount:(int)takeOutModel.activityArray.count];
    cell.takeOutModel = takeOutModel;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TakeOutModel * takeOutMD = [self.dataArray objectAtIndex:indexPath.row];
    return [TakeOutViewCell cellHeightWithTakeOutModel:takeOutMD];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TakeOutModel * takeOutMD = [self.dataArray objectAtIndex:indexPath.row];
    DetailTakeOutViewController * detailTakeOutVC = [[DetailTakeOutViewController alloc] init];
    detailTakeOutVC.takeOutID = takeOutMD.storeId;
    detailTakeOutVC.sendPrice = takeOutMD.sendPrice;
    detailTakeOutVC.outSentMoney = takeOutMD.outSentMoney;
    detailTakeOutVC.storeName = takeOutMD.storeName;
    detailTakeOutVC.navigationItem.title = takeOutMD.storeName;
    [self.navigationController pushViewController:detailTakeOutVC animated:YES];
}

#pragma mark - 搜索

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length) {
        if ([UserLocation shareUserLocation].city) {
            _page = 1;
            NSDictionary * jsonDic = @{
                                       @"Command":@19,
                                       @"KeyWord":searchBar.text,
                                       @"CurPage":@1,
                                       @"CurCount":[NSNumber numberWithInt:COUNT],
                                       @"City":[UserLocation shareUserLocation].city
                                       };
            [self playPostWithDictionary:jsonDic];
            searchBar.text = nil;

        }
    }
    self.searchVC.active = NO;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
}


- (void)pushSearchListView:(NSString *)typeAndQ
{
    NSLog(@"%@", typeAndQ);
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
    NSLog(@"+++%@, error = %@", data, [data objectForKey:@"ErrorMsg"]);
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        NSArray * array = [data objectForKey:@"StoreList"];
        if (_page == 1) {
            self.dataArray = nil;
        }
        for (NSDictionary * dic in array) {
            TakeOutModel * takeOutMD = [[TakeOutModel alloc] initWithDictionary:dic];
            [self.dataArray addObject:takeOutMD];
        }
        [self.tableView reloadData];
    }
}

- (void)failWithError:(NSError *)error
{
    NSLog(@"%@", error);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
