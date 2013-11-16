//
//  TemplateViewController.m
//  SPLImage
//
//  Created by Girish Rathod on 07/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TemplateViewController.h"

@interface TemplateViewController ()

@end

@implementation TemplateViewController
#define SCROLL_VIEW_HEIGHT 330
#define PADDING 20

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    scrollTemplateView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, navBarPrimary.frame.size.height, navBarPrimary.frame.size.width , SCROLL_VIEW_HEIGHT)];
    [scrollTemplateView setPagingEnabled:YES];
    [scrollTemplateView setBackgroundColor:[UIColor clearColor]];
    [scrollTemplateView setShowsHorizontalScrollIndicator:NO];
    [scrollTemplateView setDelegate:self];
    [self.view addSubview:scrollTemplateView];
    [self.view bringSubviewToFront:scrollTemplateView];
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(10, advertView.frame.origin.y  - 20 , 80, 10)];
    [pageControl setCenter:CGPointMake(self.view.center.x, pageControl.center.y)];
//    [pageControl setBackgroundColor:[UIColor whiteColor]];
    [pageControl setNumberOfPages:12];
    [pageControl setCurrentPage:0];
    [pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
    [pageControl setCurrentPageIndicatorTintColor:COLOR_RGB(151, 203, 255, 1.0)];
    [pageControl addTarget:self action:@selector(changePage) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:pageControl];
    
    [self setTemplateButtons];
    [self setUpToolBarButton];
    
     
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
    //Delete files in tmp folder
    [SavedData removeAllImportedFiles];
  }
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma - mark User Functions

-(void)setUpToolBarButton{
    NSMutableArray *arrayBtn = [NSMutableArray arrayWithCapacity:0];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];// UIBarButtonSystemItemFixedSpace
    spacer.width = 250;
    
//    [arrayBtn addObject:spacer];

    UIImage *imgBtn = [UIImage imageNamed:@"Rate-us"];
    btnRateUs = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRateUs setFrame:CGRectMake(25, 5, imgBtn.size.width, imgBtn.size.height)];
    [btnRateUs setImage:imgBtn forState:UIControlStateNormal];
    [btnRateUs setTag:INDEX_LEFT];
    [btnRateUs addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *barBtn1 = [[UIBarButtonItem alloc] initWithCustomView:btnRateUs];
    [arrayBtn addObject:barBtn1];

    [arrayBtn addObject:spacer];
    
    UIImage *imgStars = [UIImage imageNamed:@"Stars"];
    UIButton *btnRateStars = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRateStars setFrame:CGRectMake(100, 5, imgStars.size.width, imgStars.size.height)];
    [btnRateStars setImage:imgStars forState:UIControlStateNormal];
    [btnRateStars setTag:INDEX_LEFT];
//    [btnRateStars addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIBarButtonItem *barBtn2 = [[UIBarButtonItem alloc] initWithCustomView:btnRateStars];
//    [arrayBtn addObject:barBtn2];

//    [arrayBtn addObject:spacer];

    UIImage *imgHeart = [UIImage imageNamed:@"shareBtn"];
    btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnShare setFrame:CGRectMake(CGRectGetMaxX(btnRateStars.frame), 5, imgHeart.size.width, imgHeart.size.height)];
    [btnShare setImage:imgHeart forState:UIControlStateNormal];
    [btnShare setTag:INDEX_RIGHT];
    [btnShare addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barBtn3 = [[UIBarButtonItem alloc] initWithCustomView:btnShare];
    [arrayBtn addObject:barBtn3];

//    [arrayBtn addObject:spacer];

    [toolBar setItems:arrayBtn animated:YES];

}

//not working for iOS 6
-(void)setTemplateButtons{
    int i =0;
    for (NSString *strBtnImage in [self readPlistForImagesArray]) {
        UIImage * btnImage = [UIImage imageNamed:strBtnImage];
//        NSLog(strBtnImage);
        int j = i%9;
        int k = floor(i/9);
        int l = j%3;
        int m = floor(j/3);
        CGFloat btnWidth = btnImage.size.width;
        CGFloat btnHeight = btnImage.size.height;
        CGFloat x = (l+1)*PADDING + l*btnWidth + k*navBarPrimary.frame.size.width;
        CGFloat y = (m+1)*PADDING + m*btnHeight;
        [self createButtonsWithImage:btnImage andTag:i andPoint:CGRectMake(x,y,btnWidth,btnHeight)];
        i++;
        [pageControl setNumberOfPages:k+1];
        [scrollTemplateView  setContentSize:CGSizeMake(pageControl.numberOfPages * navBarPrimary.frame.size.width, SCROLL_VIEW_HEIGHT)];

    }
}

-(void)createButtonsWithImage:(UIImage *)imgBtn andTag:(NSInteger)tagBtn andPoint:(CGRect)btnFrame{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:btnFrame];
    [btn setBackgroundImage:imgBtn forState:UIControlStateNormal];
    [btn setTag:tagBtn];
    [btn addTarget:self action:@selector(patternSelected:) forControlEvents:UIControlEventTouchUpInside];
    if ([[self readPlistForImagesArray] count]==tagBtn+1) {
        [btn setUserInteractionEnabled:NO];
    }
    [scrollTemplateView addSubview:btn];
}

