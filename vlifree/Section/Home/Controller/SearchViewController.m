//
//  SearchViewController.m
//  vlifree
//
//  Created by 仙林 on 15/5/19.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()


@property (nonatomic, strong)UISearchBar * searchBar;


@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 5, 150, 30)];
    self.searchBar.center = CGPointMake(self.view.centerX, self.searchBar.centerY);
    self.searchBar.placeholder = @"关键字";
    [self.navigationController.navigationBar addSubview:self.searchBar];
    
    
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated
{
    self.searchBar.hidden = NO;
//    NSLog(@"--%@", self.searchBar);
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.searchBar.hidden = YES;
    [self.searchBar resignFirstResponder];

    NSLog(@"%@", self.searchBar);
}

- (void)dealloc
{
    NSLog(@"%@", self.searchBar);
    [_searchBar removeFromSuperview];
    NSLog(@"%@", _searchBar);
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
