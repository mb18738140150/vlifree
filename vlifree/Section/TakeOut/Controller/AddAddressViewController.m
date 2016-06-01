//
//  AddAddressViewController.m
//  vlifree
//
//  Created by 仙林 on 15/5/29.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "AddAddressViewController.h"
#import "AddressModel.h"

@interface AddAddressViewController ()<UITextFieldDelegate, HTTPPostDelegate, UITextViewDelegate>

/**
 *  联系人输入框
 */
@property (nonatomic, strong)UITextField * receiveNameTF;

/**
 *  地址输入框
 */
@property (nonatomic, strong)UITextView * addressTF;
/**
 *  电话输入框
 */
@property (nonatomic, strong)UITextField * telTF;
/**
 *  回调block
 */
@property (nonatomic, copy)RefreshDataBlock refreshBlock;

@end


@implementation AddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.navigationItem.title = @"添加地址";
    
    UIView * receiveNameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 60)];
    receiveNameView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:receiveNameView];
    
    self.receiveNameTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 15, receiveNameView.width - 60, 30)];
    _receiveNameTF.delegate = self;
    _receiveNameTF.placeholder = @"收货人姓名";
    [_receiveNameTF setValue:[UIColor colorWithWhite:0.7 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    _receiveNameTF.textColor = TEXT_COLOR;
    [receiveNameView addSubview:_receiveNameTF];
    
    UIView * telView = [[UIView alloc] initWithFrame:CGRectMake(0, receiveNameView.bottom + 1, self.view.width, 60)];
    telView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:telView];
    
    self.telTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 15, telView.width - 60, 30)];
    _telTF.delegate = self;
    _telTF.placeholder = @"手机号";
    [_telTF setValue:[UIColor colorWithWhite:0.7 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    _telTF.textColor = TEXT_COLOR;
    [telView addSubview:_telTF];
    
    UIView * addressView = [[UIView alloc] initWithFrame:CGRectMake(0, telView.bottom + 1, self.view.width, 60)];
    addressView.backgroundColor = [UIColor whiteColor];
    addressView.tag = 10000;
    [self.view addSubview:addressView];
    
    self.addressTF = [[UITextView alloc] initWithFrame:CGRectMake(18, 15, addressView.width - 60, 30)];
    _addressTF.delegate = self;
    _addressTF.text = @"地址";
    _addressTF.font = [UIFont systemFontOfSize:17];
//    _addressTF.backgroundColor = [UIColor redColor];
    _addressTF.textColor = [UIColor colorWithWhite:0.7 alpha:1];
    [addressView addSubview:_addressTF];
    
    
    if (_addressModel) {
        _addressTF.textColor = [UIColor blackColor];
        _receiveNameTF.text = _addressModel.receiveName;
        _addressTF.text = _addressModel.address;
        _telTF.text = _addressModel.phoneNumber;
    }
    
    NSString * str = _addressTF.text;
    CGRect  addRect = [str boundingRectWithSize:CGSizeMake(self.addressTF.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    if (addRect.size.height > 30) {
        UIView * addressView = [self.view viewWithTag:10000];
        self.addressTF.frame = CGRectMake(20, 15, addressView.width - 60, addRect.size.height + 10);
        addressView.height = 30 + addRect.size.height;
    }
    
    UIButton * backBT = [UIButton buttonWithType:UIButtonTypeCustom];
    backBT.frame = CGRectMake(0, 0, 15, 20);
    [backBT setBackgroundImage:[UIImage imageNamed:@"back_black.png"] forState:UIControlStateNormal];
    [backBT addTarget:self action:@selector(backLastVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBT];
    
    NSDictionary * attribute = @{NSForegroundColorAttributeName:[UIColor colorWithWhite:.2 alpha:1]};
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(saveAddressAndPhone:)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:attribute forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveAddressAndPhone:(UIBarButtonItem *)button
{
    [self.addressTF resignFirstResponder];
    [self.telTF resignFirstResponder];
    if (self.receiveNameTF.text.length == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入收货人姓名" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }else if (self.addressTF.text.length == 0)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入地址" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }else if (self.telTF.text.length == 0)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入电话号码" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }
    else
    {
        BOOL isPhoneNum = [NSString isTelPhoneNub:self.telTF.text];
        if (isPhoneNum) {
            if (self.addressModel != nil) {
                [self downloadDataEditAddress];
            }else
            {
                [self downloadDataAddAddress];
            }
        }
    }
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.addressTF resignFirstResponder];
    [self.telTF resignFirstResponder];
}
#pragma mark - textFiled Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"地址"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length != 0) {
        textView.textColor = TEXT_COLOR;
        CGRect  addRect = [textView.text boundingRectWithSize:CGSizeMake(self.addressTF.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
        
        if (addRect.size.height > 30) {
            UIView * addressView = [self.view viewWithTag:10000];
            self.addressTF.frame = CGRectMake(20, 15, self.view.width - 60, addRect.size.height + 10);
            addressView.height = 30 + addRect.size.height;
        }else
        {
            UIView * addressView = [self.view viewWithTag:10000];
            self.addressTF.height = 30;
            addressView.height = 60;
        }
    }else
    {
        textView.text = @"地址";
        textView.textColor = [UIColor colorWithWhite:0.7 alpha:1];
        UIView * addressView = [self.view viewWithTag:10000];
        self.addressTF.height = 30;
        addressView.height = 60;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.telTF resignFirstResponder];
    return YES;
}


#pragma mark - 数据请求
- (void)downloadDataAddAddress
{
    NSDictionary * jsonDic = @{
                               @"Command":@16,
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Address":self.addressTF.text,
                               @"PhoneNumber":self.telTF.text,
                               @"UserName":self.receiveNameTF.text
                               };
    [self playPostWithDictionary:jsonDic];
}

- (void)downloadDataEditAddress
{
    NSDictionary * jsonDic = @{
                               @"Command":@17,
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Address":self.addressTF.text,
                               @"PhoneNumber":self.telTF.text,
                               @"UserName":self.receiveNameTF.text,
                               @"AddressId":self.addressModel.addressId
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
    NSLog(@"+++%@, %@", data, [data objectForKey:@"ErrorMsg"]);
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        _refreshBlock();
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
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


- (void)successBack:(RefreshDataBlock)refreshBlock
{
    _refreshBlock = refreshBlock;
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
