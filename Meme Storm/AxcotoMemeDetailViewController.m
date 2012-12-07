//
//  AxcotoMemeDetailViewController.m
//  Meme Storm
//
//  Created by Vinh Nguyen on 12/1/12.
//  Copyright (c) 2012 Vinh Nguyen. All rights reserved.
//

#import "AxcotoMemeDetailViewController.h"

//#import "ImageZoomingViewController.h"
//#import "TapDetectingImageView.h"

#define ZOOM_STEP 1.5

@interface AxcotoMemeDetailViewController ()
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;
@end



@implementation AxcotoMemeDetailViewController

@synthesize memeSource;
@synthesize imgContainer, imgViewUi, loader;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:[@"Meme Browser" stringByAppendingString: self.memeSource]];
    
    NSArray * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docRoot = [path objectAtIndex:0];
    
    currentMemeIndex = 0; //show the first picture
    currentMemePage = 0;
    memesList = [NSMutableArray arrayWithCapacity:5]; //NSMutuableArrat auto expand when needed. This is just to allocate an enought amount for initalize this array. So, 5 is an affordable number for this purpose.
    [memesList insertObject:@"marked_bound_page" atIndex:0];
    [self download];
    
    imgContainer.bouncesZoom = YES;
    imgContainer.delegate = self;
    imgContainer.clipsToBounds = YES;
    
    imgViewUi.autoresizingMask = ( UIViewAutoresizingFlexibleWidth );
    NSString * imgPath = [docRoot stringByAppendingFormat:@"/meme/funnymama/1_0.jpg"];
    imgViewUi =[[UIImageView alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:imgPath]]];
    [imgContainer addSubview:imgViewUi];
    imgContainer.contentSize = [imgViewUi frame].size;
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerTap:)];
    
    [imgViewUi addGestureRecognizer:doubleTap];
    [imgViewUi addGestureRecognizer:twoFingerTap];
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipe:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    rightSwipe.numberOfTouchesRequired = 1;
    [imgContainer addGestureRecognizer:rightSwipe];    
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipe:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    leftSwipe.numberOfTouchesRequired = 1;
    [imgContainer addGestureRecognizer:leftSwipe];
    
    // calculate minimum scale to perfectly fit image width, and begin at that scale
    float minimumScale = [imgContainer frame].size.width  / [imgViewUi frame].size.width;
    //imageScrollView.maximumZoomScale = 1.0;
    imgContainer.minimumZoomScale = minimumScale;
    imgContainer.zoomScale = minimumScale;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) download {
    currentMemePage++;
    currentMemeIndex=0;
    [self download:1 andShow:YES];
}

- (void) download:(NSUInteger)pageToDownload  andShow:(Boolean) show{
    
    NSArray * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * doc = [path objectAtIndex:0];
    NSString * memeFolder = [doc stringByAppendingPathComponent:@"meme/funnymama"];
    //[imgContainer setHidden:TRUE];
    [loader startAnimating];
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        [self fetchFromSource:pageToDownload];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:memeFolder]) {
            //try to create if not existed yet
            NSError * e;
            NSLog(@"Trying to validate memeFolder %@", memeFolder);
            if ([[NSFileManager defaultManager] createDirectoryAtPath:memeFolder withIntermediateDirectories:YES attributes:nil error:&e]) {
                NSLog(@"%@", @"Success to create memeFolder");
            } else {
                NSLog(@"[%@] ERROR: attempting to create meme directory", [self class]);
                NSAssert( FALSE, @"Failed to create directory maybe out of disk space?");
            }
        }
        
        NSArray * urls = [memesList objectAtIndex:pageToDownload];
        for (int i=0; i< [urls count]; i++) {
            NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:(NSString *) [[urls objectAtIndex:i] objectForKey:@"src"] ]];
            NSString * memeFile = [memeFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"/%d_%d.jpg", pageToDownload, i]];
            
            NSLog(@"INFO: attempting to create file %@", memeFile);
            [imageData writeToFile:memeFile atomically:YES];
        }
        [loader stopAnimating];
        [imgContainer setHidden:FALSE];
        if (show) {
            [self loadImage:0];
        }
    });
}


