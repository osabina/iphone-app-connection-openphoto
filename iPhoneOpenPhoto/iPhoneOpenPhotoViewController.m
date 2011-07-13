//
//  iPhoneOpenPhotoViewController.m
//  iPhoneOpenPhoto
//
//  Created by Patrick Santana on 12/07/11.
//  Copyright 2011 Moogu bvba. All rights reserved.
//

#import "iPhoneOpenPhotoViewController.h"

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * Private interface definitions
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
@interface iPhoneOpenPhotoViewController()
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
- (void)searchPhotos;
@end


@implementation iPhoneOpenPhotoViewController

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"Connection failed: %@", [error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [connection release];
    
    // convert the responseDate to the json string
	NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    // it can be released
    [responseData release];
    
    // Create a dictionary from JSON string
	NSDictionary *results = [jsonString JSONValue];
    
    // Build an array with all photos from the dictionary.
	NSArray *photos = [results objectForKey:@"result"] ;
    
    // Loop through each entry in the dictionary...
    for (NSDictionary *photo in photos){
        // Get title of the image
        NSString *title = [photo objectForKey:@"Name"];
        
        // print the title and url. If no name, add Untitled.
        NSLog(@"Photo Title: %@", (title.length > 0 ? title : @"Untitled"));
        NSString *photoURLString = [NSString stringWithFormat:@"http://%@%@", [photo objectForKey:@"host"], [photo objectForKey:@"path200x200"]];
        NSLog(@"Photo url: %@ \n\n", photoURLString);
        
        /*
         
         NSMutableArray  *photoTitles;         // Titles of images
         NSMutableArray  *photoSmallImageData; // Image data (thumbnail)
         NSMutableArray  *photoURLsLargeImage; // URL to larger image 
         
         [photoTitles addObject:(title.length > 0 ? title : @"Untitled")];
         [photoSmallImageData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:photoURLString]]];
         [photoURLsLargeImage addObject:[NSURL URLWithString:photoURLString]]; 
         
         */
    } 
}


- (void)searchPhotos{
    // create the url to connect to OpenPhoto
    NSString *urlString = @"http://current.openphoto.me/photos.json";
    NSURL *url = [NSURL URLWithString:urlString];
    
    responseData = [[NSMutableData data] retain];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad{
    [super viewDidLoad];
    
    // call the method to search the photos
    [self searchPhotos];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
