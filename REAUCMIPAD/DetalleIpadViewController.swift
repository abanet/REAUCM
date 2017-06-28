//
//  DetalleIpadViewController.swift
//  REAUCMTV
//
//  Created by Alberto Banet Masa on 28/6/17.
//  Copyright © 2017 UCM. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class DetalleIpadViewController: UIViewController {

  var rea: Rea!
  

  var fullScreenPlayerViewController: AVPlayerViewController!
  var asset: AVAsset!
  var video: Video! {
    didSet {
      asset = AVAsset(url: self.video.urlVideo as URL)
    }
  }
  
  @IBOutlet var capitulosTableView: UITableView!
  static let cellID = "cellCapituloRea"
  
  @IBOutlet var reaImageView: UIImageView!
  @IBOutlet var lblTitle: UILabel!
  @IBOutlet var lblCreador: UILabel!
  @IBOutlet var descripcionTextView: UITextView!
  
  
  
    override func viewDidLoad() {
        super.viewDidLoad()

      guard rea != nil else { return } // no vaya a ser...
      
      // Inicialización AVPlayerViewController
      fullScreenPlayerViewController = AVPlayerViewController()
      fullScreenPlayerViewController.showsPlaybackControls = true
      
      //fullScreenPlayerViewController.requiresLinearPlayback = false

        // Do any additional setup after loading the view.
    }
  
  override func viewWillAppear(_ animated: Bool) {
    // Delegado y datasource que alimentarán la tabla de índice.
    capitulosTableView.delegate   = self
    capitulosTableView.dataSource = self
    
    
    lblTitle.text = rea.title
    lblCreador.text = rea.creator
    descripcionTextView.text = rea.description
    
    rea.fotoSeleccion!.obtenerImagen {
      [weak self] (imageResult) -> Void in
      switch imageResult {
      case let . success(image):
        DispatchQueue.main.async {
          // cuidado con memory leaks
          self?.reaImageView.image = image
        }
        
      case let .failure(error):
        print("Error descargando imagen: \(error)")
      }
    }
  }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  @IBAction func volverPressed(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
}

// MARK: UITableViewDelegate
extension DetalleIpadViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let l = UILabel()
    l.textColor = .white
    l.numberOfLines = 0
    l.text = rea.unidades[section].title.uppercased()
    return l
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 80.0
  }
  
  
}

// MARK: UITableViewDataSource
extension DetalleIpadViewController: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return rea.unidades.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return rea.unidades[section].videos.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = capitulosTableView.dequeueReusableCell(withIdentifier: DetalleIpadViewController.cellID) as! CapituloTableViewCell
    
    // Obtenemos el vídeo que estamos tratando
    let unidadDidactica = rea.unidades[indexPath.section]
    let video = unidadDidactica.videos[indexPath.row]
    self.video = video // actualizamos la variable de clase para actualizar el asset.
    
   return self.configurarCeldaCapitulo(cell, indexPath: indexPath)
    
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // Obtenemos el vídeo que estamos tratando
    let unidadDidactica = rea.unidades[indexPath.section]
    let video = unidadDidactica.videos[indexPath.row]
    
    // actualizamos la variable de clase para actualizar el asset.
    self.video = video  //esto no se guarda
    
    //BARRASTIEMPO
    //MyVariables.idVideo = video.ucIdentifier
    
    self.reproducirVideo()
  }
  
  func reproducirVideo() {
    print("Preparando para visualizar \(self.video.urlVideo)")
    let playerItem = AVPlayerItem(asset: asset)
    let fullScreenPlayer = AVPlayer(playerItem: playerItem)
    
    
    fullScreenPlayerViewController!.player = fullScreenPlayer
    /*NotificationCenter.default.addObserver(self, selector: #selector(DetalleReaViewController.playerDidFinishPlaying(_:)),
                                           name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: fullScreenPlayerViewController!.player!.currentItem)
    */
    fullScreenPlayerViewController!.player?.play()
    present(fullScreenPlayerViewController, animated: true, completion: nil)
  }
  
  func configurarCeldaCapitulo(_ celda: CapituloTableViewCell, indexPath: IndexPath) -> CapituloTableViewCell {
    // Cargamos la imagen de la celda
    video.miniatura!.obtenerImagen {
      (imageResult) -> Void in
      switch imageResult {
      case let . success(image):
        DispatchQueue.main.async {
          celda.capituloImageView.image = image
        }
        
      case let .failure(error):
        print("Error descargando imagen: \(error)")
      }
    }
    celda.lblCapituloTitle.text = video.title
    return celda
  }
}
