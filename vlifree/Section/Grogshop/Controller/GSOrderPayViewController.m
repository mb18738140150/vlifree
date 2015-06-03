//
//  GSOrderPayViewController.m
//  vlifree
//
//  Created by 仙林 on 15/6/1.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "GSOrderPayViewController.h"
#import "PayTypeView.h"

#define LEFT_SPACE 15
#define TOP_SPACE 5
#define LABEL_HEIGHT 30


@interface GSOrderPayViewController ()<UITextFieldDelegate>

@property (nonatomic, strong)PayTypeView * weixinView;
@property (nonatomic, strong)PayTypeView * baiduView;
@property (nonatomic, strong)UIDatePicker * datePicker;
@property (nonatomic, strong)UIView * pickerView;

@property (nonatomic, strong)UIButton * dateButton;

@property (nonatomic, strong)UITextField * personTF;
@property (nonatomic, strong)UITextField * telTF;
@property (nonatomic, strong)UITextField * requireTF;
@property (nonatomic, strong)NSDate * ruzhuDate;
@property (nonatomic, strong)NSDate * lidianDate;

@property (nonatomic, strong)UILabel * daysLB;
//@property (nonatomic, strong)UILabel 

@end

@implementation GSOrderPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
//    NSLog(@"%d", self.navigationController.navigationBar.translucent);
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.7];
    [self.view addSubview:scrollView];
    
    UILabel * aLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, scrollView.width, 30)];
    aLabel.text = @"订单确认后不可取消，该订单不可变更。如未入住扣除全部房费";
    aLabel.font = [UIFont systemFontOfSize:11];
    aLabel.textAlignment = NSTextAlignmentCenter;
    aLabel.textColor = [UIColor colorWithRed:227 / 255.0 green:185 / 255.0 blue:16 / 255.0 alpha:1];
    aLabel.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    aLabel.layer.borderWidth = 1.5;
    aLabel.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:254 / 255.0 blue:242 / 255.0 alpha:1];
    [scrollView addSubview:aLabel];
    
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, aLabel.bottom, scrollView.width, 100)];
    view1.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:view1];
    
    UILabel * roomLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, view1.width - 2 * LEFT_SPACE, LABEL_HEIGHT)];
    roomLB.text = @"房型: 总统套房130平米";
    [view1 addSubview:roomLB];
    
    UILabel * ruzhuLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, roomLB.bottom + TOP_SPACE, 80, LABEL_HEIGHT)];
//    dateLB.font = [UIFont systemFontOfSize:14];
    ruzhuLB.text = @"入住时间:";
    [view1 addSubview:ruzhuLB];
    
    UIButton * ruzhuBT = [UIButton buttonWithType:UIButtonTypeCustom];
    ruzhuBT.frame = CGRectMake(ruzhuLB.right, ruzhuLB.top, view1.width - 2 * LEFT_SPACE - ruzhuLB.width, ruzhuLB.height);
    ruzhuBT.tag = 10001;
    ruzhuBT.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:0.9].CGColor;
    ruzhuBT.layer.borderWidth = 0.5;
    [ruzhuBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    ruzhuBT.backgroundColor = [UIColor redColor];
    [ruzhuBT addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:ruzhuBT];
    
    
    UILabel * lidianLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, ruzhuLB.bottom + TOP_SPACE, 80, LABEL_HEIGHT)];
    //    dateLB.font = [UIFont systemFontOfSize:14];
    lidianLB.text = @"离店时间:";
    [view1 addSubview:lidianLB];
    
    UIButton * lidianBT = [UIButton buttonWithType:UIButtonTypeCustom];
    lidianBT.frame = CGRectMake(lidianLB.right, lidianLB.top, view1.width - 2 * LEFT_SPACE - lidianLB.width, lidianLB.height);
    lidianBT.tag = 10002;
    lidianBT.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:0.9].CGColor;
    lidianBT.layer.borderWidth = 0.5;
    [lidianBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    ruzhuBT.backgroundColor = [UIColor redColor];
    [lidianBT addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:lidianBT];
    
    self.daysLB = [[UILabel alloc] initWithFrame:CGRectMake(lidianLB.left, lidianLB.bottom, lidianLB.width * 2, lidianLB.height)];
    _daysLB.text = @"住店时长: ";
    [view1 addSubview:_daysLB];
    view1.height = _daysLB.bottom + TOP_SPACE;
    
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(0, view1.height - 1, view1.width, 1)];
    line1.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view1 addSubview:line1];
    
    
    UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(0, view1.bottom + 10, scrollView.width, 140)];
    view2.backgroundColor = [UIColor  whiteColor];
    [scrollView addSubview:view2];
    
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view2.width, 1)];
    line2.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view2 addSubview:line2];
    
    UILabel * datumLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, 0, view2.width - 2 * LEFT_SPACE, 40)];
    datumLB.text = @"入住资料";
    [view2 addSubview:datumLB];
    
    UIView * line3 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, datumLB.bottom, view2.width - 2 * LEFT_SPACE, 1)];
    line3.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view2 addSubview:line3];
    
    UILabel * personLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, line3.bottom + TOP_SPACE, 80, LABEL_HEIGHT)];
    personLB.text = @"入住人名:";
    [view2 addSubview:personLB];
    
    self.personTF = [[UITextField alloc] initWithFrame:CGRectMake(personLB.right, personLB.top, view2.width - LEFT_SPACE - personLB.right, personLB.height)];
    _personTF.borderStyle = UITextBorderStyleRoundedRect;
    _personTF.delegate = self;
    [view2 addSubview:_personTF];
    
    
    UILabel * telLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, personLB.bottom + TOP_SPACE, personLB.width, LABEL_HEIGHT)];
    telLB.text = @"手机号码:";
    [view2 addSubview:telLB];
    
    self.telTF = [[UITextField alloc] initWithFrame:CGRectMake(telLB.right, telLB.top, view2.width - LEFT_SPACE - telLB.right, telLB.height)];
    _telTF.borderStyle = UITextBorderStyleRoundedRect;
    _telTF.delegate = self;
    [view2 addSubview:_telTF];
    
    UILabel * requireLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, telLB.bottom + TOP_SPACE, 80, LABEL_HEIGHT)];
    requireLB.text = @"特殊需求:";
