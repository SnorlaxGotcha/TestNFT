//
//  DetailView.swift
//  TestOpenseaapi
//
//  Created by 黃世維 on 2022/4/20.
//

import SwiftUI
import SafariServices

struct DetailView: View {
    
    @StateObject private var vm: ViewModel
    @State private var isShowingWebView: Bool = false
    
    init(asset: Asset) {
        _vm = StateObject(wrappedValue: ViewModel(asset: asset))
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    AsyncImage(url: URL(string: vm.imageUrl)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .aspectRatio(contentMode: .fit)
                    Text(vm.name)
                    Text(vm.description)
                    Spacer()
                }
            }
            VStack {
                Spacer()
                Button(action: {
                    isShowingWebView = true
                })
                {
                    Text("Permalink")
                }
                .sheet(isPresented: $isShowingWebView) {
                    SafariView(url:URL(string: vm.permalink)!)
                }
            }
        }
        .navigationTitle(vm.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(asset: .init(id: 0, numSales: 0, imageURL: "", imagePreviewURL: "", imageThumbnailURL: "", imageOriginalURL: "", name: "", assetDescription: "", permalink: "", collection: .init(name: "", imageURL: "")))
    }
}
