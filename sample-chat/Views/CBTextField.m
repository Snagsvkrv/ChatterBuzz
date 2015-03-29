//
//  CBTextField.m
//  sample-chat
//
//  Created by Atul Manwar on 29/03/15.
//  Copyright (c) 2015 Igor Khomenko. All rights reserved.
//

#import "CBTextField.h"

@implementation CBTextField

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    return self;
}

-(void) drawRect:(CGRect)rect {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [[UIColor colorWithRed:(192/255.0) green: (192/255.0) blue: (192/255.0) alpha: 1.0] CGColor];
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 4;
}

-(CGRect) textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds, 20, 10);
}

-(CGRect) editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds, 20, 10);
}

@end

