//
//  PostingList.swift
//  Gibberish
//
//  Created by Gero Herkenrath on 20.02.21.
//

import SwiftUI

struct PostingList: View {

	@ObservedObject var gibberishStore = GibberishStore()

	var body: some View {
		NavigationView {
			List(gibberishStore.items, id: \.self) { _ in
				Posting()
			}
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .principal) {
					Text("Gibberish")
						.font(.largeTitle)
						.fontWeight(.medium)
				}
				ToolbarItem(placement: .navigationBarTrailing) {
					if gibberishStore.isLoading {
						ProgressView()
					} else {
						Button("Add", action: gibberishStore.loadMore)
					}
				}
			}
		}
	}
}

struct PostingList_Previews: PreviewProvider {
	static var previews: some View {
		PostingList(gibberishStore: Self.previewStore)
	}

	static var previewStore: GibberishStore {
		let retVal = GibberishStore()
		let testItems = (0..<3).map {
			GibberishJsonModel(icon: "sun.max.fill", label: "Test \($0)", text: "Hello World!", minWordCount: 1, maxWordCount: 5)
		}
		retVal.items = testItems
		return retVal
	}
}
