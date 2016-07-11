//
//  ViewController.swift
//  REAUCMTV
//
//  Created by Alberto Banet Masa on 4/7/16.
//  Copyright © 2016 UCM. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  var videoStore: VideoStore!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    videoStore.leerDatosRea()
    print("datos leídos")
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

