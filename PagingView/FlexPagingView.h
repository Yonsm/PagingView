
#import <UIKit/UIKit.h>

// Precondition:
//   1. subviews[n].height >= FlexPagingView.height
//   2. subviews[0].y == 0
//   3. subviews[n].y + subviews[n].height == subviews[n+1].y
@interface FlexPagingView : UIScrollView <UIScrollViewDelegate>
@end
