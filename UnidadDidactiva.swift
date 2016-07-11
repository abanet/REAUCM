//
//  UnidadDidactiva.swift
//  REAUCMTV
//
//  Created by Alberto Banet Masa on 7/7/16.
//  Copyright © 2016 UCM. All rights reserved.
//

import Foundation

class UnidadDidactica {
  var ucIdentifier: String!
  var title: String!
  var description: String!
  var type: String!
  var videos: [Video]!
  
  init(fromJson json: JSON!) {
    guard json != nil else {
      return
    }
    
    ucIdentifier  = json["uc.identifier"].stringValue
    title         = json["dc.title"].stringValue
    description   = json["dc.description"].stringValue
    type          = json["dc.type"].stringValue
    
    let videosArray = json["uc.videos"].arrayValue
    videos = [Video]()
    for videoJson in videosArray {
      let unVideo = Video(fromJson: videoJson)
      videos.append(unVideo)
    }
  }
  
  
  
}