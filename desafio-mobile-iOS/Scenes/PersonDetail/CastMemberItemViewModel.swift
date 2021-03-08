//
//  CastMemberItemViewModel.swift
//  desafio-mobile-iOS
//
//  Created by Renato Mateus on 08/03/21.
//


import UIKit
public struct CastMemberItemViewModel {
    private let member: MarvelCast
    
    init (withMember member: MarvelCast){
        self.member = member
    }
    
    var profileImageURL: URL? {
        if let path = member.thumbnail {
            return URL(string: "\(path.path).\(path.extension)")
        }
        return nil
    }
    
    var nameInitials: String {
        let initials = self.member.name.components(separatedBy: " ").reduce("") { (string, nextWord) -> String in
            guard nextWord.count > 0 else { return string }
            return string + nextWord.prefix(1).uppercased()
        }
        return String(initials.prefix(3))
    }
    
    var characterName: String? {
        return member.name
    }
    
    var name: String? {
        return member.name
    }
}

