//
//  ViewController.m
//  PagingViewDemo
//
//  Created by Yonsm on 2017/12/29.
//  Copyright © 2017年 Yonsm. All rights reserved.
//

#import "ViewController.h"
#import "FixedPagingView.h"
#import "FlexPagingView.h"

@interface ViewController ()

@end


@implementation ViewController

//
- (NSString *)multilineText
{
	NSMutableString *text = [NSMutableString string];
	for (int i = 0; i < 26; i++)
	{
		[text appendFormat:@"%c\n", 'A'+i];
	}
	return text;
}

//
- (void)addSubviewsForPagingView:(UIScrollView *)pagingView
{
	CGRect frame = pagingView.bounds;
	
	for (int j = 0; j < 4; j++)
	{
		UILabel *label = [[UILabel alloc] initWithFrame:frame];
		label.textAlignment = NSTextAlignmentCenter;
		label.backgroundColor = [UIColor colorWithWhite:(j+1)/5.0 alpha:1];
		label.textColor = UIColor.whiteColor;
		label.font = [UIFont boldSystemFontOfSize:30];
		
		if (j == 2)
		{
			label.numberOfLines = 0;
			label.text = self.multilineText;

			CGRect labelFrame = frame;
			labelFrame.size.height = ceilf([label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(frame.size.width, 10000) lineBreakMode:label.lineBreakMode].height);

			if ([pagingView isKindOfClass:FlexPagingView.class])
			{
				[pagingView addSubview:label];
				frame.origin.y += labelFrame.size.height;
			}
			else
			{
				labelFrame.origin.x = labelFrame.origin.y = 0;

				UIScrollView *subScrollView = [[UIScrollView alloc] initWithFrame:frame];
				subScrollView.backgroundColor = UIColor.yellowColor;
				[subScrollView addSubview:label];
				subScrollView.contentSize = labelFrame.size;

				[pagingView addSubview:subScrollView];
				frame.origin.y += frame.size.height;
			}
			label.frame = labelFrame;
			continue;
		}

		label.text = [NSString stringWithFormat:@"%d", j+1];
		[pagingView addSubview:label];
		frame.origin.y += frame.size.height;
	}
	
	pagingView.contentSize = CGSizeMake(frame.size.width, frame.origin.y);
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	//
	CGRect frame = CGRectInset(self.view.bounds, 20, 50);
	
	//
	frame.size.height = frame.size.height / 2 - 10;
	{
		FixedPagingView *pagingView = [[FixedPagingView alloc] initWithFrame:frame];
		pagingView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever; // TODO
		pagingView.backgroundColor = UIColor.grayColor;
		[self.view addSubview:pagingView];
		[self addSubviewsForPagingView:pagingView];
	}
	
	//
	frame.origin.y += frame.size.height + 20;
	{
		FlexPagingView *pagingView = [[FlexPagingView alloc] initWithFrame:frame];
		pagingView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever; // TODO
		pagingView.backgroundColor = UIColor.grayColor;
		[self.view addSubview:pagingView];
		[self addSubviewsForPagingView:pagingView];
	}
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end

