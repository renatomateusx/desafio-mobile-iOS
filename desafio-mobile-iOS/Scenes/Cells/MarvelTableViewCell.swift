//
//  MarvelTableViewCell.swift
//  desafio-mobile-iOS
//
//  Created by Renato Mateus on 08/03/21.
//

import UIKit

class MarvelTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    func configure(with viewModel: MarvelCollectionItemViewModel?) {
        titleLabel.text = viewModel?.title ?? ""
        overviewLabel.text = viewModel?.overview ?? ""
        if let posterURL = viewModel?.posterURL {
            self.posterImageView.setImage(fromURL: posterURL)
        } else {
            self.posterImageView.image = nil
        }
    }
}

extension MarvelTableViewCell: NibLoadableView { }

extension MarvelTableViewCell: ReusableView { }
