//
//  HomeSceneViewController.h
//  BackToPort
//
//  Created by MacBookPro on 12/01/2017.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface HomeSceneViewController : UIViewController <CLLocationManagerDelegate>
{
    CLLocationManager *locMan;
    CLLocation *recentLocation;
    IBOutlet UILabel *distanceLable;
    IBOutlet UILabel *distanceToLabel;
    IBOutlet UIView *waitView;
    IBOutlet UIImageView *directionArrow;
    IBOutlet UILabel *displayPort;
    IBOutlet UILabel *displayCurrentLocation;
    IBOutlet UISegmentedControl *HomeOtherToggle;
    IBOutlet UITextField *onCourse;
    
    double lat;
    double lon;
}

@property (retain, nonatomic) CLLocation *recentLocation;
@property (retain, nonatomic) UILabel *distanceLable;
@property (retain, nonatomic) UILabel *distanceToLabel;
@property (retain, nonatomic) UIView *waitView;
@property (retain, nonatomic) UIImageView *directionArrow;
@property (retain, nonatomic) UILabel *displayPort;
@property (retain, nonatomic) UILabel *displayCurrentLocation;
@property (retain, nonatomic) UISegmentedControl *HomeOtherToggle;
@property (retain, nonatomic) UITextField *onCourse;
@property (assign, nonatomic) double lat;
@property (assign, nonatomic) double lon;

-(IBAction)ChoosePort:(id)sender;
-(void)LoadSelectedPort;
-(double)headingToLocation:(CLLocationCoordinate2D)desired current:(CLLocationCoordinate2D)current;

@end
