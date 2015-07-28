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




@interface AddressViewController ()<UITableViewDataSource, UITableViewDelegate, HTTPPostDelegate>

@property (nonatomic, strong)NSMutableArray * dataArray;

@property (nonatomic, strong)UILabel * addressLB;
@property (nonatomic, strong)UILabel * telLabel;
@property (nonatomic, strong)UIButton * editButton;
@property (nonatomic, strong)UIButton * sentButton;
@property (nonatomic, strong)UIButton * deleteButton;
@property (nonatomic, strong)UITableView * addressTableView;

@property (nonatomic, copy)ReturnAddresssModelBlock returnModelBlock;

@end

@implementation AddressViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
        /*
        for (int i = 0; i < 10; i++) {
            AddressModel * model = [[AddressModel alloc] init];
            model.address = [NSString stringWithFormat:@"新西环路科苑小区5号楼20%d", i];
            model.phoneNumber = [NSString stringWithFormat:@"137004478%d", arc4random() % 899 + 100];
            [_dataArray addObject:model];
            [self.addressTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            if (i == 0) {
                self.addressLB.text = [NSString stringWithFormat:@"送餐地址:%@",  model.address];
                self.telLabel.text = model.phoneNumber;
                CGSize size = [_addressLB sizeThatFits:CGSizeMake(_addressLB.width, CGFLOAT_MAX)];
                CGRect frame = _addressLB.frame;
                frame.size = size;
                _addressLB.frame = frame;
                [self reloadViewsFrame];
            }
        }
         */
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    self.navigationItem.title = @"管理地址";
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
//    lineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    lineView.backgroundColor = LINE_COLOR;
    [self.view addSubview:lineView];
    
    
    UIView * addressView = [[UIView alloc] initWithFrame:CGRectMake(0, addAddressBT.bottom + 5, self.view.width, 60)];
    addressView.tag = 1001;
    addressView.backgroundColor = [UIColor whiteColor];
    addressView.hidden= YES;
    [self.view addSubview:addressView];
    UIView * lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 1)];
    lineView2.backgroundColor = LINE_COLOR;
    [addressView addSubview:lineView2];
    
    UIImageView * aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 25, 25)];
    aImageView.image = [UIImage imageNamed:@"didChange.png"];
    [addressView addSubview:aImageView];
    
    self.addressLB = [[UILabel alloc] initWithFrame:CGRectMake(aImageView.right + 5, 5, addressView.width - aImageView.right - 10, 30)];
    _addressLB.text = @"送餐地址:新西环路1000弄5号903";
    _addressLB.textColor = TEXT_COLOR;
    _addressLB.numberOfLines = 0;
    _addressLB.lineBreakMode = NSLineBreakByWordWrapping;
    [addressView addSubview:_addressLB];
    
    self.telLabel = [[UILabel alloc] initWithFrame:CGRectMake(_addressLB.left, _addressLB.bottom, _addressLB.width, _addressLB.height)];
    _telLabel.text = @"13564224954";
    _telLabel.textColor = TEXT_COLOR;
    [addressView addSubview:_telLabel];
    
    aImageView.center = CGPointMake(aImageView.centerX, _telLabel.bottom / 2);
    
    UIView * lineView3 = [[UIView alloc] initWithFrame:CGRectMake(10, _telLabel.bottom, self.view.width - 20, 1)];
    lineView3.tag = 1002;
    lineView3.backgroundColor = LINE_COLOR;
    [addressView addSubview:lineView3];
    
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _editButton.frame = CGRectMake(addressView.width - 180, lineView3.bottom + 5, 65, 25);
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
    
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteButton.frame = CGRectMake(addressView.width - 300, _sentButton.top, 60, 25);
    [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _deleteButton.layer.borderColor = [UIColor orangeColor].CGColor;
    _deleteButton.layer.borderWidth = 1.f;
    _deleteButton.layer.cornerRadius = 3.f;
    [_deleteButton addTarget:self action:@selector(deleteAddressAndPhoneNumber:) forControlEvents:UIControlEventTouchUpInside];
    [addressView addSubview:_deleteButton];
    
    CGRect frame = addressView.frame;
    frame.size.height = _editButton.bottom + 5;
    addressView.frame = frame;
    
    UIView * lineView4 = [[UIView alloc] initWithFrame:CGRectMake(0, addressView.height - 1, self.view.width, 1)];
    lineView4.tag = 1003;
    lineView4.backgroundColor = LINE_COLOR;
    [addressView addSubview:lineView4];
    
    UIView * lineView5 = [[UIView alloc] initWithFrame:CGRectMake(0, addressView.bottom + 5, self.view.width, 1)];
    lineView5.tag = 1004;
    lineView5.backgroundColor = LINE_COLOR;
    [self.view addSubview:lineView5];
    
    self.addressTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, lineView5.bottom , self.view.width, self.view.height - lineView5.bottom - self.navigationController.navigationBar.bottom) style:UITableViewStylePlain];
    _addressTableView.dataSource = self;
    _addressTableView.delegate = self;
    [_addressTableView registerClass:[AddressViewCell class] forCellReuseIdentifier:@"cell"];
    _addressTableView.separatorColor = LINE_COLOR;
    _addressTableView.tableFooterView = [[UIView alloc] init];
    _addressTableView.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1];
    [self.view addSubview:_addressTableView];
    
    [self downloadData];
    
    
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
    AddressViewController * addressVC = self;
    [addVC successBack:^{
        [addressVC downloadData];
    }];
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)editAddressAndPhoneNumber:(UIButton *)button
{
    NSIndexPath * seletedIndexP = [self.addressTableView indexPathForSelectedRow];
    AddressViewController * addressVC = self;
    AddAddressViewController * addVC = [[AddAddressViewController alloc] init];
    addVC.addressModel = [self.dataArray objectAtIndex:seletedIndexP.row];
    [addVC successBack:^{
        [addressVC downloadData];
    }];
    [self.navigationController pushViewController:addVC animated:YES];
    NSLog(@"编辑");
}

