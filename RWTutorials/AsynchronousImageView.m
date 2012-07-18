//
//  AsynchronousImageView.m
//  Quiz
//
//  Created by Martijn De Vos on 25-06-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AsynchronousImageView.h"

@implementation AsynchronousImageView

- (void)loadImageFromURLString:(NSString *)theUrlString withStorage:(BOOL)store
{
    if(store)
    {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:theUrlString] cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeoutInterval:30.0];                          
        
        connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    else
    {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:theUrlString] cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:30.0];
        
        connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData 
{    
    if (data == nil)
        data = [[NSMutableData alloc] initWithCapacity:2048];                 
    
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
    UIImage *im = [UIImage imageWithData:data];
    if(im)
    {
        self.image = im;
    }
    data = nil;
    connection = nil;
}

@end
