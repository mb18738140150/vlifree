//
//  WXLoginViewController.m
//  vlifree
//
//  Created by 仙林 on 15/6/18.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "WXLoginViewController.h"

#define TOP_SPACE 30
#define LEFT_SPACE 10
#define VIEW_HEIGHT 40
#define TEXTFILED_HEIGHT 30
#define IMAGE_SIZE 30
#define REGISTER_BUTTON_WIDTH 100

#define WEIXIN_BUTTON_WIDTH 65
#define WEIXIN_BUTTON_HEIGHT 95

//#define VIEW_COLOR [UIColor redColor]
#define VIEW_COLOR [UIColor clearColor]

@interface WXLoginViewController ()<HTTPPostDelegate>


@property (nonatomic, strong)UITextField * phoneTF;
@property (nonatomic, strong)UITextField * passwordTF;
@property (nonatomic, strong)UIButton * logInButton;
@property (nonatomic, copy)RefreshUserInfo refreshBlock;
/**
 *  验证码输入框
 */
@property (nonatomic, strong)UITextField * verifyTF;
/**
 *  获取验证码按钮
 */
@property (nonatomic, strong)UIButton * getCodeBT;

/**
 *  验证码MD5值
 */
@property (nonatomic, copy)NSString * verifyCode;

@property (nonatomic, strong)NSTimer * timer;
/**
 *  获取验证码的时间
 */
@property (nonatomic, strong)NSDate * codeDate;


@property (nonatomic, strong)JGProgressHUD * hud;

@end

@implementation WXLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"绑定";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = MAIN_COLOR;
    
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
    _phoneTF.font = [UIFont systemFontOfSize:20];
    _phoneTF.textColor = TEXT_COLOR;
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
    _passwordTF.font = [UIFont systemFontOfSize:20];
    _passwordTF.textColor = TEXT_COLOR;
    _passwordTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _passwordTF.secureTextEntry = YES;
    _passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [passwordView addSubview:_passwordTF];
    
    
    
    self.verifyTF = [[UITextField alloc] initWithFrame:CGRectMake(phoneImage.left + phoneView.left, passwordView.bottom + 20, 140, 30)];
    _verifyTF.placeholder = @"请输入验证码";
    _verifyTF.textColor = TEXT_COLOR;
    _verifyTF.borderStyle = UITextBorderStyleRoundedRect;
    _verifyTF.enabled = NO;
    [self.view addSubview:_verifyTF];
    
    self.getCodeBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _getCodeBT.frame = CGRectMake(_verifyTF.right + 10, _verifyTF.top, 100, _verifyTF.height);
    [_getCodeBT setTitle:@"获取验证码" forState:UIControlStateNormal];
    _getCodeBT.backgroundColor = MAIN_COLOR;
    _getCodeBT.layer.cornerRadius = 3;
    [_getCodeBT addTarget:self action:@selector(getVerificationCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_getCodeBT];
    
    
    self.logInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _logInButton.frame = CGRectMake(LEFT_SPACE, _verifyTF.bottom + TOP_SPACE, passwordView.width, VIEW_HEIGHT);
    _logInButton.backgroundColor = MAIN_COLOR;
    [_logInButton setTitle:@"确认" forState:UIControlStateNormal];
    [_logInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_logInButton addTarget:self action:@selector(bindingPhonePassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_logInButton];
    
    self.hud = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleLight];
    
    UIButton * backBT = [UIButton buttonWithType:UIButtonTypeCustom];
    backBT.frame = CGRectMake(0, 0, 15, 20);
    [backBT setBackgroundImage:[UIImage imageNamed:@"back_w.png"] forState:UIControlStateNormal];
    [backBT addTarget:self action:@selector(backLoginVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBT];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)dealloc
{
    NSLog(@"销毁微信绑定页面");
    self.verifyCode = nil;
    self.verifyTF = nil;
    self.getCodeBT = nil;
    self.logInButton = nil;
    self.phoneTF = nil;
    self.timer = nil;
    self.passwordTF = nil;
}

- (void)backLoginVC:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

static int t = 60;
/**
 *  点击获取验证码后, 每秒走一次的方法
 */
- (void)getVerificattionCodeTime
{
    NSLog(@"timer");
    t--;
    [self.getCodeBT setTitle:[NSString stringWithFormat:@"%d", t] forState:UIControlStateDisabled];
}

/**
 *  获取验证码
 *
 *  @param button 获取验证码按钮
 */
- (void)getVerificationCode:(UIButton *)button
{
    NSLog(@"1111");
    [self.phoneTF resignFirstResponder];
    if (self.phoneTF.text.length == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入手机号" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }else{
        BOOL isPhoneNum = [NSString isTelPhoneNub:_phoneTF.text];
        if (isPhoneNum) {
            NSDictionary * jsonDic = @{
                                       @"Command":@42,
                                       @"PhoneNumber":self.phoneTF.text,
                                       @"Type":@2
                                       };
            [self playPostWithDictionary:jsonDic];
            self.verifyTF.enabled = YES;
            button.enabled = NO;
            button.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
            t = 60;
            self.timer = nil;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getVerificattionCodeTime) userInfo:nil repeats:YES];
            [self performSelector:@selector(passSixtySeconds) withObject:nil afterDelay:60];
        }
    }
}

