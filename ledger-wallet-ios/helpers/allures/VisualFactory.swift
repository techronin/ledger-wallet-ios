//
//  VisualFactory.swift
//  ledger-wallet-ios
//
//  Created by Nicolas Bigot on 07/01/2015.
//  Copyright (c) 2015 Ledger. All rights reserved.
//

import UIKit

struct VisualFactory {
    
    typealias TextAttribute = [NSObject: AnyObject]
    
    struct TextAttributes {
    
        static let pageTitle = [
            NSForegroundColorAttributeName: Colors.white,
            NSKernAttributeName: -Fonts.Kernings.small,
            NSFontAttributeName: Fonts.semiboldFontWithSize(Fonts.Sizes.almostLarge.rawValue)
        ]
        
        static let largePageTitle = [
            NSForegroundColorAttributeName: Colors.white,
            NSKernAttributeName: -Fonts.Kernings.large,
            NSFontAttributeName: Fonts.regularFontWithSize(Fonts.Sizes.almostUltraLarge.rawValue)
        ]
        
        static let navigationBarText = [
            NSForegroundColorAttributeName: Colors.lightGrey,
            NSKernAttributeName: -Fonts.Kernings.verySmall,
            NSFontAttributeName: Fonts.regularFontWithSize(Fonts.Sizes.small.rawValue)
        ]
        
        static let navigationBarWhiteText = [
            NSForegroundColorAttributeName: Colors.white,
            NSKernAttributeName: -Fonts.Kernings.verySmall,
            NSFontAttributeName: Fonts.semiboldFontWithSize(Fonts.Sizes.small.rawValue)
        ]
        
        static let medium = [
            NSForegroundColorAttributeName: Colors.black,
            NSKernAttributeName: -Fonts.Kernings.verySmall,
            NSFontAttributeName: Fonts.regularFontWithSize(Fonts.Sizes.medium.rawValue),
            NSParagraphStyleAttributeName: {
                let paragraph = NSMutableParagraphStyle()
                paragraph.lineSpacing = Metrics.LineSpacings.small
                return paragraph
            }()
        ]
        
        static let mediumCentered: TextAttribute = TextAttributes.extend(medium, withAttributes: [
            NSParagraphStyleAttributeName: {
                let paragraph = (medium[NSParagraphStyleAttributeName] as NSParagraphStyle).mutableCopy() as NSMutableParagraphStyle
                paragraph.alignment = NSTextAlignment.Center
                return paragraph
                }()
            ]
        )
        
        static let mediumGrey: TextAttribute = TextAttributes.extend(medium, withAttributes: [
                NSForegroundColorAttributeName: Colors.darkGrey
            ]
        )
        
        static let mediumSoftGrey: TextAttribute = TextAttributes.extend(medium, withAttributes: [
                NSForegroundColorAttributeName: Colors.softGrey
            ]
        )
        
        static let small = [
            NSForegroundColorAttributeName: Colors.black,
            NSKernAttributeName: -Fonts.Kernings.verySmall,
            NSFontAttributeName: Fonts.regularFontWithSize(Fonts.Sizes.small.rawValue),
            NSParagraphStyleAttributeName: {
                let paragraph = NSMutableParagraphStyle()
                paragraph.lineSpacing = Metrics.LineSpacings.large
                return paragraph
                }()
        ]
        
        static let smallCentered: TextAttribute = TextAttributes.extend(small, withAttributes: [
            NSParagraphStyleAttributeName: {
                let paragraph = (small[NSParagraphStyleAttributeName] as NSParagraphStyle).mutableCopy() as NSMutableParagraphStyle
                paragraph.alignment = NSTextAlignment.Center
                return paragraph
                }()
            ]
        )
        
        static let smallGrey: TextAttribute = TextAttributes.extend(small, withAttributes: [
                NSForegroundColorAttributeName: Colors.darkGrey
            ]
        )
        
        static let smallGreyCentered: TextAttribute = TextAttributes.extend(smallGrey, withAttributes: [
            NSParagraphStyleAttributeName: {
                let paragraph = (smallGrey[NSParagraphStyleAttributeName] as NSParagraphStyle).mutableCopy() as NSMutableParagraphStyle
                paragraph.alignment = NSTextAlignment.Center
                return paragraph
                }()
            ]
        )
        
