//
//  SPPaymentCardTextFieldCell.h
//

#import <UIKit/UIKit.h>

#import "SPPaymentCardTextField.h"
#import "SPTheme.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPPaymentCardTextFieldCell : UITableViewCell

@property (nonatomic, weak, readonly) SPPaymentCardTextField *paymentField;
@property (nonatomic, copy) SPTheme *theme;
@property (nonatomic, weak) UIView *inputAccessoryView;

- (BOOL)isEmpty;

@end

NS_ASSUME_NONNULL_END