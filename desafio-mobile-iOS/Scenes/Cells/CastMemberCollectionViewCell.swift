//
//  CastMemberCollectionViewCell.swift
//  desafio-mobile-iOS
//
//  Created by Renato Mateus on 08/03/21.
//

import UIKit

class CastMemberCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileInitialsLabel: UILabel!
    
    
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    fileprivate func setupUI() {
        self.containerView.layer.cornerRadius = 40.0
        self.containerView.layer.masksToBounds = true
        self.profileImageView.contentMode = .scaleAspectFill
    }
    
    func configure(with castMember: CastMemberItemViewModel?) {
        if let castMember = castMember {
            self.roleLabel.text = castMember.name
            self.profileInitialsLabel.text = castMember.nameInitials
            self.profileImageView.image = nil
            if let imageURL = castMember.profileImageURL {
                self.profileImageView.setImage(fromURL: imageURL)
            }
            self.nameLabel.text = castMember.name
        }
    }
}

extension CastMemberCollectionViewCell: NibLoadableView { }

extension CastMemberCollectionViewCell: ReusableView { }
