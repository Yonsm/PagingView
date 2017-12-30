
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
			NSLog(@"Enable(%.2f) decelerating %d<%d<%d", velocity.y, (int)frame.origin.y, (int)contentOffset.y, (int)(frame.origin.y + frame.size.height));
			if (targetContentOffset->y < frame.origin.y)
				targetContentOffset->y = frame.origin.y;
			else if (targetContentOffset->y > frame.origin.y + frame.size.height - scrollViewSize.height)
				targetContentOffset->y = frame.origin.y + frame.size.height - scrollViewSize.height;
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
	
	CGFloat offsetY = contentOffset.y;
	CGFloat minDelta = INT_MAX;
	UIView *nearlestView = nil;
	CGFloat nearlestY = offsetY;

	for (UIView *subview in scrollView.subviews)
	{
		if ([subview isKindOfClass:UIImageView.class]) // TODO
			continue;
		
		CGFloat y = subview.frame.origin.y;
		
		CGFloat delta = fabs(y - offsetY);
		if (minDelta > delta)
		{
			minDelta = delta;
			nearlestView = subview;
			nearlestY = y;
		}
		
		if (subview.frame.origin.y < offsetY && (subview.frame.size.height > scrollView.frame.size.height))
		{
			if ((offsetY + scrollView.frame.size.height * 3 /2 > subview.frame.origin.y + subview.frame.size.height) ||
				offsetY + scrollView.frame.size.height < subview.frame.origin.y + subview.frame.size.height)
			{
				y = subview.frame.origin.y + subview.frame.size.height - scrollView.frame.size.height;
				CGFloat delta = fabs(y - offsetY);
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
	
	if (nearlestView.frame.origin.y < offsetY && (nearlestView.frame.size.height > scrollView.frame.size.height))
	{
		if (offsetY + scrollView.frame.size.height < nearlestView.frame.origin.y + nearlestView.frame.size.height)
		{
			return;
		}
	}
	
	//
	if (nearlestY != offsetY)
	{
		contentOffset.y = nearlestY;
		[scrollView setContentOffset:contentOffset animated:YES];
	}
}

@end
