
#import "FlexPagingView.h"

@implementation FlexPagingView

//
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
		CGRect frame = subview.frame;
		if ([subview isKindOfClass:UIImageView.class] && frame.size.width < 5) // Exclude scroll indicator
			continue;
		
		if ((contentOffset.y > frame.origin.y) && (contentOffset.y + scrollViewSize.height < frame.origin.y + frame.size.height))
		{
			// Should enable decelerating in current view
			//NSLog(@"Should Enable decelerating: velocity.y=%.2f %d<%d<%d", velocity.y, (int)frame.origin.y, (int)contentOffset.y, (int)(frame.origin.y + frame.size.height));
			if (targetContentOffset->y < frame.origin.y)
			{
				targetContentOffset->y = frame.origin.y; // Limit decelerating to current view's top
			}
			else
			{
				CGFloat maxOffsetY = frame.origin.y + frame.size.height - scrollViewSize.height;
				if (targetContentOffset->y > maxOffsetY)
				{
					targetContentOffset->y = maxOffsetY; // Limit decelerating to current view's bottom
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
	CGSize scrollViewSize = scrollView.frame.size;
	CGPoint contentOffset = scrollView.contentOffset;
	CGFloat midOffsetY = contentOffset.y + scrollViewSize.height / 2;
	for (UIView *subview in scrollView.subviews)
	{
		CGRect frame = subview.frame;
		
		// Exclude scroll indicator
		if ([subview isKindOfClass:UIImageView.class] && frame.size.width < 5)
			continue;
		
		// Paging to this subview
		if (midOffsetY >= frame.origin.y && midOffsetY <= frame.origin.y + frame.size.height)
		{
			if (contentOffset.y < frame.origin.y)
			{
				contentOffset.y = frame.origin.y;
			}
			else
			{
				CGFloat maxOffsetY = frame.origin.y + frame.size.height - scrollViewSize.height;
				if (contentOffset.y > maxOffsetY)
				{
					contentOffset.y = maxOffsetY;
				}
				else
				{
					return;
				}
			}
			// Scroll to paging offset
			[scrollView setContentOffset:contentOffset animated:YES];
			return;
		}
	}
	
	// NSLog(@"WARNING: %@", @"Missed proper subview!");
}

@end

