//
//  AddAddressViewController.m
//  vlifree
//
//  Created by 仙林 on 15/5/29.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "AddAddressViewController.h"
#import "AddressModel.h"

@interface AddAddressViewController ()<UITextFieldDelegate>

@property (nonatomic, strong)UITextField * addressTF;
@property (nonatomic, strong)UITextField * telTF;


@end


@implementation AddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.8];
    
    UIView * addressView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, self.view.width, 60)];
    addressView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:addressView];
    
    self.addressTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 15, addressView.width - 60, 30)];
    _addressTF.delegate = self;
    _addressTF.placeholder = @"地址";
    [addressView addSubview:_addressTF];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, addressView.bottom, self.view.width, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [self.view addSubview:lineView];
    
    UIView * telView = [[UIView alloc] initWithFrame:CGRectMake(0, lineView.bottom, self.view.width, 60)];
    telView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:telView];
    
    self.telTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 15, addressView.width - 60, 30)];
    _telTF.delegate = self;
    _telTF.placeholder = @"手机号";
    [telView addSubview:_telTF];
    
    
    UIButton * saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(15, telView.bottom + 20, self.view.width - 30, 45);
    saveButton.backgroundColor = MAIN_COLOR;
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveAddressAndPhone:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    
    if (_addressModel) {
        _addressTF.text = _addressModel.address;
        _telTF.text = _addressModel.tel;
    }
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveAddressAndPhone:(UIButton *)button
{
    [self.addressTF resignFirstResponder];
    [self.telTF resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.addressTF resignFirstResponder];
    [self.telTF resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.addressTF resignFirstResponder];
    [self.telTF resignFirstResponder];
    return YES;
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