-(void)patternSelected:(UIButton *)btnPatternSelected{
    
    patternLayoutView = [[PatternLayoutViewController alloc] initWithNibName:@"PatternLayoutViewController" bundle:nil andTag:[btnPatternSelected tag]];
    [self.navigationController pushViewController:patternLayoutView animated:YES];
}
- (void)changePage {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = scrollTemplateView.frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = scrollTemplateView.frame.size;
    [scrollTemplateView scrollRectToVisible:frame animated:YES];
}

#pragma mark - UIScrollView Delegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page = scrollView.contentOffset.x/scrollView.frame.size.width;
    pageControl.currentPage=page;
}

#pragma mark -

-(void)tabBarButtonClicked:(UIButton *)sender{
    switch ([sender tag]) {
        case INDEX_LEFT:{
           // EVLog(@"Rate us Btn");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Rate Splimage"
                                                            message:@"Having fun with Splimage? \nWe would love to hear from you.\n If you can take a moment to write a 5-star review; we would greatly appreciate it.\n Thank you for your support :-)"
                                                           delegate:self
                                                  cancelButtonTitle:@"Not now"
                                                  otherButtonTitles:@"Rate", nil];
            [alert show];
            break;
        }
            
        case INDEX_RIGHT:
         //   EVLog(@"Share Btn");
            [self sendShortMessageService];
            break;
            
        default:
            break;
    }
}


#pragma mark - SPLViewController Delegate
-(void)navBarButtonClicked:(UIButton *)sender{
    switch ([sender tag]) {
        case INDEX_LEFT:
            NSLog(@"FB Like Btn");
            [self likeButtonOnFaceBookClicked];
            break;
            
        case INDEX_RIGHT:
            NSLog(@"Twitter follow Btn");
            [self twitterFollowButtonTapped];
            break;

        default:
            break;
    }
}

#pragma mark - Rate Us
-(void)rateUsOnAppStore{

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=608308710"]];

}

#pragma amrk -  UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            [self rateUsOnAppStore];
            break;

        default:
            break;
    }
}
#pragma amrk -

#pragma mark - SMS
-(void) sendShortMessageService
{
	MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init] ;
	if([MFMessageComposeViewController canSendText])
	{
		controller.body = @"Hey, download Splimage.\n It’s an incredible app that lets you create amazing video collages for FREE!!!\n www.splimage.com";
		controller.messageComposeDelegate = self;
		[self presentViewController:controller animated:YES completion:nil];
	}
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	switch (result) {
		case MessageComposeResultCancelled:
			NSLog(@"Cancelled");
			break;
		case MessageComposeResultFailed:{
            UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Unknown Error.\nTry again later." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
			[alertView show];
			break;
        }
		case MessageComposeResultSent:{
            UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Message sent." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
			[alertView show];

			break;
        }
		default:
			break;
	}
    
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Social Media
-(void)likeButtonOnFaceBookClicked{
    FaceBookLikeViewController *faceBookViewController =[FaceBookLikeViewController new];
    [self.navigationController pushViewController:faceBookViewController animated:YES];
}

-(void)twitterFollowButtonTapped{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    twitterAlerMsg = @"Twitter follow operation incomplete";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTwitterAlertMessage:) name:@"twitter" object:nil];

    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if(granted) {
            // Get the list of Twitter accounts.
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
            
            // For the sake of brevity, we'll assume there is only one Twitter account present.
            // You would ideally ask the user which account they want to tweet from, if there is more than one Twitter account present.
            if ([accountsArray count] > 0) {
                // Grab the initial Twitter account to tweet from.
                ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
                
                NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
                [tempDict setValue:TWITTER_ID forKey:@"screen_name"];
                [tempDict setValue:@"true" forKey:@"follow"];
                
                //requestForServiceType
                
                SLRequest *postRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:[NSURL URLWithString:@"https://api.twitter.com/1/friendships/create.json"] parameters:tempDict];
                [postRequest setAccount:twitterAccount];
                [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    NSString *output = [NSString stringWithFormat:@"HTTP response status: %i Error %d", [urlResponse statusCode],error.code];
                    NSLog(@"%@error %@", output,error.description);
                    if (error) {
                        twitterAlerMsg = @"Twitter follow operation Failed";
                     }
                    else{
                        twitterAlerMsg =  @"You are following @splimage";

                    }

                    [[NSNotificationCenter defaultCenter] postNotificationName:@"twitter" object:nil];


                }];
            }else{
                //ask user to login to twitter
                twitterAlerMsg = @"Twitter follow operation Failed : Login to twitter first";
               [[NSNotificationCenter defaultCenter] postNotificationName:@"twitter" object:nil];
            }
            
        }else
        {
            //ask user to grant access through twitter
            twitterAlerMsg = @"Twitter follow operation Failed : Twitter Access Denied";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"twitter" object:nil];
        }
    }];

}

-(void)showTwitterAlertMessage:(NSNotification *)notification {
    UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Twitter Alert" message:twitterAlerMsg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    
    [alertView
     performSelector:@selector(show)
     onThread:[NSThread mainThread]
     withObject:nil
     waitUntilDone:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
