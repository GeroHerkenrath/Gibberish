import Foundation

/// Master playground for the first part of Gero's swift intro.
///
/// This file will be used as a "copy & paste" repository during a live demo and explanation of some common nice
/// aspects of the Swift language. It is runnable as is, but some conflicting code lines are commented out.
/// During the demo certain parts will be modified and not just copied, the commented out lines are for those
/// modifications. This was easier to setup than using snippets or the like (I will also basically use two
/// computers that allow me to seamlessly copy things over).

// MARK: - Step 0 - Some basic prints

print("This is a String")
var bubbles: String?
print("This is an optional string: \(bubbles ?? "forgot to set it")")
bubbles = "fun fact: You can choke on bubble tea!"
print("Oopsies, now it is set: \(bubbles ?? "this should not show up")")

if let bubbles = bubbles {
	print(String(bubbles.reversed()))
}

let intArray = [1, 2, 3, 4, 5]
for anInt in intArray {
	if anInt < 3 {
		print(anInt)
	} else {
		print(anInt * -1)
	}
}

// before we get to the "classic" kinds of types (i.e. classes and structs, pun intended...)

// extending existing types with new functionality (just not stored properties)
extension Double {
	// methods:
	func justAnExample() {
		print("I won't even demo this...")
	}
	// stored properties won't work:
//	var isForDemo = false

	// this is a calculated property, of course it also works on own types & without an extension
	var oddOrNil: Double? {
		guard self.truncatingRemainder(dividingBy: 2.0) == 0 else {
			return nil
		}
		return self
	}
	// static methods and static calculated properties are also okay!
}

// defining behavior:
protocol UselessThings {
	func stringed(withSuffix suffix: String) -> String
	var percented: Double { get }
}

// providing a default that can be "overridden" by conforming types (note the quotes here!)
extension UselessThings {
	func stringed(withSuffix suffix: String) -> String {
		return "\(self)\(suffix)"
	}
}

// making existing types conform to the protocol
// note that in this case we at first do not change the default for `stringed(withSuffix:)`
extension Double: UselessThings {
	var percented: Double {
		return self / 100.0
	}
//	func stringed(withSuffix suffix: String) -> String {
//		return "\(self.percented)\(suffix)"
//	}
}

let doubleArray = [6, 7, 8, 9, 10].map { Double($0) }

doubleArray.forEach { print($0.percented) }

let someDoubles = doubleArray.compactMap { theDouble -> String? in
	guard let oddDouble = theDouble.oddOrNil else {
		return nil
	}
	return oddDouble.stringed(withSuffix: " €")
}
print(someDoubles.joined(separator: ", "))

// abstracting _existing_ behavior to get a grasp on it
protocol HasBitPattern {
	var bitPattern: UInt64 { get }
}
extension Double: HasBitPattern { }

// making use of our abstraction and using constraints on protocol adoption
extension Array where Element: HasBitPattern { // Array is a generic struct
	func concatenateBitPatterns() -> String {
		// 1: most verbose syntax for (trailing) closures
		return reduce("", { soFar, nextValue -> String in
			return soFar.appending("\(nextValue.bitPattern)")
		})

		// 2: better...
//		return reduce("") { soFar, nextValue in
//			soFar + "\(nextValue.bitPattern)"
//		}

		// 3: yay, that's short!
//		reduce("") { $0 + "\($1.bitPattern)" }
	}
}

print(doubleArray.concatenateBitPatterns())

