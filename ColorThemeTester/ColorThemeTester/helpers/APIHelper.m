//
//  APIHelper.m
//  ColorThemeTester
//
//  Created by Kishore Kumar on 22/7/13.
//  Copyright (c) 2013 Kishore Kumar. All rights reserved.
//

#import "APIHelper.h"
#import "ColourThemeObject.h"
#import "AFJSONRequestOperation.h"
#import "AFXMLRequestOperation.h"

#warning Kuler API is no longer providing access to public, if you are one among the lucky ones to get an API somehow, you can play around.
#define KULER_API_URL @""
#define KULER_API_KEY @""

#define COLOURlovers_API_URL @"http://www.colourlovers.com/api/palettes/top?numResults=60"

@interface APIHelper ()<NSXMLParserDelegate>

@property(nonatomic, strong) NSMutableArray *parsedColors;
@property(nonatomic, strong) NSString *elementName;
@property(nonatomic, strong) NSString *elementValue;
@property(nonatomic, strong) ColourThemeObject *tempObj;
@property(nonatomic, assign) int colorCount;

@property(nonatomic, strong) onSuccess success;

@end

@implementation APIHelper

-(void) fetchKulerColourThemesOnSuccess:(onSuccess) success{
    
    NSURL *url = [NSURL URLWithString:KULER_API_URL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:KULER_API_KEY forHTTPHeaderField:@"x-api-key"];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSMutableArray *colorObjs = [[NSMutableArray alloc] init];
        
        if ([JSON objectForKey:@"themes"]) {
            NSArray *themes = [JSON objectForKey:@"themes"];
            for (NSDictionary *theme in themes) {
                if ([theme objectForKey:@"swatches"]) {
                    
                    NSArray *colors = [theme objectForKey:@"swatches"];
                    ColourThemeObject *obj = [[ColourThemeObject alloc] init];
                    obj.title = [theme objectForKey:@"name"];
                    
                    int count = 1;
                    for (NSDictionary *color in colors) {
                        NSArray *floatVals = [color objectForKey:@"values"];
                        UIColor *col = [UIColor colorWithRed:[[floatVals objectAtIndex:0] floatValue] green:[[floatVals objectAtIndex:1] floatValue] blue:[[floatVals objectAtIndex:2] floatValue] alpha:1];
                        
                        switch (count) {
                            case 1:
                                obj.color1 = col;
                                break;
                            case 2:
                                obj.color2 = col;
                                break;
                            case 3:
                                obj.color3 = col;
                                break;
                            case 4:
                                obj.color4 = col;
                                break;
                            case 5:
                                obj.color5 = col;
                                break;
                            default:
                                break;
                        }
                        count++;
                    }
                    [colorObjs addObject:obj];
                }
            }
        }
        
        success(colorObjs);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        success(@[]);
    }];
    [operation start];
}

-(void) fetchCOLOURloversColourThemesOnSuccess:(onSuccess) success{
    self.success = success;
    self.parsedColors = [NSMutableArray array];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:COLOURlovers_API_URL]];
    AFXMLRequestOperation *operation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
        XMLParser.delegate = self;
        [XMLParser parse];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser) {
        success(@[]);
    }];
    
    [operation start];
}

#pragma mark - NSXMLParser Delegate


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    self.elementValue = string;
    
    if ([self.elementName isEqualToString:@"palette"]) {
        self.tempObj = [[ColourThemeObject alloc] init];
        self.colorCount = 0;
    }
    
    if ([self.elementName isEqualToString:@"hex"] && [self.elementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length>0) {

        switch (self.colorCount) {
            case 0:
                self.tempObj.color1 = [APIHelper colorWithHexString:self.elementValue];
                break;
            case 1:
                self.tempObj.color2 = [APIHelper colorWithHexString:self.elementValue];
                break;
            case 2:
                self.tempObj.color3 = [APIHelper colorWithHexString:self.elementValue];
                break;
            case 3:
                self.tempObj.color4 = [APIHelper colorWithHexString:self.elementValue];
                break;
            case 4:
                self.tempObj.color5 = [APIHelper colorWithHexString:self.elementValue];
                break;
            default:
                break;
        }
        self.colorCount++;
    }
    
    if ([self.elementName isEqualToString:@"title"] &&  [self.elementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length>0) {
        self.tempObj.title = self.elementValue;
    }
    
    if ([self.elementName isEqualToString:@"url"] &&  [self.elementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length>0) {
        self.tempObj.url = self.elementValue;
        [self.parsedColors addObject:self.tempObj];
    }
    
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    self.elementName = elementName;
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
    self.success(self.parsedColors);
}

#pragma mark - Custom

//http://stackoverflow.com/questions/3010216/how-can-i-convert-rgb-hex-string-into-uicolor-in-objective-c

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *noHashString = [stringToConvert stringByReplacingOccurrencesOfString:@"#" withString:@""]; // remove the #
    NSScanner *scanner = [NSScanner scannerWithString:noHashString];
    [scanner setCharactersToBeSkipped:[NSCharacterSet symbolCharacterSet]]; // remove + and $
    
    unsigned hex;
    if (![scanner scanHexInt:&hex]) return nil;
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f];
}


@end
