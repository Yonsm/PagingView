
#import "FlexPagingView.h"

@implementation FlexPagingView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	self.delegate = self;
	return self;
}

// Handle decelerating
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
	CGSize scrollViewSize = scrollView.frame.size;
	CGPoint contentOffset = scrollView.contentOffset;
	for (UIView *subview in scrollView.subviews)
	{
		if ([subview isKindOfClass:UIImageView.class]) // TODO
			continue;
		
		CGRect frame = subview.frame;
		if ((contentOffset.y > frame.origin.y) &&
			(contentOffset.y + scrollViewSize.height < frame.origin.y + frame.size.height))
		{
			// Should enable decelerating in current view
			//NSLog(@"Should Enable decelerating: velocity.y=%.2f %d<%d<%d", velocity.y, (int)frame.origin.y, (int)contentOffset.y, (int)(frame.origin.y + frame.size.height));
			if (targetContentOffset->y < frame.origin.y)
			{
				targetContentOffset->y = frame.origin.y; // Limit decelerating to current view's top
			}
			else
			{
				CGFloat maxY = frame.origin.y + frame.size.height - scrollViewSize.height;
				if (targetContentOffset->y > maxY)
				{
					targetContentOffset->y = maxY; // Limit decelerating to current view's bottom
				}
				else
				{
					// Keep decelerating
				}
			}
			return;
		}
	}
	
	// Disable decelerating
	*targetContentOffset = scrollView.contentOffset;
}

//
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	[self pagingScrollView:scrollView];
}

//
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (decelerate)
	{
		// NSLog(@"scrollViewDidEndDragging: Ignore extra decelerating");
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
	CGSize scrollViewSize = scrollView.frame.size;
//	if (scrollViewSize.height == 0)
//		return;
	
	//
	CGPoint contentOffset = scrollView.contentOffset;
	
	CGFloat minDelta = CGFLOAT_MAX;
	UIView *nearlestView = nil;
	CGFloat nearlestY = contentOffset.y;

	for (UIView *subview in scrollView.subviews)
	{
		if ([subview isKindOfClass:UIImageView.class]) // TODO
			continue;
		
		CGFloat y = subview.frame.origin.y;
		
		CGFloat delta = fabs(y - contentOffset.y);
		if (minDelta > delta)
		{
			minDelta = delta;
			nearlestView = subview;
			nearlestY = y;
		}
		
		if (subview.frame.origin.y < contentOffset.y && (subview.frame.size.height > scrollViewSize.height))
		{
			if ((contentOffset.y + scrollViewSize.height * 3 /2 > subview.frame.origin.y + subview.frame.size.height) ||
				contentOffset.y + scrollViewSize.height < subview.frame.origin.y + subview.frame.size.height)
			{
				y = subview.frame.origin.y + subview.frame.size.height - scrollViewSize.height;
				CGFloat delta = fabs(y - contentOffset.y);
				if (minDelta > delta)
				{
					minDelta = delta;
					nearlestView = subview;
					nearlestY = y;
				}
			}
		}
	}
	
	if (nearlestView == nil)
		return;
	
	//
	if (nearlestView.frame.origin.y < contentOffset.y && (nearlestView.frame.size.height > scrollViewSize.height))
	{
		if (contentOffset.y + scrollViewSize.height < nearlestView.frame.origin.y + nearlestView.frame.size.height)
		{
			return;
		}
	}
	
	// Scroll to paging offset
	if (contentOffset.y != nearlestY)
	{
		contentOffset.y = nearlestY;
		[scrollView setContentOffset:contentOffset animated:YES];
	}
}

@end
