//
//  ReportAddressBoxViewController.m
//  SalesManager
//
//  Created by Kris on 14-3-24.
//  Copyright (c) 2014年 tianjing. All rights reserved.
//

#import "ReportAddressBoxViewController.h"
#import "CustomIOS7AlertView.h"
#import "ILBarButtonItem.h"
#import "InformationReportCreatViewController.h"


@interface ReportAddressBoxViewController ()

@end

@implementation ReportAddressBoxViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //创建弹框
    self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self];
    self.tempString = @"";
    
    self.navigationItem.leftBarButtonItem = [TOOL getBarButtonItemWithTitle:@"返回" target:self selector:@selector(backToTop:)];
    
    /* Right bar button item */
    ILBarButtonItem *rightBtn = [ILBarButtonItem barItemWithTitle:@"完成"
                                                       themeColor:[UIColor whiteColor]
                                                           target:self
                                                           action:@selector(done)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    self.areaLabel.text = [NSString stringWithFormat:@"%@:",_formFiled.formName];
    NSLog(@"%@",_formFiled);
    
    if (self.detailTextView.text.length == 0) {
        self.placeholderLabel.hidden = NO;
    } else {
        self.placeholderLabel.hidden = YES;
    }
    
    self.areaView.layer.cornerRadius = 5;
    self.areaView.layer.borderColor = [UIColor colorWithRed:139/255. green:139/255. blue:139/255. alpha:1].CGColor;
    self.areaView.layer.borderWidth = 0.5;
    
    self.detailTextView.layer.cornerRadius = 5;
    self.detailTextView.layer.borderColor = [UIColor colorWithRed:139/255. green:139/255. blue:139/255. alpha:1].CGColor;
    self.detailTextView.layer.borderWidth = 0.5;
}

- (void)backToTop:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)done
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.tempString, self.formFiled.formReferName, nil];
    
    [self.addressBoxCell.informationReportCreatViewController reportAddressBoxCell:self.addressBoxCell didEndEditingWithDictionary:dic];
    
    if (self.detailTextView.text.length == 0)
    {
        self.addressBoxCell.areaTextField.text = [NSString stringWithFormat:@"%@%@%@", _locatePicker.locate.state, _locatePicker.locate.city, _locatePicker.locate.district];
    }else{
        self.addressBoxCell.areaTextField.text = [NSString stringWithFormat:@"%@%@%@%@", _locatePicker.locate.state, _locatePicker.locate.city, _locatePicker.locate.district, self.detailTextView.text];
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)resignKeyBoardInView:(UIView *)view
{
    for (UIView *v in view.subviews) {
        if ([v.subviews count] > 0) {
            [self resignKeyBoardInView:v];
        }
        
        if ([v isKindOfClass:[UITextView class]] || [v isKindOfClass:[UITextField class]]) {
            [v resignFirstResponder];
        }
    }
}

- (IBAction)select:(id)sender
{
    [self resignKeyBoardInView:self.view];
    
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initWithParentView:self.view];
    [alertView setContainerView:self.locatePicker];
    [alertView show];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0)
    {
        self.placeholderLabel.hidden = NO;
    } else {
        self.placeholderLabel.hidden = YES;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (_locatePicker.locate.district.length == 0)
    {
        if (self.detailTextView.text.length == 0)
        {
            self.tempString = [NSString stringWithFormat:@"%@,%@", _locatePicker.locate.state, _locatePicker.locate.city];
        }else{
            self.tempString = [NSString stringWithFormat:@"%@,%@,%@", _locatePicker.locate.state, _locatePicker.locate.city, self.detailTextView.text];
        }
        
    }else{
        if (self.detailTextView.text.length == 0)
        {
            self.tempString = [NSString stringWithFormat:@"%@,%@,%@", _locatePicker.locate.state, _locatePicker.locate.city, _locatePicker.locate.district];
        }else{
            self.tempString = [NSString stringWithFormat:@"%@,%@,%@,%@", _locatePicker.locate.state, _locatePicker.locate.city, _locatePicker.locate.district, self.detailTextView.text];
        }
    }
}


#pragma mark - HZAreaPickerDelegate

- (void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    self.areaTextField.text = [NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district];
    
    if (picker.locate.district.length == 0)
    {
        if (self.detailTextView.text.length == 0)
        {
            self.tempString = [NSString stringWithFormat:@"%@,%@", picker.locate.state, picker.locate.city];
        }else{
            self.tempString = [NSString stringWithFormat:@"%@,%@,%@", picker.locate.state, picker.locate.city, self.detailTextView.text];
        }
        
    }else{
        if (self.detailTextView.text.length == 0)
        {
            self.tempString = [NSString stringWithFormat:@"%@,%@,%@", picker.locate.state, picker.locate.city, picker.locate.district];
        }else{
            self.tempString = [NSString stringWithFormat:@"%@,%@,%@,%@", picker.locate.state, picker.locate.city, picker.locate.district, self.detailTextView.text];
        }
    }
}



@end
