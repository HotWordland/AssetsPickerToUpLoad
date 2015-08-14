//
//  PhotosToUploadCell.m
//  AssetsPickerToUpLoad
//
//  Created by Ronaldinho on 15/8/11.
//  Copyright (c) 2015年 HotWordLand. All rights reserved.
//

#import "PhotosToUploadCell.h"
#import "PureLayout.h"
@implementation PhotosToUploadCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
   self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _progress = [[UIProgressView alloc]initForAutoLayout];
        [_progress setProgress:0.0];
        [self addSubview:_progress];
    }
    return self;
    
}
- (void)awakeFromNib {
    // Initialization code
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self addConstraints:@[[_progress autoAlignAxisToSuperviewAxis:ALAxisVertical],[_progress autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5]]];
    [self addConstraints:[_progress autoSetDimensionsToSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width/2.5, 2)]];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
