//
//  SearchViewController.m
//  vlifree
//
//  Created by 仙林 on 15/5/19.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "SearchViewController.h"
#import "ResultViewController.h"

@interface SearchViewController ()<UISearchBarDelegate, UISearchResultsUpdating>


@property (nonatomic, strong)UISearchBar * searchBar;

@property (nonatomic, strong)UISearchController * searchVC;
@property (nonatomic, strong)ResultViewController * resultVC;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 5, 150, 30)];
//    self.searchBar.center = CGPointMake(self.view.centerX, self.searchBar.centerY);
//    self.searchBar.placeholder = @"关键字";
//    [self.navigationController.navigationBar addSubview:self.searchBar];
    UIView * searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    searchView.backgroundColor = [UIColor greenColor];
    
    self.resultVC = [[ResultViewController alloc] init];
    _resultVC.action = @selector(pushSearchListView:);
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
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    UIButton * backBT = [UIButton buttonWithType:UIButtonTypeCustom];
    backBT.frame = CGRectMake(0, 0, 15, 20);
    [backBT setBackgroundImage:[UIImage imageNamed:@"back_w.png"] forState:UIControlStateNormal];
    [backBT addTarget:self action:@selector(backLastVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBT];
    

    // Do any additional setup after loading the view.
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
//    self.searchBar.hidden = NO;
//    NSLog(@"--%@", self.searchBar);
}

- (void)viewWillDisappear:(BOOL)animated
{
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    return cell;
}


#pragma mark - 搜索
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
}


- (void)pushSearchListView:(NSString *)typeAndQ
{
    
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
