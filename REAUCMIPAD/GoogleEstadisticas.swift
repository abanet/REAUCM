//
//  GoogleEstadisticas.swift
//  REAUCMTV
//
//  Created by Alberto Banet Masa on 4/7/17.
//  Copyright © 2017 UCM. All rights reserved.
//

import Foundation
import FirebaseAnalytics

let GoogleTrackingID = "UA-83832384-1"

class GoogleEstadisticas {
  
  init() {
    
  }
  
  func registrarInicioSesion() {
    Analytics.logEvent(AnalyticsEventAppOpen, parameters: nil)
  }
  
  func registrarEvento(id: String, title: String, type: String) {
    Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
      AnalyticsParameterItemID:id as NSObject,
      AnalyticsParameterItemName:title as NSObject,
      AnalyticsParameterContentType: type as NSObject])
  }
//  let gai: GAI?
//  let tracker: GAITracker?
//  
//  init() {
//    guard
//      let gai = GAI.sharedInstance(),
//      let tracker = gai.defaultTracker
//      else { self.gai = nil; self.tracker = nil; return }
//    
//    self.gai = gai
//    gai.tracker(withTrackingId: GoogleTrackingID)
//    gai.trackUncaughtExceptions = true
//    self.tracker = tracker
//    
//  }
//
//  func registrarInicioSesion() {
//    tracker?.set(kGAIScreenName, value: "Sesiones Abiertas (iOS-iPAD)")
//    if let builder = GAIDictionaryBuilder.createScreenView() {
//      tracker?.send(builder.build() as [NSObject : AnyObject])
//      
//    }
//  }
//  
//  func registrarEvento(descripcion: String, accion: String, rea: Rea) {
//    if let builder = GAIDictionaryBuilder.createEvent(withCategory: descripcion, action: accion, label: "\(rea.ucIdentifier):\(rea.title)", value: 1) {
//      tracker?.send(builder.build() as [NSObject : AnyObject])
//    }
//  }
  
  
  
  
}
