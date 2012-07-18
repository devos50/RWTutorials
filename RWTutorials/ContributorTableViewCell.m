//
//  ContributorTableViewCell.m
//  RWTutorials
//
//  Created by Martijn De Vos on 16-07-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContributorTableViewCell.h"
#import "AsynchronousImageView.h"

@implementation ContributorTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) prepareForReuse
{
    AsynchronousImageView *imageView = (AsynchronousImageView *) [self viewWithTag:2];
    imageView.image = nil;
}

@end
