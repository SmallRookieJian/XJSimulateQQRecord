//
//  SpectrumView.m
//  GYSpectrum
//
//  Created by 黄国裕 on 16/8/19.
//  Copyright © 2016年 黄国裕. All rights reserved.
//

#import "SpectrumView.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define SpectrumViewTextFont [UIFont systemFontOfSize:12]

@interface SpectrumView ()

@property (nonatomic, strong) NSMutableArray * levelArray;
@property (nonatomic) NSMutableArray * itemArray;
@property (nonatomic) CGFloat itemHeight;
@property (nonatomic) CGFloat itemWidth;

@end

@implementation SpectrumView


- (id)init
{
    NSLog(@"init");
    if(self = [super init]) {
        [self setup];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    NSLog(@"initWithFrame");
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    
    NSLog(@"setup");
    
    self.itemArray = [NSMutableArray new];
    
    self.numberOfItems = 18;//偶数
//    self.itemColor = [UIColor colorWithRed:241/255.f green:60/255.f blue:57/255.f alpha:1.0];
    self.itemColor = kItemColor;
    self.itemHeight = CGRectGetHeight(self.bounds);
    self.itemWidth  = CGRectGetWidth(self.bounds);
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.itemWidth*0.35, 0, self.itemWidth*0.3, self.itemHeight)];
    self.timeLabel.text = @"";
    [self.timeLabel setTextColor:[UIColor grayColor]];
    [self.timeLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.timeLabel];
    
    self.timeLabel.font = SpectrumViewTextFont;
//    self.timeLabel.backgroundColor = [UIColor orangeColor];
    
    self.levelArray = [[NSMutableArray alloc]init];
    for(int i = 0 ; i < self.numberOfItems/2 ; i++){
        [self.levelArray addObject:@(1)];
    }
}

-(void)setItemLevelCallback:(void (^)())itemLevelCallback
{
    NSLog(@"setItemLevelCallback");
    
    _itemLevelCallback = itemLevelCallback;
    
//    CADisplayLink *displaylink = [CADisplayLink displayLinkWithTarget:_itemLevelCallback selector:@selector(invoke)];
//    displaylink.frameInterval = 6;
//    [displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    for(int i=0; i < self.numberOfItems; i++)
    {
        CAShapeLayer *itemline = [CAShapeLayer layer];
        itemline.lineCap       = kCALineCapButt;
        itemline.lineJoin      = kCALineJoinRound;
        itemline.strokeColor   = [[UIColor clearColor] CGColor];
        itemline.fillColor     = [[UIColor clearColor] CGColor];
        [itemline setLineWidth:self.itemWidth*0.35/self.numberOfItems];
        itemline.strokeColor   = [self.itemColor CGColor];
        
        [self.layer addSublayer:itemline];
        [self.itemArray addObject:itemline];
    }
    
}

- (void)setLevel:(CGFloat)level
{
    //NSLog(@"setLevel:%f",level);
    level = (level+37.5)*3.2;
    if( level < 0 ) level = 0;

    [self.levelArray removeObjectAtIndex:self.numberOfItems/2-1];
    [self.levelArray insertObject:@((level / 6) < 1 ? 1 : level / 6) atIndex:0];
    
    [self updateItems];
    
}

- (void)setText:(NSString *)text{
    self.timeLabel.text = text;
}


- (void)updateItems
{
    //NSLog(@"updateMeters");
    
    UIGraphicsBeginImageContext(self.frame.size);
    
    int space = self.itemWidth*0.7/self.numberOfItems;//这个表示item之间的距离
    
    int z = self.itemWidth*0.3/self.numberOfItems;
//    int z = self.itemWidth*0.3/2;
    int y = self.itemWidth*0.65 - z;
    
    for(int i=0; i < (self.numberOfItems / 2); i++) {
        
        UIBezierPath *itemLinePath = [UIBezierPath bezierPath];
        
        y += space;
        
        [itemLinePath moveToPoint:CGPointMake(y, self.itemHeight/2+([[self.levelArray objectAtIndex:i]intValue]+1)*z/2)];
        
        [itemLinePath addLineToPoint:CGPointMake(y, self.itemHeight/2-([[self.levelArray objectAtIndex:i]intValue]+1)*z/2)];
        
        CAShapeLayer *itemLine = [self.itemArray objectAtIndex:i];
        itemLine.path = [itemLinePath CGPath];
        
    }
    
    
    y = self.itemWidth*0.35 + z;
    
    for(int i = (int)self.numberOfItems / 2; i < self.numberOfItems; i++) {
        
        UIBezierPath *itemLinePath = [UIBezierPath bezierPath];
        
        y -= space;
        
        [itemLinePath moveToPoint:CGPointMake(y, self.itemHeight/2+([[self.levelArray objectAtIndex:i-self.numberOfItems/2]intValue]+1)*z/2)];
        
        [itemLinePath addLineToPoint:CGPointMake(y, self.itemHeight/2-([[self.levelArray objectAtIndex:i-self.numberOfItems/2]intValue]+1)*z/2)];
        
        CAShapeLayer *itemLine = [self.itemArray objectAtIndex:i];
        itemLine.path = [itemLinePath CGPath];
        
    }
    
    UIGraphicsEndImageContext();
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
