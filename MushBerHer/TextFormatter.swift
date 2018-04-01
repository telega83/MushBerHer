//
//  TextFormatter.swift
//  MushBerHer
//
//  Created by Oleg on 17/11/2017.
//  Copyright © 2017 telega. All rights reserved.
//

import Foundation
import UIKit

class TextFormatter {
    
    private var _text: String
    
    init(text: String) {
        _text = text
    }
    
    private func applyTraitsFromFont(_ f1: UIFont, to f2: UIFont) -> UIFont? {
        let t = f1.fontDescriptor.symbolicTraits
        if let fd = f2.fontDescriptor.withSymbolicTraits(t) {
            return UIFont.init(descriptor: fd, size: 0)
        }
        return nil
    }
    
    func getAttributedText() -> NSMutableAttributedString {
        let data = _text.data(using: .unicode)!
        let att = try! NSAttributedString.init(
            data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        let attrText = NSMutableAttributedString(attributedString:att)
        
        attrText.enumerateAttribute(
            NSFontAttributeName,
            in:NSMakeRange(0, attrText.length),
            options:.longestEffectiveRangeNotRequired) { value, range, stop in
                let f1 = value as! UIFont
                let f2 = UIFont(name:"Helvetica", size:15)!
                if let f3 = applyTraitsFromFont(f1, to:f2) {
                    attrText.addAttribute(
                        NSFontAttributeName, value:f3, range:range)
                }
        }
        return attrText
    }
}
