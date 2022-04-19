//
//  Card.swift
//  TestOpenseaapi
//
//  Created by 黃世維 on 2022/4/20.
//

import SwiftUI

struct Card: View {
    
    let imageUrl: String
    let name: String
    var isLast: Bool = false
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: imageUrl)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .aspectRatio(contentMode: .fit)
            .frame(height: 200)

            Text(name)
        }.onAppear {
            if isLast {
                let note = Notification(name: .shouldFetchMore)
                NotificationCenter.default.post(note)
            }
        }
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        Card(imageUrl: "https://example.com/icon.png", name: "name")
    }
}
