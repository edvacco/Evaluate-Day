//
//  BlackNewCardTheme.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 25/10/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

struct BlackNewCardTheme: NewCardStyle {
    // General controller
    var background: UIColor { return UIColor.black }
    var barColor: UIColor { return UIColor.black }
    var barTint: UIColor { return UIColor.white }
    var barTitleFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .demiBold) }
    var barLargeTitleFont: UIFont { return UIFont.avenirNext(size: largeTitleFontSize, weight: .demiBold) }
    
    // Card source node
    var sourceTitleColor: UIColor { return UIColor.white }
    var sourceSubtitleColor: UIColor { return UIColor.salmon }
    var sourceTitleFont: UIFont { return UIFont.avenirNext(size: 26.0, weight: .bold) }
    var sourceSubtitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var sourceUntouchableColor: UIColor { return UIColor.lightGray }
}
