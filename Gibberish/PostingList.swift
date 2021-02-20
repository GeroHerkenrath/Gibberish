//
//  PostingList.swift
//  Gibberish
//
//  Created by Gero Herkenrath on 20.02.21.
//

import SwiftUI

struct PostingList: View {

	var loader: GibberishLoading = GibberishLoader()

	var body: some View {
		NavigationView {
			List(0..<5) { _ in
				Posting()
			}
			.navigationBarTitleDisplayMode(.inline)
			.toolbar(content: {
				ToolbarItem(placement: .principal) {
					Text("Gibberish").font(.largeTitle).fontWeight(.medium)
				}
				ToolbarItem(placement: .navigationBarTrailing) {
					addButton
				}
			})
		}
	}

	private var addButton: some View {
		Button("Add") {
			loader.download { response in
				guard case .goodResponse(let jsonString) = response else {
					if case .badResponse = response {
						print("got bad response!")
					}
					return
				}
				print(jsonString)
			}
		}
	}
}

struct PostingList_Previews: PreviewProvider {
	static var previews: some View {
		PostingList()
	}
}
