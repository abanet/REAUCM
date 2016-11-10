//
//  GestorTiempos.swift
//  REAUCMTV
//
//  Created by Alberto Banet Masa on 12/9/16.
//  Copyright © 2016 UCM. All rights reserved.
//

//BARRASTIEMPO
import Foundation


//class GestorTiempos: NSObject {
//
// var tiempos: [String:VideoTime]
//  
// init (id:String){
//  
//  // Cogemos los datos de tiempo del NSUserDefaults
//  tiempos = [String:VideoTime]()
//  
//  var id = ""
//
//  for key in NSUserDefaults.standardUserDefaults().dictionaryRepresentation().keys {
//    print(key)
//    
//    if key.containsString(MyVariables.keyTiempoTotal) {
//      id = (key as NSString).substringFromIndex(MyVariables.keyTiempoTotal.characters.count)
//      let duracion = NSUserDefaults.standardUserDefaults().floatForKey(key)
//      if let videoTime = tiempos[id] {
//        // existe ya un tiempo para este id
//        videoTime.duracion = duracion
//      } else {
//        let newVideoTime = VideoTime(ucIdentifier: id, duracion: duracion, transcurrido: 0.0)
//        tiempos[id] = newVideoTime
//      }
//      
//    } else if key.containsString(MyVariables.keyTranscurrido) {
//      id = (key as NSString).substringFromIndex(MyVariables.keyTranscurrido.characters.count)
//      let transcurrido = NSUserDefaults.standardUserDefaults().floatForKey(key)
//      if let videoTime = tiempos[id] {
//        // existe ya un tiempo para este id
//        videoTime.transcurrido = transcurrido
//      } else {
//        let newVideoTime = VideoTime(ucIdentifier: id, duracion: 0.0, transcurrido: transcurrido)
//        tiempos[id] = newVideoTime
//      }
//    } else {
//      // key no interesante: no tratada
//      
//    }
//    
//  }
//  
//  print("Tiempos leídos por gestor: \(tiempos)")
//  
//  }
//  
//  // Graba la variable de clase tiempos a NSUserDefaults
//  func updateGestorTiempo() {
//    for (key, videoTime) in tiempos {
//      let keyDuracion = MyVariables.keyTiempoTotal + key
//      let keyTranscurrido = MyVariables.keyTranscurrido + key
//      NSUserDefaults.standardUserDefaults().setFloat (videoTime.duracion, forKey: keyDuracion)
//      NSUserDefaults.standardUserDefaults().setFloat (videoTime.transcurrido, forKey: keyTranscurrido)
//    }
//  }
//  
//  
//}