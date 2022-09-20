//
//  GibberishStore.swift
//  Gibberish
//
//  Created by Gero Herkenrath on 20.02.21.
//

import Foundation

class GibberishStore: ObservableObject {

    @Published var items = [Element]()
    @Published var isLoading = false

    var gibberishLoader: GibberishLoading = GibberishLoader()

    func loadMore() {
        isLoading = true
        gibberishLoader.download { [weak self] response in
            defer { self?.isLoading = false }
            guard case .goodResponse(let newItem) = response else {
                return
            }
            self?.items.append(Element(iconName: newItem.icon, author: newItem.label, text: newItem.text))
        }
    }
}

extension GibberishStore {

    struct Element: Identifiable {
        let id = UUID()
        let iconName: String
        let author: String
        let text: String
    }
}
