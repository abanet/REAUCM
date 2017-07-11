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
  var imageStore: ImageStore!
  let stats = GoogleEstadisticas()

  var fullScreenPlayerViewController: AVPlayerViewController!
  var asset: AVAsset!
  var video: Video? {
    didSet {
      if let url = video?.urlVideo {
        asset = AVAsset(url: url as URL)
      }
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
      
      self.modalTransitionStyle = .flipHorizontal
      // Activar Swipe right para volver a la pantalla anterior
      let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
      swipeRight.direction = .right
      self.view.addGestureRecognizer(swipeRight)
      
      //fullScreenPlayerViewController.requiresLinearPlayback = false

      
    }
  
  override func viewWillAppear(_ animated: Bool) {
    // apuntar estadística
    stats.registrarEvento(id: rea.ucIdentifier, title: rea.title, type: "REA-iPAD")
    
    
    // Delegado y datasource que alimentarán la tabla de índice.
    capitulosTableView.delegate   = self
    capitulosTableView.dataSource = self
    
    
    lblTitle.text = rea.title
    lblCreador.text = rea.creator
    descripcionTextView.text = rea.description
    
    if let idPhoto = rea.fotoSeleccion!.photoID {
      if let imagenCache = imageStore.imageForKey(key: idPhoto) {
        self.reaImageView.image = imagenCache
      } else {
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
    }
    
  }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func handleGesture(){
    self.dismiss(animated: true, completion: nil)
  }

  @IBAction func volverPressed(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
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
    let playerItem = AVPlayerItem(asset: asset)
    let fullScreenPlayer = AVPlayer(playerItem: playerItem)
    
    
    fullScreenPlayerViewController!.player = fullScreenPlayer
    NotificationCenter.default.addObserver(self, selector: #selector(DetalleIpadViewController.playerDidFinishPlaying(_:)),
                                           name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: fullScreenPlayerViewController!.player!.currentItem)
    
    fullScreenPlayerViewController!.player?.play()
    present(fullScreenPlayerViewController, animated: true, completion: nil)
    stats.registrarEvento(id: video!.ucIdentifier, title: video!.title, type: "start-video-iPAD")
  }
  
  func playerDidFinishPlaying(_ note: Notification) {
    print("Video Finished")
    
    
    // Estadística de finalización de vídeo
    
    // Reseteamos el seekTime para que la próxima vez empieza desde cero.
    fullScreenPlayerViewController!.player?.seek(to: kCMTimeZero)
    stats.registrarEvento(id: video!.ucIdentifier, title: "Fin: \(video!.title)", type: "finished-video-iPAD")
    fullScreenPlayerViewController.dismiss(animated: true, completion: nil)
  }
  
  func configurarCeldaCapitulo(_ celda: CapituloTableViewCell, indexPath: IndexPath) -> CapituloTableViewCell {
    // Obtenemos nombre imagen que vamos a intentar cargar
    // Obtenemos el vídeo que estamos tratando
    let unidadDidactica = rea.unidades[indexPath.section]
    let video = unidadDidactica.videos[indexPath.row]
    
    
    if let idPhoto = video.miniatura?.photoID {
      if let imagenCache = imageStore.imageForKey(key: idPhoto) { // foto en caché?
        if celda.capituloImageView != nil {
          celda.capituloImageView.image = imagenCache
        }
      } else { // Cargamos la imagen de la celda
        video.miniatura!.obtenerImagen {
          [weak self](imageResult) -> Void in
          switch imageResult {
          case let . success(image):
            if let idPhoto = video.miniatura?.photoID {
              self?.imageStore.setImage(image: image, forKey: idPhoto)
            }
            DispatchQueue.main.async {
              if celda.capituloImageView != nil {
                celda.capituloImageView.image = image
              }
            }
            
          case let .failure(error):
            print("Error descargando imagen: \(error)")
          }
        }
      }
    }
    
    celda.lblCapituloTitle.text = video.title
    return celda
  }
}
