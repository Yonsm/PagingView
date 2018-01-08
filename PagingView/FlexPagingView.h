
#import <UIKit/UIKit.h>

// Precondition:
//   1. subviews[0].y == 0
//   2. subviews[n].y + subviews[n].height == subviews[n+1].y
//   3. Preferred: subviews[n].height >= FlexPagingView.height
@interface FlexPagingView : UIScrollView <UIScrollViewDelegate>
@end
