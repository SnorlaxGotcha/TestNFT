//
//  ContentView.swift
//  TestOpenseaapi
//
//  Created by 黃世維 on 2022/4/19.
//

import SwiftUI
import Combine

extension Notification.Name {
    static let shouldFetchMore = Notification.Name("ShouldFetchMore")
}

struct ContentView: View {
    
    @StateObject private var vm: ViewModel
    
    private var loadMore: AnyPublisher<Notification, Never> {
        NotificationCenter.default
            .publisher(for: .shouldFetchMore)
            .eraseToAnyPublisher()
    }
        
    init() {
      _vm = StateObject(wrappedValue: ViewModel())
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2)) {
                    ForEach((0..<vm.asssets.count), id: \.self) { index in
                        NavigationLink(destination: DetailView(asset: vm.asssets[index])) {
                            Card(imageUrl: vm.asssets[index].imageURL ?? "", name: vm.asssets[index].name ?? "unknown", isLast: index == vm.asssets.count-1)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                vm.fetch()
            }
            .onReceive(loadMore) { _ in
                vm.fetch()
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
