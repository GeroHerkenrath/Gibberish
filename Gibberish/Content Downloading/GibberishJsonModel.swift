//
//  GibberishJsonModel.swift
//  Gibberish
//
//  Created by Gero Herkenrath on 20.02.21.
//

import Foundation

struct GibberishJsonModel: Codable, Hashable {

	let icon: String
	let label: String
	let text: String
	let minWordCount: Int
	let maxWordCount: Int
}
