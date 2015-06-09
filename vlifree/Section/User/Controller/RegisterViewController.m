//
//  RegisterViewController.m
//  vlifree
//
//  Created by 仙林 on 15/6/1.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "RegisterViewController.h"

#define TOP_SPACE 30
#define LEFT_SPACE 10
#define VIEW_HEIGHT 40
#define TEXTFILED_HEIGHT 30
#define IMAGE_SIZE 30
#define VIEW_COLOR [UIColor clearColor]

@interface RegisterViewController ()<HTTPPostDelegate>

@property (nonatomic, strong)UITextField * phoneTF;
@property (nonatomic, strong)UITextField * passwordTF;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView * phoneView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + self.navigationController.navigationBar.bottom, self.view.width - 2 * LEFT_SPACE, VIEW_HEIGHT)];
    phoneView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    phoneView.layer.borderWidth = 0.7;
    phoneView.layer.cornerRadius = 3;
    [self.view addSubview:phoneView];
    
    UIImageView * phoneImage = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, (VIEW_HEIGHT - IMAGE_SIZE) / 2, IMAGE_SIZE, IMAGE_SIZE)];
    phoneImage.image = [UIImage imageNamed:@"phone.png"];
    phoneImage.backgroundColor = VIEW_COLOR;
    [phoneView addSubview:phoneImage];
    self.phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(phoneImage.right + 5, phoneImage.top, phoneView.width - 10 - phoneImage.right, IMAGE_SIZE)];
    _phoneTF.placeholder = @"手机号";
    _phoneTF.font = [UIFont systemFontOfSize:22];
    _phoneTF.keyboardType = UIKeyboardTypePhonePad;
    _phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [phoneView addSubview:_phoneTF];
    
    UIView * passwordView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + phoneView.bottom, self.view.width - 2 * LEFT_SPACE, VIEW_HEIGHT)];
    passwordView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    passwordView.layer.borderWidth = 0.7;
    passwordView.layer.cornerRadius = 3;
    [self.view addSubview:passwordView];
    
    UIImageView * passwordImage = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, (VIEW_HEIGHT - IMAGE_SIZE) / 2, IMAGE_SIZE, IMAGE_SIZE)];
    passwordImage.image = [UIImage imageNamed:@"password.png"];
    passwordImage.backgroundColor = VIEW_COLOR;
    [passwordView addSubview:passwordImage];
    self.passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(passwordImage.right + 5, passwordImage.top, passwordView.width - 10 - passwordImage.right, IMAGE_SIZE)];
    _passwordTF.placeholder = @"密码";
    _passwordTF.font = [UIFont systemFontOfSize:22];
    _passwordTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _passwordTF.secureTextEntry = YES;
    _passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [passwordView addSubview:_passwordTF];
    
    
    UIButton * registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.frame = CGRectMake(LEFT_SPACE, passwordView.bottom + TOP_SPACE, passwordView.width, VIEW_HEIGHT);
    registerButton.backgroundColor = MAIN_COLOR;
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:registerButton];
    
    UIButton * backBT = [UIButton buttonWithType:UIButtonTypeCustom];
    backBT.frame = CGRectMake(0, 0, 15, 20);
    [backBT setBackgroundImage:[UIImage imageNamed:@"back_w.png"] forState:UIControlStateNormal];
    [backBT addTarget:self action:@selector(backLastVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBT];
    
    self.navigationItem.title = @"注册";
    // Do any additional setup after loading the view.
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.passwordTF resignFirstResponder];
    [self.phoneTF resignFirstResponder];
}


- (void)registerAction:(UIButton *)button
{
    [self.passwordTF resignFirstResponder];
    [self.phoneTF resignFirstResponder];
    if (self.phoneTF.text.length == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入电话号码" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelectorOnMainThread:@selector(dismissAnimated:) withObject:nil waitUntilDone:YES];
    }else if (self.passwordTF.text.length == 0)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入密码" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelectorOnMainThread:@selector(dismissAnimated:) withObject:nil waitUntilDone:YES];
    }else if (self.passwordTF.text.length != 0 & self.phoneTF.text.length != 0)
    {
        [self registerUserToServers];
    }
}

- (void)registerUserToServers
{
    NSDictionary * jsonDic = @{
                               @"Command":@8,
                               @"Password":self.passwordTF.text,
                               @"PhoneNumber":self.phoneTF.text,
                               @"LoginType":@1
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
    NSLog(@"+++%@", data);
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        
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
