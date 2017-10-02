//
//  profileImageAesthetics.swift
//  TinderClone
//
//  Created by Jeremy Tay on 03/10/2017.
//  Copyright © 2017 Jeremy Tay. All rights reserved.
//

import UIKit

public class ProfilePicDisplay {
    class func profileBounds (image : UIImageView) {
        image.layer.cornerRadius = image.frame.size.width / 2
        image.clipsToBounds = true
        image.layer.borderWidth = CGFloat(3.0)
        image.layer.borderColor = UIColor.white.cgColor
    }
}

public class descBoxDisplay {
    class func descTextViewAppear (textView : UITextView) {
        let cornerRadius = textView.frame.width / 8
        textView.layer.cornerRadius = cornerRadius
    }
}

