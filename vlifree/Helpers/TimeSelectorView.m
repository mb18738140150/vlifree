//
//  TimeSelectorView.m
//  vlifree
//
//  Created by 仙林 on 16/1/11.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "TimeSelectorView.h"
#import "UIViewAdditions.h"
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
@interface TimeSelectorView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong)UIPickerView * pickView;
@property (nonatomic, strong)NSMutableArray * hoursArray;
@property (nonatomic, strong)NSMutableArray * minArray;
@property (nonatomic, copy)SelectComplate selectBlock;

@property (nonatomic, strong)UILabel * timeLabel;

@end

@implementation TimeSelectorView

- (NSMutableArray *)hoursArray
{
    if (!_hoursArray) {
        self.hoursArray = [NSMutableArray array];
    }
    return _hoursArray;
}
- (NSMutableArray *)minArray
{
    if (!_minArray) {
        self.minArray = [NSMutableArray array];
    }
    return _minArray;
}

- (instancetype)initWithDateArray:(NSArray *)array
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:.3 alpha:.4];
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
        [self addGestureRecognizer:tapGesture];
        
        for (int i = 0; i < 60; i++) {
            
            NSString * str = nil;
            if (i < 10) {
                str = [NSString stringWithFormat:@"0%d", i];
            }else
            {
                str = [NSString stringWithFormat:@"%d", i];
            }
            [self.minArray addObject:str];
            
        }
        self.hoursArray = [array mutableCopy];
        
        UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(30, (self.height - 300) / 2, self.width - 60, 300)];
        bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bottomView];
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, bottomView.width, 40)];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.text = @"请选择时间";
        _timeLabel.textColor = RGBCOLOR(21, 112, 182);
        _timeLabel.backgroundColor = [UIColor whiteColor];
        [bottomView addSubview:_timeLabel];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, _timeLabel.bottom, bottomView.width, 1)];
        lineView.backgroundColor = RGBCOLOR(21, 112, 182);
        [bottomView addSubview:lineView];
        
        
        self.pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, _timeLabel.bottom + 1, _timeLabel.width, 150)];
        _pickView.backgroundColor = [UIColor whiteColor];
        _pickView.delegate = self;
        _pickView.dataSource = self;
        [bottomView addSubview:_pickView];
        
        UIButton * cancelBT = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBT.frame = CGRectMake(0, _pickView.bottom, bottomView.width / 3, 50);
        cancelBT.backgroundColor = [UIColor whiteColor];
        [cancelBT setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelBT addTarget:self action:@selector(cancelChangeDate:) forControlEvents:UIControlEventTouchUpInside];
        cancelBT.layer.borderWidth = .5;
        cancelBT.layer.borderColor = [UIColor colorWithWhite:.9 alpha:1].CGColor;
        [bottomView addSubview:cancelBT];
        
        UIButton * nowBT = [UIButton buttonWithType:UIButtonTypeCustom];
        nowBT.frame = CGRectMake(cancelBT.right, _pickView.bottom, bottomView.width / 3, 50);
        nowBT.backgroundColor = [UIColor whiteColor];
        [nowBT setTitle:@"现在" forState:UIControlStateNormal];
        [nowBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [nowBT addTarget:self action:@selector(nowDate:) forControlEvents:UIControlEventTouchUpInside];
        nowBT.layer.borderWidth = .5;
        nowBT.layer.borderColor = [UIColor colorWithWhite:.9 alpha:1].CGColor;
        [bottomView addSubview:nowBT];
        
        
        UIButton * finishBT = [UIButton buttonWithType:UIButtonTypeCustom];
        finishBT.frame = CGRectMake(nowBT.right, _pickView.bottom, bottomView.width / 3, 50);
        finishBT.backgroundColor = [UIColor whiteColor];
        [finishBT setTitle:@"确定" forState:UIControlStateNormal];
        [finishBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [finishBT addTarget:self action:@selector(finishChangeDate:) forControlEvents:UIControlEventTouchUpInside];
        finishBT.layer.borderWidth = .5;
        finishBT.layer.borderColor = [UIColor colorWithWhite:.9 alpha:1].CGColor;
        [bottomView addSubview:finishBT];
        
        bottomView.height = finishBT.bottom;
//        bottomView.top = self.height - bottomView.height;
        
        [self showNowTime];
        
    }
    return self;
}

