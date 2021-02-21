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
			List {
				if gibberishStore.items.isEmpty {
					Text("No gibberish yet, load some with 'Add'!")
						.padding()
						.frame(maxWidth: .infinity, alignment: .center)
				} else {
					ForEach(gibberishStore.items) {
						Posting(iconName: $0.iconName, author: $0.author,
								content: $0.text)
					}
				}
			}
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				PostingToolbar(isLoading: gibberishStore.isLoading,
							   load: gibberishStore.loadMore)
			}
		}
	}

	private struct PostingToolbar: ToolbarContent {
		@State var isLoading: Bool
		var load: () -> Void
		var body: some ToolbarContent {
			ToolbarItem(placement: .principal) {
				Text("Gibberish")
					.font(.largeTitle)
					.fontWeight(.medium)
			}
			ToolbarItem(placement: .navigationBarTrailing) {
				if isLoading {
					ProgressView()
				} else {
					Button("Add", action: load)
				}
			}
		}
	}
}

struct PostingList_Previews: PreviewProvider {
	static var previews: some View {
		PostingList(gibberishStore: Self.previewStore)
		PostingList()
	}

	static var previewStore: GibberishStore {
		let retVal = GibberishStore()
		let testItems = (0..<3).map {
			GibberishStore.Element(iconName: "sun.max.fill", author: "Test \($0)",
								   text: "Hello World from number \($0)")
		}
		retVal.items = testItems
		return retVal
	}
}
