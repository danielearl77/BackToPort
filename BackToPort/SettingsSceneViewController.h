//
//  SettingsSceneViewController.h
//  BackToPort
//
//  Created by MacBookPro on 12/01/2017.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SettingsSceneViewController : UIViewController <CLLocationManagerDelegate>
{
    CLLocationManager *locManTwo;

    IBOutlet UIButton *SaveButton;
    IBOutlet UISegmentedControl *HomeOtherToggle;
    IBOutlet UISwitch *HeadingSwitch;
    
    double lat;
    double lon;
}

@property (retain, nonatomic) UISwitch *HeadingSwitch;
@property (retain, nonatomic) UIButton *SaveButton;
@property (retain, nonatomic) UISegmentedControl *HomeOtherToggle;
@property (assign, nonatomic) double lat;
@property (assign, nonatomic) double lon;

- (IBAction)SaveLocation:(id)sender;
- (IBAction)SaveHeading:(id)sender;
- (void)saveCurrentLocation;


@end
