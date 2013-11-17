//
//  MenuButtonView.m
//  POSTerminal
//
//  Created by Katherine Fisher on 11/17/13.
//  Copyright (c) 2013 Jonathan Fisher. All rights reserved.
//

#import "MenuButtonView.h"

@implementation MenuButtonView

#pragma mark - Properties

//@synthesize faceCardScaleFactor = _faceCardScaleFactor;
//
//#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.90
//
//- (CGFloat)faceCardScaleFactor
//{
//    if (!_faceCardScaleFactor) _faceCardScaleFactor = DEFAULT_FACE_CARD_SCALE_FACTOR;
//    return _faceCardScaleFactor;
//}
//
//- (void)setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor
//{
//    _faceCardScaleFactor = faceCardScaleFactor;
//    [self setNeedsDisplay];
//}

- (void)setName: (NSString *)name
{
    _name = name;
    [self setNeedsDisplay];
}

- (void)setProductDescription: (NSString *)productDescription
{
    _productDescription = productDescription;
    [self setNeedsDisplay];
}

//- (void)setFaceUp:(BOOL)faceUp
//{
//    _faceUp = faceUp;
//    [self setNeedsDisplay];
//}
//
//- (NSString *)rankAsString
//{
//    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"][self.rank];
//}

#pragma mark - Drawing

#define CORNER_RADIUS 12.0

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CORNER_RADIUS];
    
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
//    if (self.faceUp) {
//        UIImage *faceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@.jpg", [self rankAsString], self.suit]];
//        if (faceImage) {
//            CGRect imageRect = CGRectInset(self.bounds,
//                                           self.bounds.size.width * (1.0 - self.faceCardScaleFactor),
//                                           self.bounds.size.height * (1.0 - self.faceCardScaleFactor));
//            [faceImage drawInRect:imageRect];
//        } else {
//            [self drawPips];
//        }
//        [self drawCorners];
//    } else {
//        [[UIImage imageNamed:@"cardback.png"] drawInRect:self.bounds];
//    }
    
    
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
}





#define PIP_FONT_SCALE_FACTOR 0.20
#define CORNER_OFFSET 2.0

- (void)drawCorners
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *cornerFont = [UIFont systemFontOfSize:self.bounds.size.width * PIP_FONT_SCALE_FACTOR];
    
    NSAttributedString *cornerText = [[NSAttributedString alloc] initWithString:self.name attributes:@{ NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : cornerFont }];
    
    CGRect textBounds;
    textBounds.origin = CGPointMake(CORNER_OFFSET, CORNER_OFFSET);
    textBounds.size = [cornerText size];
    [cornerText drawInRect:textBounds];
    
    //[self pushContextAndRotateUpsideDown];
    [cornerText drawInRect:textBounds];
    [self popContext];
}

- (void)popContext
{
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

#pragma mark - Gesture Handlers
//
//- (void)pinch:(UIPinchGestureRecognizer *)gesture
//{
//    if ((gesture.state == UIGestureRecognizerStateChanged) ||
//        (gesture.state == UIGestureRecognizerStateEnded)) {
//        self.faceCardScaleFactor *= gesture.scale;
//        gesture.scale = 1;
//    }
//}






@end
