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
  
  override func viewDidLoad() {
        super.viewDidLoad()

    // Lectura de vídeos y actualización del collectionView cuando acaba la descarga.
    almacenRea.leerDatosRea() { [weak self] reas in
      self?.listaRea = reas
      //self.reaCollectionView?.reloadData()
      self?.mostrarPantalla(conRea:0)
    }
  }

  
  // Cambia la imagen de background con la del índice pasado como parámetro.
  func mostrarPantalla(conRea: Int) {
    let sectionRea = reaEnSeccion(0)
    let rea = sectionRea[0]
    lblTitle.text = rea.title
    lblDescripcion.text = rea.description
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
  
  
  

}

// MARK: Métodos privados
private extension ReaIpadViewController {
  // Preparado para cuando haya diferentes secciones
  func reaEnSeccion(_ seccion: Int) -> [Rea] {
    return self.listaRea
  }
}
