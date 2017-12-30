
#import <UIKit/UIKit.h>

// 要求：
//   1. 所有 subview 的宽度与 FlexPagingView 宽度一致；
//   2. 所有 subview 之间必须保证纵向无间隙，且不重叠；
@interface FlexPagingView : UIScrollView <UIScrollViewDelegate>
@end
