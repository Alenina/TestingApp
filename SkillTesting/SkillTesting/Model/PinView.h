//
//  PinView.h
//  SkillTesting
//
//  Created by LoveStar_PC on 2/4/15.
//  Copyright (c) 2015 IT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataModelForPins;

@interface PinView : UIView
{
    UIImageView * imgBack;
    UIImageView * imgSelectedPin;
    UILabel * lblTitle;
    UILabel * lblDescription;
}

@property NSInteger pinID;

- (instancetype) initWithFrame:(CGRect)frame;
- (void) setContentWithData:(DataModelForPins *) model;
- (void) setSelectedWithFlag:(BOOL) flagSelected;


@end
