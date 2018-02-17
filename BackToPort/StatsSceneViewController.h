//
//  StatsSceneViewController.h
//  BackToPort
//
//  Created by MacBookPro on 12/01/2017.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface StatsSceneViewController : UIViewController <CLLocationManagerDelegate>
{
    CLLocationManager *locManSpeedCourse;
    
    IBOutlet UILabel *currentSpeed;
    IBOutlet UILabel *currentHeading;
    IBOutlet UILabel *currentCourse;
    
    double deviceSpeed;
    bool HeadingToggle;
}

@property (retain, nonatomic) UILabel *currentSpeed;
@property (retain, nonatomic) UILabel *currentHeading;
@property (retain, nonatomic) UILabel *currentCourse;

@end
