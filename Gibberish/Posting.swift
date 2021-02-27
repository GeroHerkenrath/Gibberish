//
//  Posting.swift
//  Gibberish
//
//  Created by Gero Herkenrath on 20.02.21.
//

import SwiftUI

struct Posting: View {

	let iconName: String
	let author: String
	let content: String

	var body: some View {
		VStack(alignment: .leading) {
			HStack() {
				Image(systemName: iconName)
					.renderingMode(.original)
					.resizable()
					.scaledToFit()
					.frame(width: 40, height: 40)
				Text(author)
					.font(.largeTitle)
			}
			Text(content)
				.font(.body)
				.lineLimit(3)
		}
		.padding()
		.fixedSize(horizontal: false, vertical: true)
	}
}

struct Posting_Previews: PreviewProvider {
	static let longLine =
		"""
This is a long piece of text that is supposed to wrap around and maybe even
contain
several lines and so forth. This is good for testing!
"""
	static var previews: some View {
		Posting(iconName: "sun.max.fill", author: "Mike",
				content: "This is my Post!\n\(Self.longLine)")
			.previewLayout(.sizeThatFits)
		List(0..<5) {
			Posting(iconName: "sun.max.fill", author: "Mike \($0)",
					content: "This is my Post \($0)!\n\(Self.longLine)")
		}
		.previewLayout(.sizeThatFits)
	}
}
