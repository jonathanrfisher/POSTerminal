//
//  MenuButtonView.m
//  POSTerminal
//
//  Created by Katherine Fisher on 11/17/13.
//  Copyright (c) 2013 Jonathan Fisher. All rights reserved.
//

#import "MenuButtonView.h"

//@interface MenuButtonView ()
//
//
//
//@end

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

- (void) setType:(NSString *)type
{
    _type = type;
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
    NSLog(@"DRAWRECT WAS CALLED");
    // Drawing code
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CORNER_RADIUS];
    
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];

    
    UIRectFill(self.bounds);
    
//    NSFileManager *filemgr;
//    NSString *currentpath;
//    
//    filemgr = [[NSFileManager alloc] init];
//    
//    currentpath = [filemgr currentDirectoryPath];
//    
//    NSLog(@"currentPath: %@",currentpath);
    
    UIImage *faceImage = [UIImage imageNamed:@"orangerec.png"];
    //NSLog(@"image: %@",[faceImage description]);
    //[faceImage drawAtPoint:CGPointMake(100,50)];
    //faceImage = nil;
    
    if (faceImage)
    {
        NSLog(@"inside faceImage with image: %@",[faceImage description]);
        
        CGRect imageRect = CGRectInset(self.bounds,
                                       0,
                                       0);
                                       
                                       //self.bounds.size.width,
                                       //self.bounds.size.height);
        
        [faceImage drawInRect:imageRect];
        //[self drawCorners];
    }
    
//    NSString *title = [NSString stringWithFormat:@"YOUR TITLE"];
//    NSString *alertMessage = [NSString stringWithFormat:@"YOUR MESSAGE"];
//    NSString *button1 = [NSString stringWithFormat:@"your button 1"];
//    NSString *button2 = [NSString stringWithFormat:@"your button 2"];
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:alertMessage delegate:self cancelButtonTitle:button1 otherButtonTitles:button2, nil];
//    
//    
//    
//    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:faceImage];
//    backgroundImageView.frame = CGRectMake(0, 0, 282, 130);
//    backgroundImageView.contentMode = UIViewContentModeScaleToFill;
//    
//    [alert addSubview:backgroundImageView];
//    [alert sendSubviewToBack:backgroundImageView];
//    [alert show];
   
    
    [[UIColor orangeColor] setStroke];
    [roundedRect stroke];
    [self drawCorners];
}





#define PIP_FONT_SCALE_FACTOR 0.14
#define CORNER_OFFSET 2.0

- (void)drawCorners
{
    NSLog(@"DRAW CORNERS WAS CALLED....");
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *cornerFont = [UIFont systemFontOfSize:self.bounds.size.width * PIP_FONT_SCALE_FACTOR];
    
    if (!self.name)
        self.name = @"name";
    
    NSMutableAttributedString *cornerText = [[NSMutableAttributedString alloc] initWithString:self.name attributes:@{ NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : cornerFont }];
    
    NSString *string = [cornerText string];
    
    NSRange rangeOfString = NSRangeFromString(string);
    UIColor *white = [UIColor whiteColor];
    
    [cornerText addAttribute:NSForegroundColorAttributeName value:white range:rangeOfString];
    
//    [string addAttribute:NSForegroundColorAttributeName
//                   value:[NSColor blueColor]
//                   range:selectedRange];
    
    
//    [cornerText addAttribute:NSForegroundColorAttributeName
//                       value:[UIColor whiteColor]
//                       range:[NSRangeFromString([cornerText string])]];
    
    CGRect textBounds = CGRectInset(self.bounds,
                                   0,
                                   self.bounds.size.height * .33);
    //textBounds.origin = CGPointMake(CORNER_OFFSET, CORNER_OFFSET);
    //textBounds.size = [cornerText size];
    [cornerText drawInRect:textBounds];
    
    //[self pushContextAndRotateUpsideDown];
    //[cornerText drawInRect:textBounds];
    //[self popContext];
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
