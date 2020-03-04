/**
 * Copyright (c) Seamless Payments, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

@import SeamlessPayCore;

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property(nonatomic, weak) SPPaymentCardTextField *cardTextField;
@property(nonatomic, weak) UIButton *payButton;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.

  SPPaymentCardTextField *cardTextField = [[SPPaymentCardTextField alloc] init];
  cardTextField.postalCodeEntryEnabled = TRUE;
  cardTextField.countryCode = @"US";
  self.cardTextField = cardTextField;


  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.layer.cornerRadius = 5;
  button.backgroundColor = [UIColor systemBlueColor];
  button.titleLabel.font = [UIFont systemFontOfSize:22];
  [button setTitle:@"Pay" forState:UIControlStateNormal];
  [button addTarget:self
                action:@selector(pay)
      forControlEvents:UIControlEventTouchUpInside];
  self.payButton = button;

  UILabel *infoLbel = [[UILabel alloc] init];
  infoLbel.text = @"Amount: $1.0";

  UIStackView *stackView = [[UIStackView alloc]
      initWithArrangedSubviews:@[ infoLbel, cardTextField, button ]];
  stackView.axis = UILayoutConstraintAxisVertical;
  stackView.translatesAutoresizingMaskIntoConstraints = FALSE;
  stackView.spacing = 20;
  [self.view addSubview:stackView];

  [NSLayoutConstraint activateConstraints:@[
    [stackView.leftAnchor
        constraintEqualToSystemSpacingAfterAnchor:self.view.leftAnchor
                                       multiplier:2],
    [self.view.rightAnchor
        constraintEqualToSystemSpacingAfterAnchor:stackView.rightAnchor
                                       multiplier:2],
    [stackView.topAnchor
        constraintEqualToSystemSpacingBelowAnchor:self.view.topAnchor
                                       multiplier:20],
  ]];

  self.activityIndicator = [[UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
  self.activityIndicator.center = self.view.center;
  [self.view addSubview:self.activityIndicator];
}

- (void)displayAlertWithTitle:(NSString *)title
                      message:(NSString *)message
                  restartDemo:(BOOL)restartDemo {
  dispatch_async(dispatch_get_main_queue(), ^{
    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:title
                         message:message
                  preferredStyle:UIAlertControllerStyleAlert];
    if (restartDemo) {
      [alert addAction:[UIAlertAction
                           actionWithTitle:@"Restart demo"
                                     style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action) {
                                     [self.cardTextField clear];
                                     self.cardTextField.postalCodeEntryEnabled = TRUE;
                                     self.cardTextField.countryCode = @"US";
                                   }]];
    } else {
      [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                style:UIAlertActionStyleCancel
                                              handler:nil]];
    }
    [self presentViewController:alert animated:YES completion:nil];
  });
}

- (void)pay {

  [self.activityIndicator startAnimating];

  [[SPAPIClient getSharedInstance] createPaymentMethodWithType:@"CREDIT_CARD"
      account:self.cardTextField.cardNumber
      expDate:self.cardTextField.formattedExpirationDate
      cvv:self.cardTextField.cvc
      accountType:nil
      routing:nil
      pin:nil
      address:nil
      address2:nil
      city:nil
      country:nil
      state:nil
      zip:self.cardTextField.postalCode
      company:nil
      email:nil
      phone:nil
      name:@"IOS test"
      nickname:nil
      verification : TRUE
      success:^(SPPaymentMethod *paymentMethod) {
        [[SPAPIClient getSharedInstance]
            createChargeWithToken:paymentMethod.token
            cvv:self.cardTextField.cvc
            capture: TRUE
            currency:nil
            amount:@"1"
            taxAmount:nil
            taxExempt: FALSE
            tip:nil
            surchargeFeeAmount:nil
            scheduleIndicator:nil
            description:@""
            order:nil
            orderId:nil
            poNumber:nil
            metadata:nil
            descriptor:nil
            txnEnv:nil
            achType:nil
            credentialIndicator:nil
            transactionInitiation:nil
            idempotencyKey:nil
            needSendReceipt:nil
            success:^(SPCharge *charge) {
              [self.activityIndicator stopAnimating];
              NSString *success = [NSString
                  stringWithFormat:@"Amount: $%@\nStatus: %@\nStatus message: "
                                   @"%@\ntxnID #: %@",
                                   charge.amount, charge.status,
                                   charge.statusDescription, charge.chargeId];

              [self displayAlertWithTitle:@"Success"
                                  message:success
                              restartDemo:TRUE];
            }
            failure:^(SPError *error) {
              [self.activityIndicator stopAnimating];
              NSString *err = [error localizedDescription];
              [self displayAlertWithTitle:@"Error creating Charge"
                                  message:err
                              restartDemo:FALSE];
            }];
      }
      failure:^(SPError *error) {
        [self.activityIndicator stopAnimating];
        NSString *err = [error localizedDescription];
        [self displayAlertWithTitle:@"Error creating Charge"
                            message:err
                        restartDemo:FALSE];
      }];
}

@end
