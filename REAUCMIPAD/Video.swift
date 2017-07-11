//
//  Video.swift
//  REAUCMTV
//
//  Created by Alberto Banet Masa on 10/7/17.
//  Copyright © 2017 UCM. All rights reserved.
//

import Foundation
import CoreMedia
import Firebase

enum ElementType {
  case collection
  case movingImage
}

class Video: NSObject {
  var ucIdentifier: String!
  var title: String!
  var descripcion: String!
  var type: String!
  var miniatura: Photo?
  var urlVideo: URL!
  var identifierIOS: String!
  
  override var description: String {
    return("Descripción de vídeo: uc.identifier:\(self.ucIdentifier) , dc.title:\(self.title)")
  }
  
  init(fromJson json: JSON!){
    super.init()
    
    guard json != nil else {
      return
    }
    ucIdentifier  = json["uc.identifier"].stringValue
    title         = json["dc.title"].stringValue
    descripcion   = json["dc.description"].stringValue
    type          = json["dc.type"].stringValue
    
    // Obtenemos la url para iOS
    // 08/11/2016
    if let urlsRecurso = json["dc.identifier"].dictionary {
      let url = urlsRecurso["uc.ios"]!.string
      identifierIOS = url
    }
    
    getURLVideoFirebase(forRecurso: identifierIOS) {
      [weak self] url in
      if url != nil {
        self?.urlVideo = url
      }
    }
    print("urlleida:\(urlVideo)")
    
    
    // Establecemos la imagen miniatura
    //print("URL: \(reaAPI.baseURLImagenes)miniatura_\(ucIdentifier!)")
    if let identificador = ucIdentifier {
      miniatura = Photo(photoID: "miniatura_" + identificador + ".png", remoteURL: URL(string: reaAPI.baseURLImagenes + "miniatura_\(identificador).png")!)
    }
  }
  
  // función original que toma datos de ucm
  func getURLVideo(forRecurso: String) -> URL {
    return URL(string: reaAPI.baseURLStringVideos + identifierIOS + reaAPI.finURLStringVideos)!
  }
  
  func getURLVideoFirebase(forRecurso recurso: String, completion: @escaping (URL?)->Void) {
    let storage = Storage.storage()
    let storageRef = storage.reference()
    let videoRef = storageRef.child("videos/\(recurso)")
    videoRef.downloadURL { url, error in
      if error != nil {
        print(error.debugDescription)
      } else {
        print("completion to: \(String(describing: url?.description))")
        completion(url)
      }
    }
  }
  
}

