//
//  VideoTime.swift
//  REAUCMTV
//
//  Created by Alberto Banet Masa on 1/9/16.
//  Copyright © 2016 UCM. All rights reserved.
//

// Clase encargada de almacenar de forma local los tiempos transcurridos en el visionado de los vídeos.
// Se almacena el tiempo total del vídeo para facilitar el cálculo del % de visionado.
// Con la información de VideoTime de un vídeo se podrá dibujar la vista DuracionView.

import UIKit

// LUIS
class VideoTime: NSObject {
  
  // MARK: Properties
  var ucIdentifier: String
  var duracion: Float
  var transcurrido: Float
  
  // MARK: Archivo para almacenar el array de tiempos
  static let DocumentsDirectorio = NSFileManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask).first!
  static let ArchiveURL = DocumentsDirectorio.URLByAppendingPathComponent("videosTimes")
  
  // MARK: Types
  struct PropertyKey {
    static let ucIdentifierKey = "ucIdentifier"
    static let duracionKey = "duracion"
    static let transcurridoKey = "transcurrido"
  }
  
  
  // MARK: Inicialización
  init?(ucIdentifier: String, duracion: Float, transcurrido: Float) {
    self.ucIdentifier = ucIdentifier
    self.duracion = duracion
    self.transcurrido = transcurrido
    
    super.init()
    
    if ucIdentifier.isEmpty {
      return nil
    }
  }
  
}


// Personalizamos el protocolo CustomStringConvertible
extension VideoTime {
  override var description: String {
    return "ucIdentifier: \(self.ucIdentifier) <-> duración: \(self.duracion) <-> transcurrido: \(self.transcurrido)"
  }
}