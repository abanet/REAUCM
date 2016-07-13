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
  
  
  init(fromJson json: JSON!){
    guard json != nil else {
      return
    }
    ucIdentifier  = json["uc.identifier"].stringValue
    title         = json["dc.title"].stringValue
    description   = json["dc.description"].stringValue
    type          = json["dc.type"].stringValue
    //let ulrsRecurso = json["dc.identifier"].object //ver cómo sacar de aquí la url
    identifierIOS = "sdfas"
  }
  
}