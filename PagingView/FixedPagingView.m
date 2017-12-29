
#import "FixedPagingView.h"

@implementation FixedPagingView

//#define _SystemDefaultPagingImplementation
#ifdef _SystemDefaultPagingImplementation

//
- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	self.pagingEnabled = YES;
	return self;
}

#else

//
- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	self.delegate = self;
	return self;
}

// Disable decelerating
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
	*targetContentOffset = scrollView.contentOffset;
}

//
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
{
	if (decelerate)
	{
		//NSLog(@"Ignore extra decelerating!");
		return;
	}
	else
	{
		[self pagingScrollView:scrollView];
	}
}

//
- (void)pagingScrollView:(UIScrollView *)scrollView
{
	//
	CGFloat height = scrollView.frame.size.height;
	if (height == 0)
		return;
	
	//
	CGPoint contentOffset = scrollView.contentOffset;
	
	CGFloat y = contentOffset.y;
	NSUInteger pageIndex = floor((y + height / 2) / height);
	NSUInteger pagesCount = self.contentSize.height / height;
	if (pagesCount == 0)
	{
		return;
	}
	else if (pageIndex >= pagesCount)
	{
		pageIndex = pagesCount - 1;
	}
	
	//
	CGFloat pagingOffsetY = pageIndex * height;
	if (contentOffset.y != pagingOffsetY)
	{
		contentOffset.y = pagingOffsetY;
		[scrollView setContentOffset:contentOffset animated:YES];
	}
}

#endif

@end
