//
//  TitleCardNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 24/10/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol TitleNodeStyle {
    var titleTitleColor: UIColor { get }
    var titleTitleFont: UIFont { get }
    var titleSubtitleColor: UIColor { get }
    var titleSubtitleFont: UIFont { get }
    var titleShareTintColor: UIColor { get }
    var titleDashboardFont: UIFont { get }
    var titleDashboardColor: UIColor { get }
}

class TitleNode: ASCellNode {
    
    // MARK: - UI
    var title: ASTextNode = ASTextNode()
    var subtitle: ASTextNode = ASTextNode()
    var previewImage: ASImageNode = ASImageNode()
    var shareButton: ASButtonNode = ASButtonNode()
    var dashboardImage: ASImageNode!
    var dashboardTitle: ASTextNode!
    
    // MARK: - Variable
    var topInset: CGFloat = 10.0
    var leftInset: CGFloat = 0.0

    // MARK: - Init
    init(title: String, subtitle: String, image: UIImage, dashboard: (title: String, image: UIImage)?, style: TitleNodeStyle) {
        super.init()
        
        if dashboard != nil {
            self.dashboardImage = ASImageNode()
            self.dashboardImage.image = dashboard?.image
            self.dashboardImage.clipsToBounds = true
            self.dashboardImage.cornerRadius = 15.0
            
            self.dashboardTitle = ASTextNode()
            self.dashboardTitle.attributedText = NSAttributedString(string: dashboard!.title, attributes: [NSAttributedStringKey.font: style.titleDashboardFont, NSAttributedStringKey.foregroundColor: style.titleDashboardColor])
        }
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = -10.0
        
        self.title.attributedText = NSAttributedString(string: title, attributes: [NSAttributedStringKey.font: style.titleTitleFont, NSAttributedStringKey.foregroundColor: style.titleTitleColor, NSAttributedStringKey.paragraphStyle: paragraph])
        self.subtitle.attributedText = NSAttributedString(string: subtitle, attributes: [NSAttributedStringKey.font: style.titleSubtitleFont, NSAttributedStringKey.foregroundColor: style.titleSubtitleColor])
        self.previewImage.image = image
        self.previewImage.contentMode = .scaleAspectFit
        self.previewImage.alpha = 0.5
        self.shareButton.setImage(#imageLiteral(resourceName: "share"), for: .normal)
        self.shareButton.imageNode.contentMode = .scaleAspectFit
        self.shareButton.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(style.titleShareTintColor)
        
        if dashboard != nil {
            self.dashboardImage = ASImageNode()
            self.dashboardImage.image = dashboard?.image
            self.dashboardImage.clipsToBounds = true
            self.dashboardImage.cornerRadius = 15.0
            self.dashboardImage.zPosition = -1.0
            
            self.dashboardTitle = ASTextNode()
            self.dashboardTitle.attributedText = NSAttributedString(string: dashboard!.title, attributes: [NSAttributedStringKey.font: style.titleDashboardFont, NSAttributedStringKey.foregroundColor: style.titleDashboardColor])
        }
        
        // Accessibility
        self.shareButton.accessibilityLabel = Localizations.calendar.empty.share
        self.shareButton.accessibilityValue = title
        
        self.title.isAccessibilityElement = false
        self.subtitle.isAccessibilityElement = false
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        self.previewImage.style.preferredSize = CGSize(width: 60.0, height: 60.0)
        self.shareButton.style.preferredSize = CGSize (width: 50.0, height: 50.0)
        
        self.title.style.flexShrink = 1.0
        
        let spacer = ASLayoutSpec()
        spacer.style.flexGrow = 1.0
        
        let imageInsets = UIEdgeInsets(top: 0.0, left: -6.0, bottom: 0.0, right: 0.0)
        let imageInset = ASInsetLayoutSpec(insets: imageInsets, child: self.previewImage)
        
        let topLine = ASStackLayoutSpec.horizontal()
        topLine.style.flexGrow = 1.0
        topLine.style.flexShrink = 1.0
        topLine.alignItems = .center
        topLine.children = [self.title, imageInset, spacer, self.shareButton]
        
        let topLineInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 0.0, right: 0.0)
        let topLineInset = ASInsetLayoutSpec(insets: topLineInsets, child: topLine)
        topLineInset.style.flexShrink = 1.0
        
        let subtitleInsets = UIEdgeInsets(top: -10.0, left: 35.0, bottom: 10.0, right: 10.0)
        let subtitleInset = ASInsetLayoutSpec(insets: subtitleInsets, child: self.subtitle)
        
        let cell = ASStackLayoutSpec.vertical()
        cell.children = [topLineInset, subtitleInset]
        
        if self.dashboardTitle != nil && self.dashboardImage != nil {
            self.dashboardImage.style.preferredSize = CGSize(width: 30.0, height: 30.0)
            
            let dashboardTitleInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            let dashboardTitleInset = ASInsetLayoutSpec(insets: dashboardTitleInsets, child: self.dashboardTitle)
            
            let dashboard = ASStackLayoutSpec.horizontal()
            dashboard.spacing = 2.0
            dashboard.alignItems = .end
            dashboard.children = [self.dashboardImage, dashboardTitleInset]
            
            let dashboardInsets = UIEdgeInsets(top: -20.0, left: 2.0, bottom: 10.0, right: 10.0)
            let dashboardInset = ASInsetLayoutSpec(insets: dashboardInsets, child: dashboard)
            
            cell.children?.append(dashboardInset)
        }
        
        let cellInsets = UIEdgeInsets(top: self.topInset, left: self.leftInset, bottom: 0.0, right: 0.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}