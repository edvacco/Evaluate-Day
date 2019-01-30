//
//  UserInformationNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 16/03/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class UserInformationNode: ASCellNode {
    // MARK: - UI
    var editButton = ASButtonNode()
    var userPhoto = ASImageNode()
    var userName: ASTextNode!
    var userEmail: ASTextNode!
    var userBio: ASTextNode!
    var userWeb: ASTextNode!
    var firstSeparator: ASDisplayNode!
    var secondSeparator: ASDisplayNode!
    var facebookButton: ASButtonNode!
    var facebookCover: ASDisplayNode!
    var facebookDisclaimer: ASTextNode!
    
    // MARK: - Variables
    var editMode = false
    var nodeDidLoad: (() -> Void)?
    
    // MARK: - Init
    init(photo: UIImage?, name: String?, email: String?, bio: String?, web: String?, isEdit: Bool) {
        super.init()
        
        self.editMode = isEdit
        
        self.userPhoto.image = Images.Media.userAvatar.image
        if photo != nil {
            self.userPhoto.image = photo
        }
        if self.editMode {
            self.userPhoto.isAccessibilityElement = true
            self.userPhoto.accessibilityTraits = UIAccessibilityTraitButton
            self.userPhoto.accessibilityLabel = Localizations.Accessibility.Activity.PersonalInformation.image
        }
        
        var editString = Localizations.General.edit
        var accessibilityEditLabel = Localizations.Accessibility.Activity.PersonalInformation.edit
        if editMode {
            editString = Localizations.General.done
            accessibilityEditLabel = Localizations.Accessibility.Activity.PersonalInformation.save
        }
        let editAttr = NSAttributedString(string: editString, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption2), NSAttributedStringKey.foregroundColor: UIColor.main])
        let editHighlightedAttr = NSAttributedString(string: editString, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption2), NSAttributedStringKey.foregroundColor: UIColor.text])
        self.editButton.setAttributedTitle(editAttr, for: .normal)
        self.editButton.setAttributedTitle(editHighlightedAttr, for: .highlighted)
        self.editButton.accessibilityLabel = accessibilityEditLabel
        
        var nameAttr = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .title2), NSAttributedStringKey.foregroundColor: UIColor.main]
        var emailAttr = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedStringKey.foregroundColor: UIColor.main]
        var bioAttr = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedStringKey.foregroundColor: UIColor.main]
        var webAttr = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedStringKey.foregroundColor: UIColor.main]
        
        if !isEdit {
            if name != nil {
                nameAttr[NSAttributedStringKey.foregroundColor] = UIColor.text
                self.userName = ASTextNode()
                self.userName.attributedText = NSAttributedString(string: name!, attributes: nameAttr)
                self.userName.accessibilityValue = Localizations.Accessibility.Activity.PersonalInformation.name
            }
            
            if email != nil {
                emailAttr[NSAttributedStringKey.foregroundColor] = UIColor.text
                self.userEmail = ASTextNode()
                self.userEmail.attributedText = NSAttributedString(string: email!, attributes: emailAttr)
                self.userEmail.accessibilityValue = Localizations.Accessibility.Activity.PersonalInformation.email
            }
            
            if bio != nil {
                bioAttr[NSAttributedStringKey.foregroundColor] = UIColor.text
                self.userBio = ASTextNode()
                self.userBio.attributedText = NSAttributedString(string: bio!, attributes: bioAttr)
                self.userBio.accessibilityValue = Localizations.Accessibility.Activity.PersonalInformation.bio
            }
            if web != nil {
                webAttr[NSAttributedStringKey.foregroundColor] = UIColor.text
                self.userWeb = ASTextNode()
                self.userWeb.attributedText = NSAttributedString(string: web!, attributes: webAttr)
                self.userWeb.accessibilityValue = Localizations.Accessibility.Activity.PersonalInformation.site
            }
        } else {
            self.userName = ASTextNode()
            self.userEmail = ASTextNode()
            self.userName.accessibilityValue = Localizations.Accessibility.Activity.PersonalInformation.name
            self.userEmail.accessibilityValue = Localizations.Accessibility.Activity.PersonalInformation.email
            if name != nil {
                self.userName.attributedText = NSAttributedString(string: name!, attributes: nameAttr)
            } else {
                self.userName.attributedText = NSAttributedString(string: Localizations.Activity.User.Placeholder.name, attributes: nameAttr)
            }
            
            if email != nil {
                self.userEmail.attributedText = NSAttributedString(string: email!, attributes: emailAttr)
            } else {
                self.userEmail.attributedText = NSAttributedString(string: Localizations.Activity.User.Placeholder.email, attributes: emailAttr)
            }
            
            self.userBio = ASTextNode()
            self.userWeb = ASTextNode()
            self.userBio.accessibilityValue = Localizations.Accessibility.Activity.PersonalInformation.bio
            self.userWeb.accessibilityValue = Localizations.Accessibility.Activity.PersonalInformation.site
            
            if bio != nil {
                self.userBio.attributedText = NSAttributedString(string: bio!, attributes: bioAttr)
            } else {
                self.userBio.attributedText = NSAttributedString(string: Localizations.Activity.User.Placeholder.bio, attributes: bioAttr)
            }
            if web != nil {
                self.userWeb.attributedText = NSAttributedString(string: web!, attributes: webAttr)
            } else {
                self.userWeb.attributedText = NSAttributedString(string: Localizations.Activity.User.Placeholder.web, attributes: webAttr)
            }
        }
        
        if isEdit || self.userBio != nil {
            self.secondSeparator = ASDisplayNode()
            self.secondSeparator.backgroundColor = UIColor.main
            
            self.firstSeparator = ASDisplayNode()
            self.firstSeparator.backgroundColor = UIColor.main
        }
        
        if isEdit || email == nil || name == nil {
            self.facebookCover = ASDisplayNode()
            self.facebookButton = ASButtonNode()
            self.facebookDisclaimer = ASTextNode()
            
            self.facebookCover.backgroundColor = UIColor.facebook
            self.facebookCover.cornerRadius = 5.0
            
            var facebookAttr = [NSAttributedStringKey.foregroundColor: UIColor.tint, NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .body)]
            let facebookTitle = NSAttributedString(string: Localizations.Activity.User.Facebook.action, attributes: facebookAttr)
            facebookAttr[NSAttributedStringKey.foregroundColor] = UIColor.main
            let facebookHighlightedTitle = NSAttributedString(string: Localizations.Activity.User.Facebook.action, attributes: facebookAttr)
            self.facebookButton.setAttributedTitle(facebookTitle, for: .normal)
            self.facebookButton.setAttributedTitle(facebookHighlightedTitle, for: .highlighted)
            self.facebookButton.accessibilityValue = Localizations.Activity.User.Facebook.disclaimer
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            self.facebookDisclaimer.attributedText = NSAttributedString(string: Localizations.Activity.User.Facebook.disclaimer, attributes: [NSAttributedStringKey.foregroundColor: UIColor.main, NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption1), NSAttributedStringKey.paragraphStyle: paragraphStyle])
            self.facebookDisclaimer.isAccessibilityElement = false
        }
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func didLoad() {
        super.didLoad()
        self.nodeDidLoad?()
    }
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let editStack = ASStackLayoutSpec.vertical()
        editStack.alignItems = .end
        editStack.children = [self.editButton]
        
        let editStackInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -20.0, right: 10.0)
        let editStackInset = ASInsetLayoutSpec(insets: editStackInsets, child: editStack)
        
        self.userPhoto.style.preferredSize = CGSize(width: 100.0, height: 100.0)
        self.userPhoto.cornerRadius = 10
        
        let photoAndText = ASStackLayoutSpec.horizontal()
        photoAndText.spacing = 20.0
        photoAndText.children = [self.userPhoto]
        
        if self.userName != nil || self.userEmail != nil || self.userBio != nil {
            let nameAndEmail = ASStackLayoutSpec.vertical()
            nameAndEmail.spacing = 10.0
            nameAndEmail.style.flexShrink = 1.0
            nameAndEmail.children = []
            if self.userName != nil {
                self.userName.style.flexShrink = 1.0
                nameAndEmail.children?.append(self.userName)
            }
            if self.userEmail != nil {
                self.userEmail.style.flexShrink = 1.0
                nameAndEmail.children?.append(self.userEmail)
            }
            
            if self.userWeb != nil {
                nameAndEmail.children?.append(self.userWeb)
            }
            
            photoAndText.children?.append(nameAndEmail)
        }
        
        let photoAndTextInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        let photoAndTextInset = ASInsetLayoutSpec(insets: photoAndTextInsets, child: photoAndText)
        
        let cell = ASStackLayoutSpec.vertical()
        cell.spacing = 20.0
        cell.children = [editStackInset, photoAndTextInset]
        
        if self.firstSeparator != nil {
            self.firstSeparator.style.preferredSize = CGSize(width: 250.0, height: 0.2)
            cell.children?.append(self.firstSeparator)
        }
        
        if self.userBio != nil {
            let bioStack = ASStackLayoutSpec.vertical()
            bioStack.spacing = 10.0
            bioStack.children = []
            if self.userBio != nil {
                bioStack.children?.append(self.userBio)
            }
            
            let bioStackInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
            let bioStackInset = ASInsetLayoutSpec(insets: bioStackInsets, child: bioStack)
            
            cell.children?.append(bioStackInset)
        }
        
        if self.secondSeparator != nil {
            self.secondSeparator.style.preferredSize = CGSize(width: 250.0, height: 0.2)
            let secondSeparateStack = ASStackLayoutSpec.vertical()
            secondSeparateStack.alignItems = .end
            secondSeparateStack.children = [self.secondSeparator]
            cell.children?.append(secondSeparateStack)
        }
        
        if self.facebookButton != nil {
            self.facebookButton.style.preferredSize = CGSize(width: 290.0, height: 46)
            let fb = ASBackgroundLayoutSpec(child: self.facebookButton, background: self.facebookCover)
            
            let fbActionStack = ASStackLayoutSpec.vertical()
            fbActionStack.alignItems = .center
            fbActionStack.spacing = 3.0
            fbActionStack.children = [fb, self.facebookDisclaimer]
            
            cell.children?.append(fbActionStack)
        }
        
        let cellInsets = UIEdgeInsets(top: 30.0, left: 0.0, bottom: 30.0, right: 0.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}