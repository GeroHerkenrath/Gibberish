//
//  PostingList.swift
//  Gibberish
//
//  Created by Gero Herkenrath on 20.02.21.
//

import SwiftUI

struct PostingList: View {
	var body: some View {
		NavigationView {
			List(0..<5) { _ in
				Posting()
			}
			.navigationBarTitle("Gibberish")
			.navigationBarItems(trailing: addButton)
		}
	}

	private var addButton: some View {
		Button("Add") {
			 print("do something, but what?")
		}
	}
}

struct PostingList_Previews: PreviewProvider {
	static var previews: some View {
		PostingList()
	}
}
