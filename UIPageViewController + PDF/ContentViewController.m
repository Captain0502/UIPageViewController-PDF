//
//  ContentViewController.m
//
//  Created by Jack Humphries on 3/20/12.
//  Copyright (c) 2012 Jack Humphries. All rights reserved.
//

#import "ContentViewController.h"

#define MAXZOOMSCALE 3.0
#define MINZOOMSCALE 1.0

@implementation ContentViewController

//
- (id)initWithPDF:(CGPDFDocumentRef)pdf {
    
    thePDF = pdf;
    
    self = [super initWithNibName:nil bundle:nil];
    
    return self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
            
    // Create our PDFScrollView and add it to the view controller.
    CGPDFPageRef PDFPage = CGPDFDocumentGetPage(thePDF, [_page intValue]);
    pdfScrollView = [[PDFScrollView alloc] initWithFrame:self.view.frame];
    [pdfScrollView setPDFPage:PDFPage];
    [self.view addSubview:pdfScrollView];
    
    pdfScrollView.delegate = self;
    pdfScrollView.minimumZoomScale = MINZOOMSCALE;
    pdfScrollView.maximumZoomScale = MAXZOOMSCALE;

    
    self.view.backgroundColor = [UIColor underPageBackgroundColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    pdfScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
}

-(void)dealloc {
    
    _page = nil;
    pdfScrollView = nil;
    
}

- (void)viewDidUnload
{
    
    [super viewDidUnload];
    
    _page = nil;
    pdfScrollView = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


#pragma mark UIScrollView delegate methods

/*
   Just forward all delegate messages to pdfScrollView original implementation
 */

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [pdfScrollView viewForZoomingInScrollView:scrollView];
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    [pdfScrollView scrollViewWillBeginZooming:scrollView withView:view];
}

/*
  Here, also adjust the zooming factors so the overall min/max are guaranteed
 */

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{

    [pdfScrollView scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    
    pdfScrollView.minimumZoomScale /= scale;
    pdfScrollView.maximumZoomScale /= scale;
}



@end