        static let smallSoftGrey: TextAttribute = TextAttributes.extend(smallGrey, withAttributes: [
                NSForegroundColorAttributeName: Colors.softGrey
            ]
        )
        
        static let smallSoftGreyCentered: TextAttribute = TextAttributes.extend(smallSoftGrey, withAttributes: [
            NSParagraphStyleAttributeName: {
                let paragraph = (smallSoftGrey[NSParagraphStyleAttributeName] as NSParagraphStyle).mutableCopy() as NSMutableParagraphStyle
                paragraph.alignment = NSTextAlignment.Center
                return paragraph
                }()
            ]
        )
        
        static let largeIndication = [
            NSForegroundColorAttributeName: Colors.black,
            NSKernAttributeName: -Fonts.Kernings.small,
            NSFontAttributeName: Fonts.lightFontWithSize(Fonts.Sizes.almostLarge.rawValue),
            NSParagraphStyleAttributeName: {
                let paragraph = NSMutableParagraphStyle()
                paragraph.lineSpacing = Metrics.LineSpacings.medium
                return paragraph
                }()
        ]
        
        static let largeIndicationGrey: TextAttribute = TextAttributes.extend(largeIndication, withAttributes: [
                NSForegroundColorAttributeName: Colors.darkGrey
            ]
        )
        
        static let largeIndicationGreyCentered: TextAttribute = TextAttributes.extend(largeIndicationGrey, withAttributes: [
            NSParagraphStyleAttributeName: {
                let paragraph = (largeIndicationGrey[NSParagraphStyleAttributeName] as NSParagraphStyle).mutableCopy() as NSMutableParagraphStyle
                paragraph.alignment = NSTextAlignment.Center
                return paragraph
                }()
            ]
        )
        
        static let hugeNumberGrey = [
            NSForegroundColorAttributeName: Colors.darkGrey,
            NSKernAttributeName: -Fonts.Kernings.small,
            NSFontAttributeName: Fonts.lightFontWithSize(40)
        ]
        
        static let largeTitle = [
            NSForegroundColorAttributeName: Colors.black,
            NSKernAttributeName: -Fonts.Kernings.small,
            NSFontAttributeName: Fonts.regularFontWithSize(Fonts.Sizes.large.rawValue)
        ]
        
        static let roundedButtonText = [
            NSForegroundColorAttributeName: Colors.white,
            NSKernAttributeName: -Fonts.Kernings.small,
            NSFontAttributeName: Fonts.regularFontWithSize(Fonts.Sizes.almostLarge.rawValue)
        ]
        
        static let huge = [
            NSForegroundColorAttributeName: Colors.black,
            NSKernAttributeName: -Fonts.Kernings.veryLarge,
            NSFontAttributeName: Fonts.lightFontWithSize(Fonts.Sizes.megaLarge.rawValue)
        ]
        
        static let sectionTitle = [
            NSForegroundColorAttributeName: Colors.black,
            NSKernAttributeName: -Fonts.Kernings.small,
            NSFontAttributeName: Fonts.semiboldFontWithSize(Fonts.Sizes.almostLarge.rawValue)
        ]
        
        private static func extend(textAttribute: TextAttribute, withAttributes attributes: TextAttribute) -> TextAttribute {
            var newAttributes = textAttribute
            newAttributes.merge(attributes)
            return newAttributes
        }
        
    }
    
    struct Colors {
        
