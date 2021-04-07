class Generator
	def initialize
			
	end

	def self.create_model_file 
		return 	<<-EOS
import Foundation

struct Repo: Decodable {
	let id: Int
	let name: String
}
		EOS
	end

	def self.create_view_model_file
		return 	<<-EOS

import Foundation

final class ReposViewModel {
	// Outputs
	var isRefreshing: ((Bool) -> Void)?
	var didUpdateRepos: (([RepoViewModel]) -> Void)?
	var didSelecteRepo: ((Int) -> Void)?
	
	private(set) var repos: [Repo] = [Repo]() {
		didSet {
			didUpdateRepos?(repos.map { RepoViewModel(repo: $0) })
		}
	}
	
	private let throttle = Throttle(minimumDelay: 0.3)
	private var currentSearchNetworkTask: URLSessionDataTask?
	private var lastQuery: String?
	
	// Dependencies
	private let networkingService: NetworkingService
	
	init(networkingService: NetworkingService) {
		self.networkingService = networkingService
	}
	
	// Inputs
	func ready() {
		isRefreshing?(true)
		networkingService.searchRepos(withQuery: "swift") { [weak self] repos in
			guard let strongSelf  = self else { return }
			strongSelf.finishSearching(with: repos)
		}
	}
	
	func didChangeQuery(_ query: String) {
		guard query.count > 2,
			query != lastQuery else { return } // distinct until changed
		lastQuery = query
		
		throttle.throttle {
			self.startSearchWithQuery(query)
		}
	}
	
	func didSelectRow(at indexPath: IndexPath) {
		if repos.isEmpty { return }
		didSelecteRepo?(repos[indexPath.item].id)
	}
	
	// Private
	private func startSearchWithQuery(_ query: String) {
		currentSearchNetworkTask?.cancel() // cancel previous pending request
		
		isRefreshing?(true)

		currentSearchNetworkTask = networkingService.searchRepos(withQuery: query) { [weak self] repos in
			guard let strongSelf  = self else { return }
			strongSelf.finishSearching(with: repos)
		}
	}
	
	private func finishSearching(with repos: [Repo]) {
		isRefreshing?(false)
		self.repos = repos
	}
}

struct RepoViewModel {
	let name: String
}

extension RepoViewModel {
	init(repo: Repo) {
		self.name = repo.name
	}
}
		
		EOS
	end

	def self.create_service_file
		return 	<<-EOS
import Foundation

protocol NetworkingService {
	@discardableResult func searchRepos(withQuery query: String, completion: @escaping ([Repo]) -> ()) -> URLSessionDataTask
}

final class NetworkingApi: NetworkingService {
	private let session = URLSession.shared
	
	@discardableResult
	func searchRepos(withQuery query: String, completion: @escaping ([Repo]) -> ()) -> URLSessionDataTask {
		let request = URLRequest(url: URL(string: "https://api.github.com/search/repositories?q=\(query)")!)
		let task = session.dataTask(with: request) { (data, _, _) in
			DispatchQueue.main.async {
				guard let data = data,
					let response = try? JSONDecoder().decode(SearchResponse.self, from: data) else {
						completion([])
						return
				}
				completion(response.items)
			}
		}
		task.resume()
		return task
	}
}

fileprivate struct SearchResponse: Decodable {
	let items: [Repo]
}
		EOS
	end

end