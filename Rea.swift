//
//  Rea.swift
//  REAUCMTV
//
//  Created by Alberto Banet Masa on 7/7/16.
//  Copyright © 2016 UCM. All rights reserved.
//

import Foundation


class Rea {
  var ucIdentifier: String!
  var title: String!
  var description: String!
  var date: String!
  var creator: String!
  var contributor: String!
  var type: String!
  var unidades: [UnidadDidactica]!
  
  init(fromJson json: JSON!) {
    guard json != nil else {
      return
    }
    
    ucIdentifier  = json["uc.identifier"].stringValue
    title         = json["dc.title"].stringValue
    description   = json["dc.description"].stringValue
    date          = json["dc.date"].stringValue
    creator       = json["dc.creator"].stringValue
    contributor   = json["dc.contributor"].stringValue
    type          = json["dc.type"].stringValue
    unidades      = [UnidadDidactica]()
    let unidadesArray = json["uc.unidades"].arrayValue
    for unidadJson in unidadesArray {
      let unaUnidad = UnidadDidactica(fromJson: unidadJson)
      unidades.append(unaUnidad)
    }
    
  }
}