- (void)passSixtySeconds
{
    [_timer invalidate];
    self.timer = nil;
    self.getCodeBT.enabled = YES;
    self.getCodeBT.backgroundColor = MAIN_COLOR;
    [_getCodeBT setTitle:@"重新获取" forState:UIControlStateNormal];
}

- (void)bindingPhonePassword:(UIButton *)button
{
    NSLog(@"0404004");
    if (_phoneTF.text.length == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入手机号" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }else if (_passwordTF.text.length == 0)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入密码" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }else if (_verifyTF.text.length == 0)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入验证码" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }else
    {
        BOOL isPhoneNum = [NSString isTelPhoneNub:_phoneTF.text];
        if (isPhoneNum) {
            if ([self.verifyCode isEqualToString:[[[NSString stringWithFormat:@"%@231618", _verifyTF.text] md5] uppercaseString]]) {
                NSTimeInterval seconds = [[NSDate date] timeIntervalSinceDate:self.codeDate];
                if (seconds > 120) {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码超时" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                    [alert show];
                    [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
                }else
                {
                    [self downloadData];
                }
            }else
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"验证码错误" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
            }
        }
    }
}


#pragma mark - 数据请求
- (void)downloadData
{
    [self.hud showInView:self.view animated:YES];
    NSDictionary * jsonDic = @{
                               @"Command":@8,
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"LoginType":@2,
                               @"Password":self.passwordTF.text,
                               @"PhoneNumber":self.phoneTF.text
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
    [self.hud dismiss];
    NSLog(@"+++%@", data);
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        if ([[data objectForKey:@"Command"] isEqualToNumber:@10008]) {
            [[UserInfo shareUserInfo] setValuesForKeysWithDictionary:[data objectForKey:@"UserInfo"]];
            [[NSUserDefaults standardUserDefaults] setValue:[UserInfo shareUserInfo].phoneNumber forKey:@"account"];
            [[NSUserDefaults standardUserDefaults] setValue:[UserInfo shareUserInfo].password forKey:@"password"];
            [[NSUserDefaults standardUserDefaults] setValue:@YES forKey:@"haveLogIn"];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            _refreshBlock();
        }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10042])
        {
            self.verifyCode = [data objectForKey:@"Verifynode"];
            self.codeDate = [NSDate date];
        }
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"失败" message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }
//    [SVProgressHUD dismiss];
}

- (void)failWithError:(NSError *)error
{
//    [SVProgressHUD dismiss];
    NSLog(@"%@", error);
}


- (void)refreshUserInfo:(RefreshUserInfo)refreshBlock
{
    _refreshBlock = refreshBlock;
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
