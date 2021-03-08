//
//  MarvelCollectionViewCell.swift
//  desafio-mobile-iOS
//
//  Created by Renato Mateus on 08/03/21.
//

import UIKit

public final class MarvelCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var filmPosterImageView: UIImageView!
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(white: 0.8, alpha: 0.15)
    }
    
    func configure(with viewModel: MarvelCollectionItemViewModel?) {
        if let posterURL = viewModel?.posterURL {
            self.filmPosterImageView.setImage(fromURL: posterURL)
        }
    }
}

extension MarvelCollectionViewCell: NibLoadableView { }

extension MarvelCollectionViewCell: ReusableView { }


