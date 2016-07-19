//
//  Video.swift
//  REAUCMTV
//
//  Created by Alberto Banet Masa on 7/7/16.
//  Copyright © 2016 UCM. All rights reserved.
//

import Foundation

enum ElementType {
  case Collection
  case MovingImage
}

class Video {
  var ucIdentifier: String!
  var title: String!
  var description: String!
  var type: String!
  var identifierIOS: String! // url para ios
  var miniatura: Photo?
  
  
  init(fromJson json: JSON!){
    guard json != nil else {
      return
    }
    ucIdentifier  = json["uc.identifier"].stringValue
    title         = json["dc.title"].stringValue
    description   = json["dc.description"].stringValue
    type          = json["dc.type"].stringValue
    
    // Obtenemos la url para iOS
    let urlsRecurso = json["dc.identifier"].object
    identifierIOS = urlsRecurso["uc.ios"] as! String
    
    // Establecemos la imagen miniatura
    miniatura = Photo(photoID: "miniatura_" + ucIdentifier + ".png", remoteURL: NSURL(string: reaAPI.baseURLImagenes + "miniatura_\(ucIdentifier).png")!)
  }
  
}