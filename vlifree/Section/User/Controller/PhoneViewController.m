//
//  PhoneViewController.m
//  vlifree
//
//  Created by 仙林 on 15/6/17.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "PhoneViewController.h"

#define TOP_SPACE 30
#define LEFT_SPACE 10
#define VIEW_HEIGHT 40
#define TEXTFILED_HEIGHT 30
#define IMAGE_SIZE 30
#define LABEL_WIDTH 80
#define REGISTER_BUTTON_WIDTH 100

#define WEIXIN_BUTTON_WIDTH 65
#define WEIXIN_BUTTON_HEIGHT 95

//#define VIEW_COLOR [UIColor redColor]
#define VIEW_COLOR [UIColor clearColor]

@interface PhoneViewController ()<HTTPPostDelegate>

@property (nonatomic, copy)RefreshUserInfo refreshBlock;
/**
 *  手机号输入框
 */
@property (nonatomic, strong)UITextField * phoneTF;
/**
 *  验证码输入框
 */
@property (nonatomic, strong)UITextField * verifyTF;
/**
 *  获取验证码按钮
 */
@property (nonatomic, strong)UIButton * getCodeBT;

@property (nonatomic, strong)NSTimer * timer;

//@property (nonatomic, copy)NSString * phone;
@end

@implementation PhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改号码";
    self.view.backgroundColor = [UIColor whiteColor];
    UIView * phoneView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + self.navigationController.navigationBar.bottom, self.view.width - 2 * LEFT_SPACE, VIEW_HEIGHT)];
    phoneView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    phoneView.layer.borderWidth = 0.7;
    phoneView.layer.cornerRadius = 3;
    [self.view addSubview:phoneView];
    
    UIImageView * phoneImage = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, (VIEW_HEIGHT - IMAGE_SIZE) / 2, IMAGE_SIZE, IMAGE_SIZE)];
    phoneImage.image = [UIImage imageNamed:@"phone.png"];
    phoneImage.backgroundColor = VIEW_COLOR;
//    [phoneView addSubview:phoneImage];
    
    UILabel * phoneLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, (VIEW_HEIGHT - IMAGE_SIZE) / 2, LABEL_WIDTH, IMAGE_SIZE)];
    phoneLB.text = @"输入手机号:";
    phoneLB.font = [UIFont systemFontOfSize:15];
    [phoneView addSubview:phoneLB];
    
    self.phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(phoneLB.right + 5, phoneLB.top, phoneView.width - 10 - phoneLB.right, IMAGE_SIZE)];
    _phoneTF.placeholder = @"手机号";
//    _phoneTF.font = [UIFont systemFontOfSize:20];
    _phoneTF.font = [UIFont systemFontOfSize:15];
    _phoneTF.textColor = TEXT_COLOR;
//    _phoneTF.keyboardType = UIKeyboardTypePhonePad;
    _phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [phoneView addSubview:_phoneTF];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(determineModifyPhoneNum:)];
    
    self.verifyTF = [[UITextField alloc] initWithFrame:CGRectMake(phoneLB.left + phoneView.left, phoneView.bottom + 20, 140, 30)];
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
    self.verifyTF.enabled = YES;
    button.enabled = NO;
    button.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    t = 60;
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getVerificattionCodeTime) userInfo:nil repeats:YES];
    [self performSelector:@selector(passSixtySeconds) withObject:nil afterDelay:60];
}

- (void)passSixtySeconds
{
    [_timer invalidate];
    self.timer = nil;
    self.getCodeBT.enabled = YES;
    self.getCodeBT.backgroundColor = MAIN_COLOR;
    [_getCodeBT setTitle:@"重新获取" forState:UIControlStateNormal];
}

/**
 *  确定修改手机号方法
 *
 *  @param barBT 确定按钮
 */
- (void)determineModifyPhoneNum:(UIBarButtonItem *)barBT
{
    [self.phoneTF resignFirstResponder];
    if (self.phoneTF.text.length == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入手机号" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }else if ([self.phoneTF.text isEqualToString:[NSString stringWithFormat:@"%@", [UserInfo shareUserInfo].phoneNumber]])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"这号码和原号码一样" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }else{
        BOOL isPhoneNum = [NSString isTelPhoneNub:_phoneTF.text];
        if (isPhoneNum) {
//            _phone = self.phoneTF.text;
            [self downloadData];
        }
    }
}


#pragma mark - 数据请求
- (void)downloadData
{
    NSDictionary * jsonDic = @{
                               @"Command":@22,
                               @"UserId":[UserInfo shareUserInfo].userId,
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
    NSLog(@"+++%@", data);
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        [UserInfo shareUserInfo].phoneNumber = [NSNumber numberWithLongLong:self.phoneTF.text.longLongValue];
        [self.navigationController popViewControllerAnimated:YES];
        _refreshBlock();
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


- (void)dealloc
{
    NSLog(@"销毁手机修改页面");
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
