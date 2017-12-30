
#import <UIKit/UIKit.h>

// Precondition:
//   1. subviews[n].width == FlexPagingView.width
//   2. subviews[n].height >= FlexPagingView.height
//   3. subviews[n].y + subviews[n].height = subviews[n+1].y
@interface FlexPagingView : UIScrollView <UIScrollViewDelegate>
@end