- (void)deleteAddressAndPhoneNumber:(UIButton *)button
{
    NSIndexPath * seletedIndexPath = [self.addressTableView indexPathForSelectedRow];
    AddressModel * model = [self.dataArray objectAtIndex:seletedIndexPath.row];
    NSDictionary * jsonDic = @{
                               @"Command":@30,
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"AddressId":model.addressId
                               };
    [self playPostWithDictionary:jsonDic];
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


#pragma mark - 数据请求
- (void)downloadData
{
    
    NSDictionary * jsonDic = @{
                               @"Command":@15,
                               @"UserId":[UserInfo shareUserInfo].userId
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
    //    NSLog(@"%@", jsonStr);
    NSString * str = [NSString stringWithFormat:@"%@231618", jsonStr];
    NSString * md5Str = [str md5];
    NSString * urlString = [NSString stringWithFormat:@"%@%@", POST_URL, md5Str];
    
    HTTPPost * httpPost = [HTTPPost shareHTTPPost];
    [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    httpPost.delegate = self;
}

- (void)refresh:(id)data
{
    NSLog(@"+++%@, %@", data, [data objectForKey:@"ErrorMsg"]);
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        if ([[data objectForKey:@"Command"] isEqualToNumber:@10015]) {
            NSArray * array = [data objectForKey:@"AddressList"];
            _dataArray = nil;
            int seletNum = 0;
            for (int i = 0; i < array.count; i++) {
                NSDictionary * dic = [array objectAtIndex:i];
                AddressModel * addressMD = [[AddressModel alloc] initWithDictionary:dic];
                if ([addressMD.isDefault isEqualToNumber:@1]) {
                    seletNum = i;
                }
                [self.dataArray addObject:addressMD];
            }
            UIView * addressView = [self.view viewWithTag:1001];
            if (self.dataArray.count > 0) {
                addressView.hidden = NO;
            }else
            {
                addressView.hidden = YES;
            }
            [self.addressTableView reloadData];
            if (self.dataArray.count == 0) {
                self.addressLB.text = @"送餐地址:";
                CGSize size = [_addressLB sizeThatFits:CGSizeMake(_addressLB.width, MAXFLOAT)];
                _addressLB.height = size.height;
                self.telLabel.text = @"";
            }else
            {
                AddressModel * addressMD = [self.dataArray objectAtIndex:seletNum];
                self.addressLB.text = [NSString stringWithFormat:@"送餐地址:%@", addressMD.address];
                CGSize size = [_addressLB sizeThatFits:CGSizeMake(_addressLB.width, MAXFLOAT)];
                _addressLB.height = size.height;
                self.telLabel.text = addressMD.phoneNumber;
                [self reloadViewsFrame];
                [self.addressTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:seletNum inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            }
        }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10030])
        {
            [self downloadData];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"删除成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
        }
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
    }
//    [SVProgressHUD dismiss];
}

- (void)failWithError:(NSError *)error
{
//    [SVProgressHUD dismiss];
    NSLog(@"%@", error);
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
    CGSize size = [_addressLB sizeThatFits:CGSizeMake(_addressLB.width, MAXFLOAT)];
    _addressLB.height = size.height;
    self.telLabel.text = address.phoneNumber;
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
    _deleteButton.top = _editButton.top;
    CGRect addressFrame = addressView.frame;
    addressFrame.size.height = _editButton.bottom + 5;
    addressView.frame = addressFrame;
    CGRect line4Frame = lineView4.frame;
    line4Frame.origin.y = addressView.height - 1;
    lineView4.frame = line4Frame;
    CGRect line5Frame = lineView5.frame;
    line5Frame.origin.y = addressView.bottom + 5;
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
