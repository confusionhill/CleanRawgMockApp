//
//  MainContentHomeVM.swift
//  CleanRawgMockApp
//
//  Created by Farhandika Zahrir Mufti guenia on 23/08/21.
//

import Foundation
import Combine

class MainContentHome:ObservableObject {
    
    enum state {
        case loading,idle,done,failed
    }
    
    @Published var State:state = .idle
    @Published var MainContent = [BasicHome]()
    private var myAPI = Api()
    private var page = 1
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        fetchAPI()
    }
    
    func fetchAPI() {
        //Idle is the 1st state, when the app loads, loading state is when we want to add more content to it
        if State != .idle {
            State = .loading
        }
        let path = {() -> URLComponents in
            self.myAPI.link!.path = "/api/games"
            self.myAPI.link!.queryItems = [
                URLQueryItem(name: "key", value: self.myAPI.key),
                URLQueryItem(name: "ordering", value: "updated"),
                URLQueryItem(name: "page", value: String(page))
            ]
            return myAPI.link!
        }()
        
        let request = URLRequest(url: path.url!)
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { $0.data }
            .decode(type: HomeModelBasic.self, decoder: JSONDecoder())
            .receive(on:RunLoop.main)
            .sink {[weak self] complete in
                switch complete {
                case .finished :
                    print("fetching Main Content :\(complete) on page \(self!.page)")
                    self?.page+=1 // ini masih harus diperbaikin logicnya, sayang ga kepake
                case .failure(let error):
                    print("the error : \(error)")
                    self?.State = .failed
                }
            } receiveValue: { [weak self] result in
                self?.MainContent += result.results
                self?.State = .done
            }
            .store(in: &cancellables)

    }
}

extension MainContentHome {
    func appendData(currentItem item: BasicHome?){
        if self.State == .failed {return}
        guard let item = item else {
            fetchAPI()
            return
        }
        let itemIdx = MainContent.index(MainContent.endIndex, offsetBy: -5)
        if MainContent.firstIndex(where: { $0.id == item.id }) == itemIdx {
              fetchAPI()
            }
    }
}
