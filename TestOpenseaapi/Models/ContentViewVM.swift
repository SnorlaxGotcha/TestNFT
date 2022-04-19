//
//  ContentViewVM.swift
//  TestOpenseaapi
//
//  Created by 黃世維 on 2022/4/20.
//

import Combine
import SwiftUI

enum Loadable {
    case idle
    case loading
}

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        private let repo: APIRepository = OpenseaApi()
        private var requests: Set<AnyCancellable> = .init()
        
        @Published private(set) var state = Loadable.idle
        
        /// Main list paging
        private var offset = 0
        private var cursor = ""

        /// Main list data
        @Published private(set) var asssets: [Asset] = .init()
        
        func fetch() {
            if self.state == .loading {
                return
            }
            
            Task(priority: .high) {
                self.state = .loading
                let reply = try await repo.getAssests(cursor: cursor, offset: offset, limit: 20)
                reply
                    .receive(on: RunLoop.main)
                    .sink(
                        receiveCompletion: { _ in
                            self.offset += 1
                            self.state = .idle
                        },
                        receiveValue: {
                            let diff = $0.assets.difference(from: self.asssets)

                            for change in diff {
                                switch change {
                                case .remove(let offset, _, _):
                                    self.asssets.remove(at: offset)
                                case .insert(let offset, let element, _):
                                    self.asssets.insert(element, at: offset)
                                }
                            }
                            
                            self.asssets.append(contentsOf: $0.assets)
                            self.cursor = $0.next ?? ""
                        }
                    )
                    .store(in: &requests)
            }
        }
        
    }
}
