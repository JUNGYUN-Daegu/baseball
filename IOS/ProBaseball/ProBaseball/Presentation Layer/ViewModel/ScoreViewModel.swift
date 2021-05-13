//
//  ScoreViewModel.swift
//  ProBaseball
//
//  Created by 조중윤 on 2021/05/11.
//

import Foundation
import Combine

class ScoreViewModel {
    private let scoreUseCase: ScoreUseCaseProtocol
    private var subscriptions = Set<AnyCancellable>()
    @Published var game: Game?
    public var statistics: [[Int]] = [[0,0,0],[0,0,0]]
    
    init(scoreUseCase: ScoreUseCaseProtocol) {
        self.scoreUseCase = scoreUseCase
    }
    
    func fetchGameInfo() {
        scoreUseCase.fetchGameInformation(endpoint: Endpoint.game).sink { (completion) in
            switch completion {
            case .failure(let error):
                assertionFailure("\(error)")
            case .finished:
                break
            }
        } receiveValue: { (game) in
            self.game = game
        }.store(in: &subscriptions)
    }
    
    func didUpdateGameInfo(completion: @escaping ((Game) ->())) {
        $game
            .sink { (game) in
                if game != nil {
                    self.calculateStatistics(with: game!)
                    completion(game!)
                } else {
                    return
                }
        }.store(in: &subscriptions)
    }
    
    func calculateStatistics(with game: Game) {
        for player in game.myTeam.players {
            statistics[0][0] += player.plateAppearance
            statistics[0][1] += player.hitsNumbers
            statistics[0][2] += player.accumulatedOutCount
        }
        
        for player in game.opponentTeam.players {
            statistics[1][0] += player.plateAppearance
            statistics[1][1] += player.hitsNumbers
            statistics[1][2] += player.accumulatedOutCount
        }
    }
}
