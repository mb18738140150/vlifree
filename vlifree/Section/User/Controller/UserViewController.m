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

#define CELL_INDENTIFIER @"cell"
#define MODIFY_BUTTON_TAG 1000


@interface UserViewController ()<UITableViewDataSource, UITableViewDelegate>

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
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:18]
                                                                    };
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.logInView = [[LogInView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, self.view.width, self.view.height - self.navigationController.navigationBar.bottom)];
//    _logInView.backgroundColor = [UIColor grayColor];
    [_logInView.logInButton addTarget:self action:@selector(userLogInAction:) forControlEvents:UIControlEventTouchUpInside];
    [_logInView.registerButton addTarget:self action:@selector(registerUser:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_logInView];
    
    self.userTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, self.view.width, self.view.height - self.navigationController.navigationBar.bottom - self.tabBarController.tabBar.height) style:UITableViewStylePlain];
    _userTableView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    _userTableView.dataSource = self;
    _userTableView.delegate = self;
    [_userTableView registerClass:[UserViewCell class] forCellReuseIdentifier:CELL_INDENTIFIER];
    _userTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_userTableView];
    [self fiexdData];
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

- (void)userLogInAction:(UIButton *)button
{
    _userTableView.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
    [UIView commitAnimations];
    _logInView.hidden = YES;
    self.navigationItem.title = @"会员中心";
    [_logInView textFiledResignFirstResponder];
}

- (void)registerUser:(UIButton *)button
{
    RegisterViewController * registerVC = [[RegisterViewController alloc] init];
    registerVC.hidesBottomBarWhenPushed= YES;
    [self.navigationController pushViewController:registerVC animated:YES];
}


- (void)exitLogInAciton:(UIButton *)button
{
    _logInView.hidden = NO;
    _userTableView.hidden = YES;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:_userTableView cache:YES];
    [UIView commitAnimations];
    self.navigationItem.title = @"会员中心";
    NSLog(@"退出登录");
    self.title = @"登陆";
}

- (void)fiexdData
{
    NSArray * titleAry = @[@"可爱小萌娃", @"密码", @"手机号:1374****566", @"外卖订单", @"酒店订单", @"客服电话:400-6492-229"];
    for (int i = 0; i < titleAry.count; i++) {
        UserModel * model = [[UserModel alloc] init];
        model.title = [titleAry objectAtIndex:i];
        model.iconStr = [NSString stringWithFormat:@"user_%d", i];
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:@"修改"];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.5 alpha:1] range:NSMakeRange(0, string.length)];
        model.buttonStr = [string copy];
        
        if (i > 2) {
            NSString * str = @"0";
            NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:str];
            [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, attriStr.length)];
            model.buttonStr = [attriStr copy];
        }
        if (i == 5) {
            model.buttonStr = nil;
        }
        [self.dataArray addObject:model];
    }
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
    if (indexPath.row == 2) {
        cell.modifyBT .hidden = YES;
    }
    cell.userModel = userModel;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UserViewCell cellHeight];
}



- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


- (void)modifyAction:(UIButton *)button
{
    switch (button.tag) {
        case MODIFY_BUTTON_TAG:
        {
            NSLog(@"名称");
            ModifyNameViewController * nameVC = [[ModifyNameViewController alloc] init];
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
        }
            break;
        case MODIFY_BUTTON_TAG + 3:
        {
             NSLog(@"外卖订单");
            UserTOOrderViewController * TOOrderVC = [[UserTOOrderViewController alloc] init];
            TOOrderVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:TOOrderVC animated:YES];
        }
            break;
        case MODIFY_BUTTON_TAG + 4:
        {
             NSLog(@"酒店订单");
            GSOrderViewController * gsOrderVC = [[GSOrderViewController alloc] init];
            gsOrderVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:gsOrderVC animated:YES];
        }
            break;
        default:
            break;
    }
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
