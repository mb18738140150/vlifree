//
//  AddressViewController.m
//  vlifree
//
//  Created by 仙林 on 15/5/29.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "AddressViewController.h"
#import "TWButton.h"
#import "AddressModel.h"
#import "AddressViewCell.h"
#import "AddAddressViewController.h"




@interface AddressViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)NSMutableArray * dataArray;

@property (nonatomic, strong)UILabel * addressLB;
@property (nonatomic, strong)UILabel * telLabel;
@property (nonatomic, strong)UIButton * editButton;
@property (nonatomic, strong)UIButton * sentButton;
@property (nonatomic, strong)UITableView * addressTableView;

@property (nonatomic, copy)ReturnAddresssModelBlock returnModelBlock;

@end

@implementation AddressViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
        for (int i = 0; i < 10; i++) {
            AddressModel * model = [[AddressModel alloc] init];
            model.address = [NSString stringWithFormat:@"新西环路科苑小区5号楼20%d", i];
            model.tel = [NSString stringWithFormat:@"137004478%d", arc4random() % 899 + 100];
            [_dataArray addObject:model];
            [self.addressTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            if (i == 0) {
                self.addressLB.text = [NSString stringWithFormat:@"送餐地址:%@",  model.address];
                self.telLabel.text = model.tel;
                CGSize size = [_addressLB sizeThatFits:CGSizeMake(_addressLB.width, CGFLOAT_MAX)];
                CGRect frame = _addressLB.frame;
                frame.size = size;
                _addressLB.frame = frame;
                [self reloadViewsFrame];
            }
        }
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.8];
    
    UIButton * addAddressBT = [UIButton buttonWithType:UIButtonTypeCustom];
    addAddressBT.frame = CGRectMake(0, self.navigationController.navigationBar.bottom, self.view.width, 60);
    [addAddressBT addTarget:self action:@selector(addAddressAndPhoneNumber:) forControlEvents:UIControlEventTouchUpInside];
    addAddressBT.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:addAddressBT];
    addAddressBT.imageView.contentMode = UIViewContentModeLeft;
    addAddressBT.titleLabel.textAlignment = NSTextAlignmentRight;
    [addAddressBT setTitle:@"添加新地址" forState:UIControlStateNormal];
    [addAddressBT setImage:[UIImage imageNamed:@"address.png"] forState:UIControlStateNormal];
    [addAddressBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, addAddressBT.bottom, self.view.width, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [self.view addSubview:lineView];
    UIView * lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, lineView.bottom + 10, self.view.width, 1)];
    lineView2.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
    [self.view addSubview:lineView2];
    
    UIView * addressView = [[UIView alloc] initWithFrame:CGRectMake(0, lineView2.bottom, self.view.width, 60)];
    addressView.tag = 1001;
    addressView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:addressView];
    
    
    UIImageView * aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 25, 25)];
    aImageView.image = [UIImage imageNamed:@"didChange.png"];
    [addressView addSubview:aImageView];
    
    self.addressLB = [[UILabel alloc] initWithFrame:CGRectMake(aImageView.right + 5, 5, addressView.width - aImageView.right - 10, 30)];
    _addressLB.text = @"送餐地址:新西环路1000弄5号903";
    _addressLB.numberOfLines = 0;
    _addressLB.lineBreakMode = NSLineBreakByWordWrapping;
    [addressView addSubview:_addressLB];
    
    self.telLabel = [[UILabel alloc] initWithFrame:CGRectMake(_addressLB.left, _addressLB.bottom, _addressLB.width, _addressLB.height)];
    _telLabel.text = @"13564224954";
    [addressView addSubview:_telLabel];
    
    aImageView.center = CGPointMake(aImageView.centerX, _telLabel.bottom / 2);
    
    UIView * lineView3 = [[UIView alloc] initWithFrame:CGRectMake(10, _telLabel.bottom, self.view.width - 20, 1)];
    lineView3.tag = 1002;
    lineView3.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
    [addressView addSubview:lineView3];
    
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _editButton.frame = CGRectMake(addressView.width - 185, lineView3.bottom + 5, 65, 25);
    [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [_editButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _editButton.layer.borderColor = [UIColor orangeColor].CGColor;
    _editButton.layer.borderWidth = 1.f;
    _editButton.layer.cornerRadius = 3.f;
    [_editButton addTarget:self action:@selector(editAddressAndPhoneNumber:) forControlEvents:UIControlEventTouchUpInside];
    [addressView addSubview:_editButton];
    
    self.sentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sentButton.frame = CGRectMake(addressView.width - 95, lineView3.bottom + 5, 85, 25);
    [_sentButton setTitle:@"送到这里" forState:UIControlStateNormal];
    [_sentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _sentButton.backgroundColor = MAIN_COLOR;
    _sentButton.layer.borderColor = [UIColor orangeColor].CGColor;
    _sentButton.layer.borderWidth = 1.f;
    _sentButton.layer.cornerRadius = 3.f;
    [_sentButton addTarget:self action:@selector(sentAddressAndPhoneNumber:) forControlEvents:UIControlEventTouchUpInside];
    [addressView addSubview:_sentButton];
    
    
    CGRect frame = addressView.frame;
    frame.size.height = _editButton.bottom + 5;
    addressView.frame = frame;
    
    UIView * lineView4 = [[UIView alloc] initWithFrame:CGRectMake(0, addressView.bottom, self.view.width, 1)];
    lineView4.tag = 1003;
    lineView4.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
    [self.view addSubview:lineView4];
    
    UIView * lineView5 = [[UIView alloc] initWithFrame:CGRectMake(0, addressView.bottom + 10, self.view.width, 1)];
    lineView5.tag = 1004;
    lineView5.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
    [self.view addSubview:lineView5];
    
    self.addressTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, lineView5.bottom , self.view.width, self.view.height - lineView5.bottom - self.navigationController.navigationBar.bottom) style:UITableViewStylePlain];
    _addressTableView.dataSource = self;
    _addressTableView.delegate = self;
    [_addressTableView registerClass:[AddressViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_addressTableView];
    
    UIButton * backBT = [UIButton buttonWithType:UIButtonTypeCustom];
    backBT.frame = CGRectMake(0, 0, 15, 20);
    [backBT setBackgroundImage:[UIImage imageNamed:@"back_r.png"] forState:UIControlStateNormal];
    [backBT addTarget:self action:@selector(backLastVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBT];
    // Do any additional setup after loading the view.
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addAddressAndPhoneNumber:(UIButton *)button
{
    NSLog(@"添加地址");
    AddAddressViewController * addVC = [[AddAddressViewController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)editAddressAndPhoneNumber:(UIButton *)button
{
    NSIndexPath * seletedIndexP = [self.addressTableView indexPathForSelectedRow];
    AddAddressViewController * addVC = [[AddAddressViewController alloc] init];
    addVC.addressModel = [self.dataArray objectAtIndex:seletedIndexP.row];
    [self.navigationController pushViewController:addVC animated:YES];
    NSLog(@"编辑");
}

- (void)sentAddressAndPhoneNumber:(UIButton *)button
{
    NSIndexPath * seletedIndexPath = [self.addressTableView indexPathForSelectedRow];
    AddressModel * model = [self.dataArray objectAtIndex:seletedIndexPath.row];
    _returnModelBlock(model);
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"送到这里");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    cell.layoutMargins = UIEdgeInsetsZero;
    [cell createSubview:tableView.bounds];
    AddressModel * addressModel = [self.dataArray objectAtIndex:indexPath.row];
    cell.addressModel = addressModel;
//    cell.textLabel.text = @"23333";
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressModel * address = [self.dataArray objectAtIndex:indexPath.row];
    return [AddressViewCell cellHeightFrome:[NSString stringWithFormat:@"送餐地址:%@", address.address] frame:tableView.bounds];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressModel * address = [self.dataArray objectAtIndex:indexPath.row];
    self.addressLB.text = [NSString stringWithFormat:@"送餐地址:%@", address.address];
    [_addressLB sizeToFit];
    self.telLabel.text = address.tel;
    [self reloadViewsFrame];
}


- (void)reloadViewsFrame
{
    UIView * addressView = [self.view viewWithTag:1001];
    UIView * lineView3 = [self.view viewWithTag:1002];
    UIView * lineView4 = [self.view viewWithTag:1003];
    UIView * lineView5 = [self.view viewWithTag:1004];
    CGRect telFrame = _telLabel.frame;
    telFrame.origin.y = _addressLB.bottom;
    _telLabel.frame = telFrame;
    CGRect line3Frame = lineView3.frame;
    line3Frame.origin.y = _telLabel.bottom;
    lineView3.frame = line3Frame;
    CGRect editFrame = _editButton.frame;
    editFrame.origin.y = lineView3.bottom + 5;
    _editButton.frame = editFrame;
    CGRect sentFrame = _sentButton.frame;
    sentFrame.origin.y = _editButton.top;
    _sentButton.frame = sentFrame;
    CGRect addressFrame = addressView.frame;
    addressFrame.size.height = _editButton.bottom + 5;
    addressView.frame = addressFrame;
    CGRect line4Frame = lineView4.frame;
    line4Frame.origin.y = addressView.bottom;
    lineView4.frame = line4Frame;
    CGRect line5Frame = lineView5.frame;
    line5Frame.origin.y = lineView4.bottom + 10;
    lineView5.frame = line5Frame;
    CGRect tableViewFrame = _addressTableView.frame;
    tableViewFrame.origin.y = lineView5.bottom;
    tableViewFrame.size.height = self.view.height - lineView5.bottom;
    _addressTableView.frame = tableViewFrame;
}


- (void)returnAddressModel:(ReturnAddresssModelBlock)addressBlock
{
    _returnModelBlock = addressBlock;
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
