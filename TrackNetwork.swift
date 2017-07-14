//
//  TrackNetwork.swift
//  REAUCMTV
//
//  Created by Alberto Banet Masa on 12/7/17.
//  Copyright © 2017 UCM. All rights reserved.
//
// Permite seguir la pista a la conexión de red.

import AFNetworking

class TrackNetwork {
  
  let NetworkReachabilityChanged = NSNotification.Name("NetworkReachabilityChanged")
  var previousNetworkReachabilityStatus: AFNetworkReachabilityStatus = .unknown
  var reachableStatusBool: Bool = false
  
  init() {
    AFNetworkReachabilityManager.shared().startMonitoring()
    AFNetworkReachabilityManager.shared().setReachabilityStatusChange {  (status) in
      let reachabilityStatus = AFStringFromNetworkReachabilityStatus(status)
      var reachableOrNot = ""
      var networkSummary = ""
      
      switch (status) {
      case .reachableViaWWAN, .reachableViaWiFi:
        // Reachable.
        reachableOrNot = "Reachable"
        networkSummary = "Connected to Network"
        self.reachableStatusBool = true
      default:
        // Not reachable.
        reachableOrNot = "Not Reachable"
        networkSummary = "Disconnected from Network"
        self.reachableStatusBool = false
      }
      
      // Any class which has observer for this notification will be able to report loss of network connection
      // successfully.
      
      if (self.previousNetworkReachabilityStatus != .unknown && status != self.previousNetworkReachabilityStatus) {
        NotificationCenter.default.post(name: self.NetworkReachabilityChanged, object: nil, userInfo: [
          "reachabilityStatus" : "Connection Status : \(reachabilityStatus)",
          "reachableOrNot" : "Network Connection \(reachableOrNot)",
          "summary" : networkSummary,
          "reachableStatus" : self.reachableStatusBool
          ])
      }
      self.previousNetworkReachabilityStatus = status
    }
  }
  
  func addObserverToNetwork(vc: UIViewController) {
    NotificationCenter.default.addObserver(forName: NetworkReachabilityChanged, object: nil, queue: nil, using: {
      (notification) in
      if let userInfo = notification.userInfo {
        if let messageTitle = userInfo["summary"] as? String, let reachableOrNot = userInfo["reachableOrNot"] as? String, let reachableStatus = userInfo["reachabilityStatus"] as? String {
          let isReachable = userInfo["reachableStatus"] as! Bool
          if isReachable {
            vc.viewDidLoad()
          } else {
            //let messageFullBody = "\(reachableOrNot)\n\(reachableStatus)"
            let titulo = "Detectados problemas de conexión"
            let mensaje = "Parece que hay problemas con la conexión a internet. Asegúrese de que está conectado a una red válida."
            let alertController = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(OKAction)
            vc.present(alertController, animated: true, completion: nil)
          } 
        }
      }
    })
  }
  
}