print("\n\n\((1...40).reduce("", { next, _ in return next + " #" }))\n\n")


// MARK: - Step 1 - Defining JSON model
// note: explain the API and what we have in mind, outline:
//			1. API delivers list item with each request, randomized delay, etc.
// 			2. Type for parsing into
//			3. Briefly: How does that Codable etc. work? Where's annotations for JSON field names, etc.?
//						-> Simple case here, stuff is synthesized, but configurable well!
//struct GibberishJsonModel: Codable, Hashable {
struct GibberishJsonModel: Codable {

	let icon: String
	let label: String
	let text: String
	let minWordCount: Int
	let maxWordCount: Int
}

// MARK: - Step 2 - The Loader
// Note to self: First do this without the protocol!
struct GibberishLoader {
//struct GibberishLoader {

	private static let delayKey = "responseDelay"
	private static let minWordKey = "minWordCount"
	private static let maxWordKey = "maxWordCount"

	var urlString = "https://codingfromhell.net/swiftDemo/listElement"

	func download(onCompletion: @escaping (GibberishLoadingResponse) -> Void) {
		guard let url = constructUrl() else {
			onCompletion(.clientError)
			return
		}

		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			if let error = error {
				DispatchQueue.main.async { onCompletion(.networkError(error)) }
				return
			}
			guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
				DispatchQueue.main.async { onCompletion(.badResponse) }
				return
			}
			do {
				let jsonModel = try JSONDecoder().decode(GibberishJsonModel.self, from: data)
				DispatchQueue.main.async { onCompletion(.goodResponse(jsonModel)) }
			} catch {
				DispatchQueue.main.async { onCompletion(.parsingError(error)) }
			}
		}
		task.resume()
	}

	private func constructUrl() -> URL? {
		var urlComps = URLComponents(string: urlString)
		let delay = Int.random(in: 250...3000)
		let minCount = Int.random(in: 10...50)
		let maxCount = Int.random(in: minCount...(minCount + 20))
		urlComps?.queryItems = [URLQueryItem(name: Self.delayKey, value: "\(delay)"),
								URLQueryItem(name: Self.minWordKey, value: "\(minCount)"),
								URLQueryItem(name: Self.maxWordKey, value: "\(maxCount)")]
		return urlComps?.url
	}
}

enum GibberishLoadingResponse {
	case clientError
	case networkError(Error)
	case badResponse
	case parsingError(Error)
	case goodResponse(GibberishJsonModel)
}

// MARK: - Step 3 - Classic Store object
// Note: 1. Leave out the ObservableObject until the full app!
// 		 2. Explain the delegate approach (and remove it later when showing ObservableObject)
//class GibberishStore: ObservableObject {
//
//	@Published var items = [Element]()
//	@Published var isLoading = false
//
//	var gibberishLoader: GibberishLoading = GibberishLoader()

// note that classic delegation often implies reference semantics!
// a different approach could be achieved by closures (which are always reference-types)
// using value types can lead to unexpected behavior, as setting a value-type delegate would copy it!
protocol GibberishStoreDelegate: class {
	var gibberishLoadingState: Bool { get set }
	func completedLoading(fullItemList: [GibberishStore.Element])
}

class GibberishStore {

	var items = [Element]()
	var isLoading = false
	weak var delegate: GibberishStoreDelegate?

	private let gibberishLoader = GibberishLoader()

