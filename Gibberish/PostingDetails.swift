//
//  PostingDetails.swift
//  Gibberish
//
//  Created by Gero Herkenrath on 21.02.21.
//

import SwiftUI

struct PostingDetails: View {

	let element: GibberishStore.Element

	var body: some View {
		VStack(alignment: .leading) {
			HStack() {
				Image(systemName: element.iconName)
					.renderingMode(.original)
					.resizable()
					.scaledToFit()
					.frame(width: 60, height: 60)
				Text(element.author)
					.font(.largeTitle)
			}
			Divider()
			ScrollView {
				Text(element.text)
					.font(.title2)
			}
			Spacer()
		}
		.padding()
		.navigationTitle(element.author)
	}
}

struct PostingDetails_Previews: PreviewProvider {
	static let longLine = Posting_Previews.longLine
    static var previews: some View {
		let veryLong = (1...10).reduce("") { prev, _ in return prev + Self.longLine + "\n" }
		let longElem = GibberishStore.Element(iconName: "sun.max.fill",
											  author: "Marcus Aurelius",
											  text: "Hellos!\n\(veryLong)")
		PostingDetails(element: longElem)
    }
}
