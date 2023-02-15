//
//  Constants.swift
//  Everything
//
//  Created by Fuxin Bi on 18/1/23.
//

import UIKit

struct K {
    static let IDCardHeight: Double = 3.375
    static let IDCardWidth: Double = 2.125
    static let IDCardRatio: Double = IDCardHeight / IDCardWidth
    
    static let iphone14Ratio: Double = 460 / 3.0
    
    static let defaultFontSize: CGFloat = 20
    static let titleFontSize: CGFloat = 40
    static let defaultCornorRadius: CGFloat = 30
    static let picViewCornorRadius: CGFloat = 100
    
    static let titleLabelHeight: Int = 65
    static let titleLabelWidth: Int = 210
    static let titleLabelCenterY: Int = 200
    
    static let picViewHeight: Int = 200
    static let picViewWidth: Int = 200
    static let picViewCenterY: Int = 300
    
    static let appViewHeight: Int = 100
    static let appViewWidth: Int = 180
    static let appViewCenterY: Int = 150
    
    static let buttonHeight: Int = 45
    static let buttonWidth: Int = 170
    
    
    static let appName = "Everything"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    
    
    /*
    struct BrandColors {
        static let pink = "#C780FA"
        static let lightPink = "#E3ACF9"
        static let yellow = "#FADA9D"
        static let lightYellow = "#FBF1D3"
    }*/
    
    struct BrandColors {
        static let talk5 = hexStringToUIColor(hex: "#2596BE")
        static let pink = hexStringToUIColor(hex: "#C780FA")
        static let lightPink = hexStringToUIColor(hex: "#E3ACF9")
        static let yellow = hexStringToUIColor(hex: "#FADA9D")
        static let lightYellow = hexStringToUIColor(hex: "#FBF1D3")
        static let lightBlue = hexStringToUIColor(hex: "#AEE2FF")
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}

var fontSize: CGFloat {
    let tempValue = 8.0
    if(UIDevice.current.userInterfaceIdiom == .pad){
        return tempValue * 3
    }else{
        return tempValue * 2
    }
}


func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    if ((cString.count) != 6) {
        return UIColor.gray
    }

    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
