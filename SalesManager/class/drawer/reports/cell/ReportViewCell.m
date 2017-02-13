//
//  ViewCell.m
//  SalesManager
//
//  Created by Kris on 13-12-13.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "ReportViewCell.h"
#import "YformFileds.h"

@implementation ReportViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//    if (selected) {
//        [self.textView resignFirstResponder];
//    }
//}

- (void)awakeFromNib
{
    self.bggImgV.backgroundColor = [UIColor whiteColor];


}

- (void)setFormFiled:(YformFileds *)formFiled
{
    _formFiled = formFiled;
    
    self.label.text = [NSString stringWithFormat:@"%@:",formFiled.formName];
    
    if(formFiled.need)
    {
        NSLog(@"%@",self.textView.text);
        if (self.textView.text.length == 0) {
            self.placeholder.placeholder = @"必填";
        }
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
    
    if (_delegate && [_delegate respondsToSelector:@selector(reportViewCell:didEndEditingWithDictionary:)] )
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.textView.text, self.formFiled.formReferName, nil];
		[_delegate reportViewCell:self didEndEditingWithDictionary:dic];
    }
}

#pragma mark - UITextViewDelegate

//- (BOOL)textViewShouldEndEditing:(UITextView *)textView
//{
//    [textView resignFirstResponder];
//    return YES;
//}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        [self.placeholder setHidden:NO];
    }else{
        [self.placeholder setHidden:YES];
        _isDone = NO;
        if (_delegate && [_delegate respondsToSelector:@selector(reportViewCell:didEndEditingWithDictionary:)])
        {
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.textView.text, self.formFiled.formReferName, nil];
            [_delegate reportViewCell:self didEndEditingWithDictionary:dic];
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (_delegate && [_delegate respondsToSelector:@selector(reportViewCell:didEndEditingWithDictionary:)])
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.textView.text, self.formFiled.formReferName, nil];
		[_delegate reportViewCell:self didEndEditingWithDictionary:dic];
	}
//
//	UITableView *tableView;
//    if ([self.superview class] != [UITableView class])
//    {
//        tableView = (UITableView *)self.superview.superview;
//    }
//    else
//    {
//        tableView = (UITableView *)self.superview;
//    }
//	[tableView deselectRowAtIndexPath:[tableView indexPathForCell:self] animated:YES];
}

@end