//    requireLB.numberOfLines = 0;
//    requireLB.lineBreakMode = NSLineBreakByWordWrapping;
//    [requireLB sizeToFit];
    [view2 addSubview:requireLB];
    
    
    self.requireTF = [[UITextField alloc] initWithFrame:CGRectMake(requireLB.right, requireLB.top, view2.width - LEFT_SPACE - requireLB.right, requireLB.height)];
    _requireTF.borderStyle = UITextBorderStyleRoundedRect;
    _requireTF.delegate = self;
    [view2 addSubview:_requireTF];
    
    view2.height = requireLB.bottom + TOP_SPACE * 2;
    UIView * line4 = [[UIView alloc] initWithFrame:CGRectMake(0, view2.height - 1, view2.width, 1)];
    line4.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view2 addSubview:line4];
    
    UIView * view3 = [[UIView alloc] initWithFrame:CGRectMake(0, view2.bottom + 10, scrollView.width, 100)];
    view3.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:view3];
    
    UIView * line5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view2.width, 1)];
    line5.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view3 addSubview:line5];
    
    UILabel * payLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, 0, view3.width - 2 * LEFT_SPACE, 40)];
    payLabel.text = @"支付方式";
    [view3 addSubview:payLabel];
    
    
    UIView * line6 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, payLabel.bottom, view3.width - 2 * LEFT_SPACE, 1)];
    line6.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view3 addSubview:line6];
    
    
    
    self.weixinView = [[PayTypeView alloc] initWithFrame:CGRectMake(0, line6.bottom + TOP_SPACE, view3.width, 40)];
    _weixinView.changeButton.selected = YES;
    [_weixinView.changeButton addTarget:self action:@selector(changePayType:) forControlEvents:UIControlEventTouchUpInside];
    _weixinView.iconView.image = [UIImage imageNamed:@"weixinzhifu.png"];
    _weixinView.titleLabel.text = @"微信支付";
    [view3 addSubview:_weixinView];
    
    self.baiduView = [[PayTypeView alloc] initWithFrame:CGRectMake(0, _weixinView.bottom + TOP_SPACE, view3.width, 40)];
    _baiduView.iconView.image = [UIImage imageNamed:@"baiduzhifu.png"];
    _baiduView.titleLabel.text = @"百度钱包";
    [_baiduView.changeButton addTarget:self action:@selector(changePayType:) forControlEvents:UIControlEventTouchUpInside];
    [view3 addSubview:_baiduView];
    
    view3.height = _baiduView.bottom + TOP_SPACE;
    
    UIView * line7 = [[UIView alloc] initWithFrame:CGRectMake(0, view3.height - 1, view3.width, 1)];
    line7.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view3 addSubview:line7];
    
    UILabel * priceLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, view3.bottom + 20, scrollView.width - 3 * LEFT_SPACE - 80, 35)];
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:@"支付金额¥321"];
    [string addAttributes:@{NSForegroundColorAttributeName : [UIColor redColor], NSFontAttributeName : [UIFont systemFontOfSize:24]} range:NSMakeRange(4, string.length - 4)];
    [string addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20]} range:NSMakeRange(0, 4)];
    priceLB.attributedText = [string copy];
    [scrollView addSubview:priceLB];
    
    UIButton * payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    payButton.frame = CGRectMake(priceLB.right + LEFT_SPACE, priceLB.top, 80, priceLB.height);
    [payButton setTitle:@"马上支付" forState:UIControlStateNormal];
    [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payButton.backgroundColor = MAIN_COLOR;
    [scrollView addSubview:payButton];
    scrollView.contentSize = CGSizeMake(scrollView.width, payButton.bottom + 20);
    
    UIButton * backBT = [UIButton buttonWithType:UIButtonTypeCustom];
    backBT.frame = CGRectMake(0, 0, 15, 20);
    [backBT setBackgroundImage:[UIImage imageNamed:@"back_r.png"] forState:UIControlStateNormal];
    [backBT addTarget:self action:@selector(backLastVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBT];
    
    [self createDatePickerView];
    // Do any additional setup after loading the view.
}

- (void)createDatePickerView
{
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 200, 150)];
    _datePicker.backgroundColor = [UIColor whiteColor];
    [_datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT+8"]];
//    [_datePicker setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
//    [_datePicker setDate:[NSDate date] animated:YES];
    [_datePicker setMinimumDate:[NSDate date]];
    [_datePicker setDatePickerMode:UIDatePickerModeDate];
    
    self.pickerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _pickerView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    [_pickerView addSubview:_datePicker];
    _datePicker.center = _pickerView.center;

    UIButton * dateBT = [UIButton buttonWithType:UIButtonTypeCustom];
    dateBT.frame = CGRectMake(0, 5, 80, 30);
    dateBT.centerX = _datePicker.centerX;
    [dateBT setTitle:@"确定" forState:UIControlStateNormal];
    [dateBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dateBT addTarget:self action:@selector(getDate:) forControlEvents:UIControlEventTouchUpInside];
    dateBT.backgroundColor = MAIN_COLOR;
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, _datePicker.bottom, _pickerView.width, 40)];
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:dateBT];
    [_pickerView addSubview:view];
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changePayType:(UIButton *)button
{
    if (button.selected) {
        return;
    }
    if ([button isEqual:self.weixinView.changeButton]) {
        self.baiduView.changeButton.selected = NO;
        //        NSLog(@"微信");
    }else if ([button isEqual:self.baiduView.changeButton])
    {
        self.weixinView.changeButton.selected = NO;
        //        NSLog(@"百度");
    }
    button.selected = !button.selected;
}


