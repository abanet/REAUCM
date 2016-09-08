//
//  Video.swift
//  REAUCMTV
//
//  Created by Alberto Banet Masa on 7/7/16.
//  Copyright © 2016 UCM. All rights reserved.
//

import Foundation
import CoreMedia

enum ElementType {
  case Collection
  case MovingImage
}

class Video: NSObject {
  var ucIdentifier: String!
  var title: String!
  var descripcion: String!
  var type: String!
  var miniatura: Photo?
  var urlVideo: NSURL!
  var identifierIOS: String!
  
override var description: String {
    return("Descripción de vídeo: uc.identifier:\(self.ucIdentifier) , dc.title:\(self.title)")
  }

  init(fromJson json: JSON!){
    guard json != nil else {
      return
    }
    ucIdentifier  = json["uc.identifier"].stringValue
    title         = json["dc.title"].stringValue
    descripcion   = json["dc.description"].stringValue
    type          = json["dc.type"].stringValue
    
    // Obtenemos la url para iOS
    let urlsRecurso = json["dc.identifier"].object
    identifierIOS = urlsRecurso["uc.ios"] as! String
    
    urlVideo = NSURL(string: reaAPI.baseURLStringVideos + identifierIOS + reaAPI.finURLStringVideos)
    
    
    // Establecemos la imagen miniatura
    miniatura = Photo(photoID: "miniatura_" + ucIdentifier + ".png", remoteURL: NSURL(string: reaAPI.baseURLImagenes + "miniatura_\(ucIdentifier).png")!)
    
  }
  
  
  
}