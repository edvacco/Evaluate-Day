//
//  CriterionThreeEditSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 17/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

private enum CriterionThreeSettingsNodeType {
    case sectionTitle
    case title
    case subtitles
    case separator
    case positiveBool
    case positiveDescription
}

class CriterionThreeEditSection: ListSectionController, ASSectionController, EditableSection {
    // MARK: - Variable
    var card: Card!
    
    // MARK: - Actions
    var setTextHandler: ((String, String, String?) -> Void)?
    var setBoolHandler: ((Bool, String, Bool) -> Void)?
    
    // MARK: - Private Variables
    private var nodes = [CriterionThreeSettingsNodeType]()
    
    // MARK: - Init
    init(card: Card) {
        super.init()
        if let realmCard = Database.manager.data.objects(Card.self).filter("id=%@", card.id).first {
            self.card = realmCard
        } else {
            self.card = card
        }
        
        self.nodes.append(.sectionTitle)
        self.nodes.append(.title)
        self.nodes.append(.subtitles)
        self.nodes.append(.positiveBool)
        self.nodes.append(.positiveDescription)
        self.nodes.append(.separator)
    }
    
    // MARK: - Override
    override func numberOfItems() -> Int {
        return self.nodes.count
    }
    
    func nodeForItem(at index: Int) -> ASCellNode {
        return ASCellNode()
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        switch self.nodes[index] {
        case .sectionTitle:
            return {
                let node = CardSettingsSectionTitleNode(title: Localizations.Settings.General.title)
                return node
            }
        case .title:
            let title = Localizations.CardSettings.title
            let text = self.card.title
            return {
                let node = CardSettingsTextNode(title: title, text: text)
                return node
            }
        case .subtitles:
            let subtitle = Localizations.CardSettings.subtitle
            let text = self.card.subtitle
            return {
                let node = CardSettingsTextNode(title: subtitle, text: text)
                return node
            }
        case .separator:
            return {
                let separator = SeparatorNode()
                separator.insets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 0.0, right: 20.0)
                return separator
            }
        case .positiveBool:
            let title = Localizations.CardSettings.Criterion.Feater.title
            let isOn = (self.card.data as! CriterionThreeCard).positive
            return {
                let node = CardSettingsBooleanNode(title: title, isOn: isOn)
                node.switchAction = { (isOn) in
                    self.setBoolHandler?(isOn, "positive", (self.card.data as! CriterionThreeCard).positive)
                }
                return node
            }
        case .positiveDescription:
            return {
                let node = DescriptionNode(text: Localizations.CardSettings.Criterion.Feater.description, alignment: .left)
                return node
            }
        }
    }
    
    func sizeRangeForItem(at index: Int) -> ASSizeRange {
        let width: CGFloat = self.collectionContext!.containerSize.width
        
        if  width >= maxCollectionWidth {
            let max = CGSize(width: width * collectionViewWidthDevider, height: CGFloat.greatestFiniteMagnitude)
            let min = CGSize(width: width * collectionViewWidthDevider, height: 0)
            return ASSizeRange(min: min, max: max)
        }
        
        let max = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let min = CGSize(width: width, height: 0)
        return ASSizeRange(min: min, max: max)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return .zero
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        return collectionContext!.dequeueReusableCell(of: _ASCollectionViewCell.self, for: self, at: index)
    }
    
    override func didSelectItem(at index: Int) {
        if self.nodes[index] == .title {
            self.setTextHandler?(Localizations.CardSettings.title, "title", self.card.title)
        } else if self.nodes[index] == .subtitles {
            self.setTextHandler?(Localizations.CardSettings.subtitle, "subtitle", self.card.subtitle)
        }
    }
}
