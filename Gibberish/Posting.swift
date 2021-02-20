//
//  Posting.swift
//  Gibberish
//
//  Created by Gero Herkenrath on 20.02.21.
//

import SwiftUI

struct Posting: View {

	private let iconName = "sun.max.fill"
	private let author = "Mike"
	private let content = "This is my Post!\nLet's see"

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
		}
		.padding()
		.fixedSize(horizontal: true, vertical: true)
	}
}

struct Posting_Previews: PreviewProvider {
	static var previews: some View {
		Posting()
			.previewLayout(.sizeThatFits)
		List(0..<5) { _ in
			Posting()
		}
		.previewLayout(.sizeThatFits)
	}
}