        static let transparent = UIColor.clearColor()
        static let black = UIColor(hex: 0x000000)
        static let white = UIColor(hex: 0xffffff)
        static let backgroundColor = UIColor(hex: 0xf9f9f9)
        static let nightBlue = UIColor(hex: 0x1d2028)
        static let lightGreyBlue = UIColor(hex: 0xcccff0)
        static let darkGreyBlue = UIColor(hex: 0x333745)
        static let greyBlue = UIColor(hex: 0x71737d)
        static let invalidRed = UIColor(hex: 0xea2e49)
        static let validGreen = UIColor(hex: 0x3fb34f)
        static let actionGreen = UIColor(hex: 0x41ccb4)
        static let actionPurple = UIColor(hex: 0x596799)
        static let extraDarkGrey = UIColor(hex: 0x333333)
        static let darkGrey = UIColor(hex: 0x666666)
        static let softGrey = UIColor(hex: 0x999999)
        static let lightGrey = UIColor(hex: 0xcccccc)
        static let veryLightGrey = UIColor(hex: 0xeeeeee)
        static let extraLightGrey = UIColor(hex: 0xf4f4f4)
        
    }
    
    enum Fonts {
        
        private enum Names: String {
            case Light = "OpenSans-Light"
            case Regular = "OpenSans"
            case Semibold = "OpenSans-Semibold"
            case Bold = "OpenSans-Bold"
            case Extrabold = "OpenSans-Extrabold"
        }
        
        enum Sizes: CGFloat {
            case small = 12
            case medium = 14
            case almostLarge = 15
            case large = 16
            case extraLarge = 18
            case almostUltraLarge = 19
            case ultraLarge = 20
            case megaLarge = 24
            case extraHuge = 27
            case ultraHuge = 42
        }
        
        struct Kernings {
            static let verySmall: CGFloat = 0.2
            static let small: CGFloat = 0.5
            static let medium: CGFloat = 0.9
            static let large: CGFloat = 1.2
            static let veryLarge: CGFloat = 1.5
        }
        
        private static func fontWithName(name: String, size: CGFloat) -> UIFont {
            if let font = UIFont(name: name, size: size) {
                return font
            }
            return UIFont.systemFontOfSize(UIFont.systemFontSize())
        }
        
        static func lightFontWithSize(size: CGFloat) -> UIFont {
            return fontWithName(Names.Light.rawValue, size: size)
        }
        
        static func regularFontWithSize(size: CGFloat) -> UIFont {
            return fontWithName(Names.Regular.rawValue, size: size)
        }
        
        static func semiboldFontWithSize(size: CGFloat) -> UIFont {
            return fontWithName(Names.Semibold.rawValue, size: size)
        }
        
        static func boldFontWithSize(size: CGFloat) -> UIFont {
            return fontWithName(Names.Bold.rawValue, size: size)
        }
        
        static func extraboldFontWithSize(size: CGFloat) -> UIFont {
            return fontWithName(Names.Extrabold.rawValue, size: size)
        }
    }
    
    struct Metrics {
        
        static let defaultDarkenFactor:CGFloat = Factors.Darken.strong
        static let defaultNavigationBarHeight:CGFloat = Views.NavigationBar.mediumNavigationBarHeight
        static let defaultBorderRadius:CGFloat = BordersRadii.medium
        static let defaultAnimationDuration = Durations.Animations.medium
        
        struct Views {
            struct NavigationBar {
                static let mediumNavigationBarHeight: CGFloat = 60
                static let smallNavigationBarHeight: CGFloat = 44
            }
        }
        
        struct Factors {
            struct Darken {
                static let light:CGFloat = 0.03
                static let medium:CGFloat = 0.05
                static let strong:CGFloat = 0.08
                static let veryStrong:CGFloat = 0.1
                static let extraStrong:CGFloat = 0.15
                static let ultraStrong:CGFloat = 0.20
            }
        }
        
        struct BordersRadii {
            static let small:CGFloat = 3
            static let medium:CGFloat = 5
            static let large:CGFloat = 10
        }
        
        struct Paddings {
            static let verySmall:CGFloat = 10
            static let almostSmall:CGFloat = 15
            static let small:CGFloat = 20
            static let almostMedium:CGFloat = 25
            static let medium:CGFloat = 30
        }
        
        struct LineSpacings {
            static let small:CGFloat = 4
            static let medium:CGFloat = 6
            static let large:CGFloat = 8
        }
        
        struct Durations {
            struct Animations {
                static let veryShort = 0.17
                static let short = 0.25
                static let medium = 0.32
                static let long = 0.40
            }
        }
    
    }

}