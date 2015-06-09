
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


#define SECTION_TABLEVIEW_CELL @"SECTIONCELL"
#define MENUS_TABLEVIEW_CELL @"MENUSCELL"

#define SUBTRACT_BUTTON_TAG 1000
#define ADD_BUTTON_TAG 2000

#define SHOPPINGCARVIEW_HEIGHT 55


@interface DetailTakeOutViewController ()<UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong)UITableView * sectionTableView;
@property (nonatomic, strong)UITableView * menusTableView;

@property (nonatomic, strong)ShoppingCartView * shoppingCarView;
@property (nonatomic, strong)ShoppingDetailsCarView * shoppingCarDetailsView;


@end

@implementation DetailTakeOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.sectionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 80, self.view.height - SHOPPINGCARVIEW_HEIGHT) style:UITableViewStylePlain];
    _sectionTableView.dataSource = self;
    _sectionTableView.delegate = self;
//    [_sectionTableView set]
    [_sectionTableView registerClass:[ClassesViewCell class] forCellReuseIdentifier:SECTION_TABLEVIEW_CELL];
    [_sectionTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
//    _sectionTableView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_sectionTableView];
    
    self.menusTableView = [[UITableView alloc] initWithFrame:CGRectMake(_sectionTableView.right, self.navigationController.navigationBar.bottom, self.view.width - 80, self.view.height - self.navigationController.navigationBar.bottom - SHOPPINGCARVIEW_HEIGHT) style:UITableViewStylePlain];
    _menusTableView.delegate = self;
    _menusTableView.dataSource = self;
    [_menusTableView registerClass:[MenusViewCell class] forCellReuseIdentifier:MENUS_TABLEVIEW_CELL];
//    _menusTableView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_menusTableView];
    
    
    self.shoppingCarView = [[ShoppingCartView alloc] initWithFrame:CGRectMake(0, _menusTableView.bottom, self.view.width, SHOPPINGCARVIEW_HEIGHT)];
    [_shoppingCarView.shoppingCarBT addTarget:self action:@selector(addShoppingCarDetailsViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [_shoppingCarView.changeButton addTarget:self action:@selector(confirmMenusAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shoppingCarView];
//    _shoppingCarView.backgroundColor = [UIColor greenColor];
    
    UIButton * backBT = [UIButton buttonWithType:UIButtonTypeCustom];
    backBT.frame = CGRectMake(0, 0, 15, 20);
    [backBT setBackgroundImage:[UIImage imageNamed:@"back_r.png"] forState:UIControlStateNormal];
    [backBT addTarget:self action:@selector(backLastVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBT];
//    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    // Do any additional setup after loading the view.
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)confirmMenusAction:(UIButton *)button
{
    TakeOutOrderViewController * orderVC = [[TakeOutOrderViewController alloc] init];
    [self.navigationController pushViewController:orderVC animated:YES];
}


- (void)addShoppingCarDetailsViewAction:(UIButton *)button
{
    self.shoppingCarDetailsView = [[ShoppingDetailsCarView alloc] initWithFrame:[[UIScreen mainScreen] bounds] withMneusArray:[@[@"", @"", @""] mutableCopy]];
    [self.view.window addSubview:_shoppingCarDetailsView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_sectionTableView]) {
        return 10;
    }
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_sectionTableView]) {
        ClassesViewCell * sectionCell = [tableView dequeueReusableCellWithIdentifier:SECTION_TABLEVIEW_CELL];
        [sectionCell createSubviewWithFrame:tableView.bounds];
        sectionCell.title = @"注释,饮料,小吃,赠品,我耳机哦荣";
        return sectionCell;
    }
    
    MenusViewCell * cell = [tableView dequeueReusableCellWithIdentifier:MENUS_TABLEVIEW_CELL];
    [cell createSubview:tableView.bounds];
    [cell.subtractBT addTarget:self action:@selector(subtractMenuCount:) forControlEvents:UIControlEventTouchUpInside];
    cell.subtractBT.tag = indexPath.row + SUBTRACT_BUTTON_TAG;
    [cell.addButton addTarget:self action:@selector(addMenuCount:) forControlEvents:UIControlEventTouchUpInside];
    cell.addButton.tag = indexPath.row + ADD_BUTTON_TAG;
//    cell.textLabel.text = @"menu";
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_sectionTableView]) {
        return [ClassesViewCell cellHeightWithString:@"注释,饮料,小吃,赠品,我耳机哦荣" frame:tableView.bounds];
    }
    return [MenusViewCell cellHeight];
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
    MenusViewCell * cell = (MenusViewCell *)[self.menusTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag - SUBTRACT_BUTTON_TAG inSection:0]];
    NSInteger count = [self.shoppingCarView.countLabel.text integerValue];
    cell.countLabel.text = [NSString stringWithFormat:@"%ld", [cell.countLabel.text integerValue] - 1];
    if ([cell.countLabel.text integerValue] == 0) {
        button.hidden = YES;
    }
    if (count == 1) {
        self.shoppingCarView.changeButton.enabled = NO;
    }
    self.shoppingCarView.countLabel.text = [NSString stringWithFormat:@"%ld", [self.shoppingCarView.countLabel.text integerValue] - 1];
}

- (void)addMenuCount:(UIButton *)button
{
    MenusViewCell * cell = (MenusViewCell *)[self.menusTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag - ADD_BUTTON_TAG inSection:0]];
    NSInteger count = [cell.countLabel.text integerValue];
    cell.countLabel.text = [NSString stringWithFormat:@"%ld", count + 1];
    cell.subtractBT.hidden = NO;
    self.shoppingCarView.countLabel.text = [NSString stringWithFormat:@"%ld", [self.shoppingCarView.countLabel.text integerValue] + 1];
    self.shoppingCarView.changeButton.enabled = YES;
    
    CGRect cellFrame = [self.menusTableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag - ADD_BUTTON_TAG inSection:0]];
    CGRect btFrame = button.frame;
    btFrame.origin.x = btFrame.origin.x + self.menusTableView.left;
    btFrame.origin.y = cellFrame.origin.y - self.menusTableView.contentOffset.y + button.origin.y + self.menusTableView.top;
    [self countLBAnimateWithFromeFrame:btFrame];
    
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






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
