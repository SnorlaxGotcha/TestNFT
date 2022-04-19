//
//  CardVM.swift
//  TestOpenseaapi
//
//  Created by 黃世維 on 2022/4/20.
//

import Combine
import SwiftUI

extension DetailView {
    @MainActor class ViewModel: ObservableObject {
        var asset: Asset?
        
        @Published private(set) var title: String = ""
        @Published private(set) var imageUrl: String = ""
        @Published private(set) var name: String = ""
        @Published private(set) var description: String = ""
        @Published private(set) var permalink: String = ""
        
        init(asset: Asset) {
            self.asset = asset
            self.title = asset.collection.name
            self.imageUrl = asset.imageURL ?? ""
            self.name = asset.name ?? ""
            self.description = asset.assetDescription ?? ""
            self.permalink = asset.permalink
        }
        
    }
}
