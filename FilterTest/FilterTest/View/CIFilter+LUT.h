//
//  CIFilter+LUT.h
//  FilterTest
//
//  Created by Antonio Jr Atamosa on 27/02/2017.
//  Copyright © 2017 Antonio Jr Atamosa. All rights reserved.
//

#import <CoreImage/CoreImage.h>

@interface CIFilter (LUT)

+(CIFilter *)filterWithLUT:(NSString *)name dimension:(NSInteger)n;

@end
