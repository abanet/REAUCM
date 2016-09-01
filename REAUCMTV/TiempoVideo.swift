//
//  TiemposDePosicion.swift
//  REAUCMTV
//
//  Created by Alberto Banet Masa on 27/7/16.
//  Copyright © 2016 UCM. All rights reserved.
//

import UIKit

class TiempoVideo: NSObject, NSCoding {
  
  struct Keys {
    static let Duracion = "duracion"
    static let Transcurrido = "transcurrido"
  }
  
  var duracion: Float?
  var transcurrido: Float?
    
  init?(duracion: Float?, transcurrido: Float?) {
    self.duracion = duracion
    self.transcurrido = transcurrido
    super.init()
  }
  
  
  required convenience init?(coder aDecoder: NSCoder) {
    let miDuracion = aDecoder.decodeFloatForKey(Keys.Duracion)
    let miTranscurrido = aDecoder.decodeFloatForKey(Keys.Transcurrido)
    self.init(duracion: miDuracion, transcurrido: miTranscurrido)
  }
  
  
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeFloat(duracion!, forKey: Keys.Duracion)
    aCoder.encodeFloat(transcurrido!, forKey: Keys.Transcurrido)
  }

  func tiemposAsignados() -> Bool {
    
    if duracion != nil && transcurrido != nil {
      return true
    }
    
    return false
    
  }
  
  
}
