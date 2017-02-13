//
//  NumberCell.m
//  SalesManager
//
//  Created by Kris on 13-12-13.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "ReportNumberCell.h"
#import "YformFileds.h"

@implementation ReportNumberCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setFormFiled:(YformFileds *)formFiled
{
    _formFiled = formFiled;
    
    self.label.text = [NSString stringWithFormat:@"%@:",formFiled.formName];
    //[self.label sizeToFit];
    
    CGRect frame = self.label.frame;
    self.label.frame = CGRectMake(15, 10, frame.size.width, 40);
    NSLog(@"%@",NSStringFromCGRect(frame));
    
    self.unitLabel.text = [NSString stringWithFormat:@"%@",formFiled.formUnit];
    [self.unitLabel sizeToFit];
    
    frame = self.unitLabel.frame;
    self.unitLabel.frame = CGRectMake(10+300-frame.size.width-5, 10, frame.size.width, 40);
    NSLog(@"%@",NSStringFromCGRect(frame));
    
    self.textField.frame = CGRectMake(10+5+self.label.frame.size.width+5, 10, 300-20-self.label.frame.size.width-self.unitLabel.frame.size.width, 40);
    
    if(formFiled.need)
    {
        self.textField.placeholder = @"必填 ";
    }
}

//- (void)setSelected:(BOOL)selected
//{
//	[super setSelected:selected];
//	if (selected)
//    {
//		[self.textField becomeFirstResponder];
//	}
//}



- (void)awakeFromNib
{
    self.bggImgV.backgroundColor = [UIColor whiteColor];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:selected animated:animated];
	if (selected)
    {
		[self.textField becomeFirstResponder];
	}
}

- (UIView *)inputAccessoryView
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
		return nil;
	} else {
		if (!inputAccessoryView)
        {
			inputAccessoryView = [[UIToolbar alloc] init];
			inputAccessoryView.barStyle = UIBarStyleDefault;
			inputAccessoryView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
			[inputAccessoryView sizeToFit];
			CGRect frame = inputAccessoryView.frame;
			frame.size.height = 44.0f;
			inputAccessoryView.frame = frame;
			
			UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
			UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
			
			NSArray *array = [NSArray arrayWithObjects:flexibleSpaceLeft, doneBtn, nil];
			[inputAccessoryView setItems:array];
		}
		return inputAccessoryView;
	}
}

- (void)done:(id)sender
{
	_isDone = YES;
    
    if (_delegate && [_delegate respondsToSelector:@selector(reportNumberCell:didEndEditingWithDictionary:)])
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.textField.text, self.formFiled.formReferName, nil];
		[_delegate reportNumberCell:self didEndEditingWithDictionary:dic];
	}
}

#pragma mark - textfield delegate

//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//	[self.textField resignFirstResponder];
//	return YES;
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (_delegate && [_delegate respondsToSelector:@selector(reportNumberCell:didEndEditingWithDictionary:)])
    {
        _isDone = NO;
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.textField.text, self.formFiled.formReferName, nil];
		[_delegate reportNumberCell:self didEndEditingWithDictionary:dic];
	}
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	if (_delegate && [_delegate respondsToSelector:@selector(reportNumberCell:didEndEditingWithDictionary:)])
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.textField.text, self.formFiled.formReferName, nil];
		[_delegate reportNumberCell:self didEndEditingWithDictionary:dic];
	}
//	UITableView *tableView;
//    if ([self.superview class] != [UITableView class])
//    {
//        tableView = (UITableView *)self.superview.superview;
//    }
//    else
//    {
//        tableView = (UITableView *)self.superview;
//    }
//    
//	[tableView deselectRowAtIndexPath:[tableView indexPathForCell:self] animated:YES];
}

@end