/**
* fetchFromSource should be in Asyntask or run on anothe thread instad of meain thread ot avoid block ui
**/
- (void) fetchFromSource:(NSUInteger)pageToDownload {
    //NSString * url = [@"http://127.0.0.1:9393/m/funnymama/" stringByAppendingFormat:@"%d", currentMemePage++];
    NSString * url = [@"http://meme-storm.herokuapp.com/m/funnymama/" stringByAppendingFormat:@"%d", pageToDownload];
    
    NSData * dataSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSArray * memes = (NSArray *)[dataSource objectFromJSONData];
    NSLog(@"%@", memes);
    
    //if ([memesList objectAtIndex:currentMemePage]==nil) {
        [memesList insertObject:memes atIndex:currentMemePage];
//    } else {
//        [memesList replaceObjectAtIndex:currentMemePage withObject:memes];
//    }
    
//    memesList[currentMemePage] = [NSMutableArray arrayWithCapacity:memes.count];
//    for (int i=0; i<[memes count]; i++) {
//        memesList[currentMemePage][i] = (NSString *)[[memes objectAtIndex:i] objectForKey:@"src"];
//    }
    //[sourceInput writeToFile:[docRoot stringByAppendingFormat:@"%@",@"json.txt"] atomically:YES];
}

- (void)viewDidUnload {
    [self setImgContainer:nil];
    [self setImgViewUi:nil];
    [self setLoader:nil];
    [super viewDidUnload];
}


// Implement a single scroll view delegate method
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)aScrollView {
    return imgViewUi;
}

#pragma mark Gesture method
- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    // zoom in
    float newScale = [imgContainer zoomScale] * ZOOM_STEP;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
    [imgContainer zoomToRect:zoomRect animated:YES];
}

- (void)handleTwoFingerTap:(UIGestureRecognizer *)gestureRecognizer {
    // two-finger tap zooms out
    float newScale = [imgContainer zoomScale] / ZOOM_STEP;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
    [imgContainer zoomToRect:zoomRect animated:YES];
}

- (void) handleRightSwipe:(UISwipeGestureRecognizer *) swipeGestureRecognizer {
    [self loadImage:-1];
    NSLog(@"%d", currentMemeIndex);
}

- (void) handleLeftSwipe:(UISwipeGestureRecognizer *) swipeGestureRecognizer {
    [self loadImage:1];
    NSLog(@"%d", currentMemeIndex);
}

- (void) loadImage:(int)id {
    if (id<0 && currentMemePage==1 && currentMemeIndex==0) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"No more!"
                                                          message:@"You are viewing the first meme."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        return;
    }
    
    if (id<0 && currentMemePage>0) {
        currentMemeIndex = currentMemeIndex + id;
        if (currentMemeIndex==-1) {
            currentMemePage = currentMemePage -1;
            currentMemeIndex = [[memesList objectAtIndex:currentMemePage] count];
        }
        [self loadImageAtPage:currentMemePage withIndex:currentMemeIndex];
        return;
    }
    
    if (id>=0 && currentMemeIndex < [[memesList objectAtIndex:currentMemePage] count]) {
        currentMemeIndex = currentMemeIndex + id;
        [self loadImageAtPage:currentMemePage withIndex:currentMemeIndex];
    } else {
        currentMemePage++;
        currentMemeIndex = 0;
        [self download:currentMemePage andShow:YES];
    }
}

- (void) loadImageAtPage:(NSUInteger) page withIndex:(int)index {
    @try {
        NSString * imgPath = [docRoot stringByAppendingFormat:@"/meme/funnymama/%d_%d.jpg", currentMemePage, currentMemeIndex];
        NSLog(@"%@", imgPath);
        if ([[NSFileManager defaultManager] fileExistsAtPath:imgPath]) {
            imgViewUi.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imgPath]];
        }
    } @catch (NSException * e) {
        NSLog(@"%@", e);
    }
}


#pragma mark Utility methods

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates.
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [imgContainer frame].size.height / scale;
    zoomRect.size.width  = [imgContainer frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}


@end