	func loadMore() {
		isLoading = true
		delegate?.gibberishLoadingState = isLoading
		gibberishLoader.download { [weak self] response in
			defer {
				self?.isLoading = false
				self?.delegate?.gibberishLoadingState = false
				if let currentItems = self?.items {
					self?.delegate?.completedLoading(fullItemList: currentItems)
				}
			}
			// the following is case pattern matching (and the only "weird" syntax in Swift imo)
			guard case .goodResponse(let newItem) = response else {
				return
			}
			self?.items.append(Element(iconName: newItem.icon, author: newItem.label, text: newItem.text))

			// note: we could also do something like this if we were interested in several cases:
//			switch response {
//			case .goodResponse(let newItem):
//				self?.items.append(Element(iconName: newItem.icon, author: newItem.label, text: newItem.text))
//			case .clientError, .networkError: // note we are not interested in the associated value of networkError
//				print("you're doing it wrong! maybe airplane mode?")
//			default: // the rest: parsingError and badRequest
//				print("something with the API is broken...")
//			}
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

// MARK: - Step 4 - A Simple container to use these types

class OurRunner: GibberishStoreDelegate {

	var gibberishLoadingState: Bool = false

	let storage: GibberishStore

	init() {
		// note that we have to set our own properties before we can use self!
		// so even if GibberishStore had an init to pass the delegate as parameter, we
		// could not use it here with self!
		storage = GibberishStore()
		storage.delegate = self
	}

	func completedLoading(fullItemList: [GibberishStore.Element]) {
		print("Item list is now:\n\(fullItemList)")
	}

	func runUs() {
		storage.loadMore()
	}
}

// MARK: - Step 5 - Have some fun!

let runner = OurRunner()
print("initiating loading more items!")
runner.runUs()
print("note this line is called before the result as we're asynchronuous")

// Note: Now explain that this is a bit ugly in a playground, due to the asynchronity:
// playgrounds do work like this, but keep in mind that there's code executed _after_
// the last line has been reached, I assume it would eventually time out.
// this does not happen in an app that is running a run loop!

// MARK: - Step 6 - What about POP & testing?
// note: maybe comment out the runner.runUs()?
import XCTest

// change conformance of Loader above & replace GibberishStore with updated version from below!
protocol GibberishLoading {
	func download(onCompletion: @escaping (GibberishLoadingResponse) -> Void)
}

//class GibberishStore {
//
//	var items = [Element]()
//	var isLoading = false
//	weak var delegate: GibberishStoreDelegate?
//
//	var gibberishLoader: GibberishLoading = GibberishLoader()
//
//	func loadMore() {
//		isLoading = true
//		delegate?.gibberishLoadingState = isLoading
//		gibberishLoader.download { [weak self] response in
//			defer {
//				self?.isLoading = false
//				self?.delegate?.gibberishLoadingState = false
//				if let currentItems = self?.items {
//					self?.delegate?.completedLoading(fullItemList: currentItems)
//				}
//			}
//			guard case .goodResponse(let newItem) = response else {
//				return
//			}
//			self?.items.append(Element(iconName: newItem.icon, author: newItem.label, text: newItem.text))
//		}
//	}
//}

//class GibberishStoreTests: XCTestCase, GibberishStoreDelegate {
//
//	var underTest: GibberishStore!
//
//	var mockLoader: MockLoader!
//	var testItem: GibberishJsonModel!
//
//	// used to capture the store's responses during tests
//	var dynamicDelegateWrapper: (([GibberishStore.Element]) -> Void)?
//	var gibberishLoadingState: Bool = false
//	func completedLoading(fullItemList: [GibberishStore.Element]) {
//		dynamicDelegateWrapper?(fullItemList)
//	}
//
//	override func setUpWithError() throws {
//		try super.setUpWithError()
//
//		mockLoader = MockLoader()
//		testItem = GibberishJsonModel(icon: "sun.max.fill", label: "TestName", text: "TestText", minWordCount: 1, maxWordCount: 10)
//
//		underTest = GibberishStore()
//		underTest.gibberishLoader = mockLoader
//		underTest.delegate = self
//	}
//
//	override func tearDownWithError() throws {
//		try super.tearDownWithError()
//		dynamicDelegateWrapper = nil // often important to not get unexpected callbacks in real app tests
//	}
//
//	func test_loadMore_changesIsLoadingAndProperlyParsesResponse() {
//		let didCallDownload = expectation(description: "did invoke download on loader")
//		mockLoader.injectDownloadResponse = { [unowned self] in
//			didCallDownload.fulfill()
//			assertTrue(underTest.isLoading)
//			assertTrue(underTest.items.isEmpty)
//			return .goodResponse(testItem)
//		}
//
//		let didCallDelegateMethod = expectation(description: "did invoke the delegate callback method")
//		dynamicDelegateWrapper = { [unowned self] items in
//			assertEqual(items.count, 1)
//			assertEqual(items[0].iconName, testItem.icon)
//			assertEqual(items[0].author, testItem.label)
//			assertEqual(items[0].text, testItem.text)
//			didCallDelegateMethod.fulfill()
//		}
//
//		assertTrue(!underTest.isLoading)
//		assertTrue(underTest.items.isEmpty)
//		underTest.loadMore()
//		wait(for: [didCallDownload, didCallDelegateMethod], timeout: 1.0)
//
//		assertTrue(underTest.isLoading)
//		assertEqual(underTest.items.count, 1)
//		assertEqual(underTest.items[0].iconName, testItem.icon)
//		assertEqual(underTest.items[0].author, testItem.label)
//		assertEqual(underTest.items[0].text, testItem.text)
//	}
//
//	class MockLoader: GibberishLoading { // note this is a class!
//
//		var injectDownloadResponse: () -> GibberishLoadingResponse = { return .badResponse }
//		func download(onCompletion: @escaping (GibberishLoadingResponse) -> Void) {
//			let response = injectDownloadResponse()
//			DispatchQueue.main.async {
//				onCompletion(response)
//			}
//		}
//	}
//
//	private func assertTrue(_ value: Bool, line: UInt = #line) {
//		if !value {
//			print("TEST FAILED IN LINE: \(line)")
//		}
//	}
//
//	private func assertEqual<T: Equatable>(_ lhs: T, _ rhs: T, line: UInt = #line) {
//		if lhs != rhs {
//			print("TEST FAILED IN LINE: \(line)")
//		}
//	}
//}
//
//print("\n\n\((1...40).reduce("", { next, _ in return next + " #" }))\n\n")
//print("TESTING")
//
//let testCase = GibberishStoreTests()
//testCase.continueAfterFailure = false
//try! testCase.setUpWithError()
//testCase.test_loadMore_changesIsLoadingAndProperlyParsesResponse()
//print("TESTING DONE")
