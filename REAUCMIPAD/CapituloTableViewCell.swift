//
//  CapituloTableViewCell.swift
//  REAUCMTV
//
//  Created by Alberto Banet Masa on 28/6/17.
//  Copyright © 2017 UCM. All rights reserved.
//

import UIKit

class CapituloTableViewCell: UITableViewCell {

  @IBOutlet var capituloImageView: UIImageView!
  @IBOutlet var lblCapituloTitle: UILabel!
  
  //var photoId: String?
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

  override func prepareForReuse() {
    self.capituloImageView = nil
  }
}
