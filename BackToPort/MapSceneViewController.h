//
//  MapSceneViewController.h
//  BackToPort
//
//  Created by MacBookPro on 13/01/2017.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface MapSceneViewController : UIViewController <CLLocationManagerDelegate>
{
    IBOutlet MKMapView *map;
    CLLocationManager *locManThree;
    double latMap;
    double lonMap;
}
@property (assign, nonatomic) double latMap;
@property (assign, nonatomic) double lonMap;
@property (retain, nonatomic) MKMapView *map;

@end
