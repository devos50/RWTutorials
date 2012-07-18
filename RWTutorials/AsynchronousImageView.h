//
//  AsynchronousImageView.h
//  Quiz
//
//  Created by Martijn De Vos on 25-06-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AsynchronousImageView : UIImageView
{
    NSURLConnection *connection;
    NSMutableData *data;
}

- (void)loadImageFromURLString:(NSString *)theUrlString withStorage:(BOOL)store;

@end
