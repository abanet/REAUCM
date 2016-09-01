//
//  DuracionView.swift
//  REAUCMTV
//
//  Created by Alberto Banet Masa on 28/7/16.
//  Copyright © 2016 UCM. All rights reserved.
//

import UIKit

@IBDesignable
class DuracionView: UIView {

  
    override func drawRect(rect: CGRect) {
      
      //// Color Declarations
      let color2 = UIColor(red: 0.739, green: 0.301, blue: 0.301, alpha: 0.7)
      
      //// Rectangle Drawing
      let rectanglePath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height))
      color2.setFill()
      rectanglePath.fill()

    }
  

}
