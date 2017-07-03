//
//  ReaIpadViewController.swift
//  REAUCMTV
//
//  Created by Alberto Banet Masa on 27/6/17.
//  Copyright © 2017 UCM. All rights reserved.
//

import UIKit

class ReaIpadViewController: UIViewController {

  
  @IBOutlet var bannerView: UIImageView!
  @IBOutlet var lblTitle: UILabel!
  @IBOutlet var lblDescripcion: UILabel!
  
  var almacenRea: VideoStore!
  var listaRea = [Rea]()
  var imageStore: ImageStore!
  
  @IBOutlet var reaCollectionView: UICollectionView!
  static let idCell = "cellMoocID"
  
  
  override func viewDidLoad() {
        super.viewDidLoad()
    
    
    // Lectura de vídeos y actualización del collectionView cuando acaba la descarga.
    almacenRea.leerDatosRea() { [weak self] reas in
      self?.listaRea = reas
      self?.reaCollectionView?.reloadData()
      self?.mostrarPantalla(conRea:0)
    }
    
    reaCollectionView.dataSource = self
    reaCollectionView.delegate   = self
    reaCollectionView.backgroundColor = .clear
    
  }
  

  
  // Cambia la imagen de background con la del índice pasado como parámetro.
  func mostrarPantalla(conRea: Int) {
    let sectionRea = reaEnSeccion(0)
    let rea = sectionRea[0]
    
    // En el ipad se dejan fijos título y descripción de la pantalla principal.
    //lblTitle.text = rea.title
    //lblDescripcion.text = rea.description
    
    rea.fotoLarga!.obtenerImagen {
      [weak self](imageResult) -> Void in
      switch imageResult {
      case let . success(image):
        DispatchQueue.main.async {
          self?.bannerView.image = image
          self?.bannerView.alpha = 0
          UIView.animate(withDuration: 1.0, animations: {
            self?.bannerView.alpha = 1.0
          })
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
    

  
}

// MARK: Métodos privados
private extension ReaIpadViewController {
  // Preparado para cuando haya diferentes secciones
  func reaEnSeccion(_ seccion: Int) -> [Rea] {
    return self.listaRea
  }
}

// MARK: UICollectionViewDataSource
extension ReaIpadViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return listaRea.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = reaCollectionView.dequeueReusableCell(withReuseIdentifier: ReaIpadViewController.idCell, for: indexPath) as! ReaCollectionViewCell
    return self.configurarCeldaRea(cell, indexPath: indexPath)
  }
  
  func configurarCeldaRea(_ celda: ReaCollectionViewCell, indexPath: IndexPath) -> ReaCollectionViewCell {
    // Lo dejamos preparado para cuando haya varias secciones.
    let sectionRea = reaEnSeccion(indexPath.section)
    let rea = sectionRea[indexPath.item]
    
    rea.fotoSeleccion!.obtenerImagen {
      (imageResult) -> Void in
      switch imageResult {
      case let . success(image):
        DispatchQueue.main.async {
          celda.reaImageView.image = image
        }
      case let .failure(error):
        print("Error descargando imagen: \(error)")
      }
    }
    celda.lblTitle.text = rea.title
    return celda
  }
  
}


// MARK: UICollectionViewDelegate
extension ReaIpadViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print("Camino de indexPath: \(indexPath.row)")
    if let destinationViewController = self.storyboard?.instantiateViewController(withIdentifier: "ReaIDController") as? DetalleIpadViewController {
      destinationViewController.rea = listaRea[indexPath.item]
      destinationViewController.imageStore = imageStore
      self.present(destinationViewController, animated: true, completion: nil)
    }
    
  }
}