- (void)changeDate:(UIButton *)button
{
    self.dateButton = button;
    if (button.tag == 10002 & self.ruzhuDate != nil) {
        self.datePicker.minimumDate = self.ruzhuDate;
        self.datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:1000000000];
    }else if (button.tag == 10002 & self.ruzhuDate == nil)
    {
        self.datePicker.minimumDate = [NSDate date];
        self.datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:1000000000];
    }else if (button.tag == 10001 & self.lidianDate != nil)
    {
        self.datePicker.minimumDate = [NSDate date];
        self.datePicker.maximumDate = self.lidianDate;
    }else if (button.tag == 10001 & self.lidianDate == nil)
    {
        self.datePicker.minimumDate = [NSDate date];
        self.datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:1000000000];
    }
    [self.view.window addSubview:_pickerView];
    NSLog(@"时间");
}


- (void)getDate:(UIButton *)button
{
    if (self.dateButton.tag == 10001) {
        self.ruzhuDate = self.datePicker.date;
    }else if (self.dateButton.tag == 10002)
    {
        self.lidianDate = self.datePicker.date;
    }
    if (self.ruzhuDate != nil & self.lidianDate != nil) {
        NSInteger days = [self calculateAgeFromDate:self.ruzhuDate toDate:self.lidianDate];
        self.daysLB.text = [NSString stringWithFormat:@"%@共%ld天", self.daysLB.text, days];
    }
    [self.pickerView removeFromSuperview];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:_datePicker.date];
    [self.dateButton setTitle:dateString forState:UIControlStateNormal];
//    NSLog(@"%@", _dateButton);
//    _dateButton.backgroundColor = [UIColor redColor];
    NSLog(@"%@", dateString);
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.personTF resignFirstResponder];
    [self.telTF resignFirstResponder];
    [self.requireTF resignFirstResponder];
    return YES;
}


- (NSInteger)calculateAgeFromDate:(NSDate *)date1 toDate:(NSDate *)date2{
    
    NSCalendar *userCalendar = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitHour;
    NSDateComponents *components = [userCalendar components:unitFlags fromDate:date1 toDate:date2 options:0];
    NSInteger hours = [components hour];
    
    NSInteger day = 1;
    NSLog(@"////%ld", (long)hours);
    if (hours > 22) {
        day = hours / 24 + 2;
        NSLog(@"---%ld", (long)day);
    }
    return day;
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
