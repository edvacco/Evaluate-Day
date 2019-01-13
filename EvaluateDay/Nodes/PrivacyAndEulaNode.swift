//
//  PrivacyAndTermsNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 04/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class PrivacyAndEulaNode: ASCellNode {
    // MARK: - UI
    var privacyButton = ASButtonNode()
    var eulaButton = ASButtonNode()
    var descriptionNode = ASTextNode()
    
    // MARK: - Handlers
    var privacySelected: (() -> Void)?
    var eulaSelected: (() -> Void)?
    
    // MARK: - Init
    override init() {
        super.init()
        
        // Description
        self.descriptionNode.attributedText = NSAttributedString(string: Localizations.Settings.Pro.Privacy.description, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption1), NSAttributedStringKey.foregroundColor: UIColor.text])
        
        // Buttons
        let privacy = NSAttributedString(string: Localizations.Settings.Pro.Privacy.privacy, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption1), NSAttributedStringKey.foregroundColor: UIColor.negative])
        self.privacyButton.setAttributedTitle(privacy, for: .normal)
        
        let eula = NSAttributedString(string: Localizations.Settings.Pro.Privacy.eula, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption1), NSAttributedStringKey.foregroundColor: UIColor.negative])
        self.eulaButton.setAttributedTitle(eula, for: .normal)
        
        self.privacyButton.addTarget(self, action: #selector(privacyButtonAction(sender:)), forControlEvents: .touchUpInside)
        self.eulaButton.addTarget(self, action: #selector(eulaButtonAction(sender:)), forControlEvents: .touchUpInside)
        
        self.automaticallyManagesSubnodes = true
    }
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let buttons = ASStackLayoutSpec.horizontal()
        buttons.spacing = 10.0
        buttons.alignItems = .center
        buttons.children = [self.privacyButton, self.eulaButton]
        
        let buttonsInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 5.0, right: 10.0)
        let buttonsInset = ASInsetLayoutSpec(insets: buttonsInsets, child: buttons)
        
        let desc = ASStackLayoutSpec.horizontal()
        desc.spacing = 20.0
        desc.flexWrap = .wrap
        desc.children = [self.descriptionNode, buttonsInset]
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 10.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: desc)
        
        return cellInset
    }
    
    // MARK: - Actions
    @objc func privacyButtonAction(sender: ASButtonNode) {
        self.privacySelected?()
    }
    
    @objc func eulaButtonAction(sender: ASButtonNode) {
        self.eulaSelected?()
    }
}
