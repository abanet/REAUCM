//
//  AppDelegate.swift
//  REAUCMIPAD
//
//  Created by Alberto Banet Masa on 27/6/17.
//  Copyright © 2017 UCM. All rights reserved.
//

import UIKit
import Firebase



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  /*
   let appConfiguration = AppConfiguration(
    clientIdentifier: "e51d9db7fbbb36322e772a0c2eac64cf5e2880f4",
    clientSecret: "4+X5LSOuDqcc2i15klIdXn6QQM/JhNNiPIUONjzGxPaBQQi3KI9gqrPBr/VVyYvqMfQX2tcmQt/Ya4HmM58CqhR+Mu1c1CbAdeIXnCO2dJ5s/dI08xoycWSc34rXzvA2",
    scope: [.Public])
 */

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    // Activación Firebase
    FirebaseApp.configure()
    
    // Activamos estadísticas
    GATracker.setup(tid: "UA-83832384-1") // id para iosucmovil@gmail.com, REAUCMTV
    GATracker.sharedInstance.screenView(screenName: "Sesiones Abiertas (iPADTV)", customParameters: nil)
    // Activamos estadísticas
    /*let stats = GoogleEstadisticas()
    stats.registrarInicioSesion()*/
    
    
    
    // Creación de los datos REA
    let rootViewController = window!.rootViewController as! ReaIpadViewController
    let reaIpadViewController = rootViewController
    reaIpadViewController.almacenRea = VideoStore()
    
    let imageStore = ImageStore()
    reaIpadViewController.imageStore = imageStore
    
    
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