- (void)showNowTime
{
    NSDate * nowDate = [NSDate date];
    NSDateFormatter * fomatter = [[NSDateFormatter alloc]init];
    fomatter.dateFormat = @"hh:mm";
    
    nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSString * nowStr = [fomatter stringFromDate:nowDate];
    
    NSString * hourStr = [nowStr substringToIndex:2];
    
    NSString * minStr = [nowStr substringFromIndex:3];
    
    for (int i = 0; i < self.hoursArray.count; i++) {
        NSString * str = [self.hoursArray objectAtIndex:i];
        if ([hourStr isEqualToString:str]) {
            [self.pickView selectRow:i inComponent:0 animated:YES];
            break;
        }
    }
    
    for (int i = 0; i < self.minArray.count; i++) {
        NSString * str = [self.minArray objectAtIndex:i];
        if ([minStr isEqualToString:str]) {
            [self.pickView selectRow:i inComponent:1 animated:YES];
            break;
        }
    }
    _timeLabel.text = [NSString stringWithFormat:@"%@:%@", [self.hoursArray objectAtIndex:[_pickView selectedRowInComponent:0]], [self.minArray objectAtIndex:[_pickView selectedRowInComponent:1]]];
}

- (void)finishChangeDate:(UIButton *)button
{
    NSString * date = [self.hoursArray objectAtIndex:[_pickView selectedRowInComponent:0]];
    date = [NSString stringWithFormat:@"%@:%@", [self.hoursArray objectAtIndex:[_pickView selectedRowInComponent:0]], [self.minArray objectAtIndex:[_pickView selectedRowInComponent:1]]];
    _selectBlock(date);
    [self removeFromSuperview];
}

- (void)nowDate:(UIButton *)button
{
    NSDate * nowDate = [NSDate date];
    NSDateFormatter * fomatter = [[NSDateFormatter alloc]init];
    fomatter.dateFormat = @"hh:mm";
    
    nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSString * nowStr = [fomatter stringFromDate:nowDate];
    
    NSString * hourStr = [nowStr substringToIndex:2];
    
    NSString * minStr = [nowStr substringFromIndex:3];
    
    for (int i = 0; i < self.hoursArray.count; i++) {
        NSString * str = [self.hoursArray objectAtIndex:i];
        if ([hourStr isEqualToString:str]) {
            [self.pickView selectRow:i inComponent:0 animated:YES];
            break;
        }
    }
    
    for (int i = 0; i < self.minArray.count; i++) {
        NSString * str = [self.minArray objectAtIndex:i];
        if ([minStr isEqualToString:str]) {
            [self.pickView selectRow:i inComponent:1 animated:YES];
            break;
        }
    }
    _timeLabel.text = [NSString stringWithFormat:@"%@:%@", [self.hoursArray objectAtIndex:[_pickView selectedRowInComponent:0]], [self.minArray objectAtIndex:[_pickView selectedRowInComponent:1]]];
    
    NSString * date = [self.hoursArray objectAtIndex:[_pickView selectedRowInComponent:0]];
    date = [NSString stringWithFormat:@"%@:%@", [self.hoursArray objectAtIndex:[_pickView selectedRowInComponent:0]], [self.minArray objectAtIndex:[_pickView selectedRowInComponent:1]]];
    _selectBlock(date);
    [self removeFromSuperview];
}


- (void)cancelChangeDate:(UIButton *)button
{
    [self removeFromSuperview];
}

- (void)tapView
{
    [self removeFromSuperview];
}

- (void)finishSelectComplete:(SelectComplate)selectBlock
{
    _selectBlock = selectBlock;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 1) {
        return self.minArray.count;
    }
    return self.hoursArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [NSString stringWithFormat:@"%@时", [self.hoursArray objectAtIndex:row]];
    }else
    {
        return [NSString stringWithFormat:@"%@分", [self.minArray objectAtIndex:row]];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _timeLabel.text = [NSString stringWithFormat:@"%@:%@", [self.hoursArray objectAtIndex:[_pickView selectedRowInComponent:0]], [self.minArray objectAtIndex:[_pickView selectedRowInComponent:1]]];
}

- (void)dealloc
{
    NSLog(@"销毁");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
