//
//  PlayViewController.swift
//  ProBaseball
//
//  Created by 조중윤 on 2021/05/04.
//

import UIKit
import Foundation

enum BallCountSection: CaseIterable {
    case main
}

class PlayViewController: UIViewController {
    @IBOutlet weak var currentPitcher: UILabel!
    @IBOutlet weak var currentBatter: UILabel!
    @IBOutlet weak var currentPitcherNum: UILabel!
    @IBOutlet weak var strikeStackView: UIStackView!
    @IBOutlet weak var ballStackView: UIStackView!
    @IBOutlet weak var outStackView: UIStackView!
    @IBOutlet weak var currentBatterDescription: UILabel!
    @IBOutlet weak var inningLabel: UILabel!
    @IBOutlet weak var offenseOrDefense: UILabel!
    @IBOutlet weak var ballCountCollectionView: UICollectionView!
    lazy var dataSource = configureDataSource()
    
    @IBOutlet weak var playBackgroundView: PlayBackgroundView!
    var playerView: PlayerView!
    @IBOutlet weak var baseBall: UIImageView!
    var viewModel: PlayViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ballCountCollectionView.backgroundColor = .red
        ballCountCollectionView.register(UINib(nibName: "BallCountCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BallCountCollectionViewCell")
        ballCountCollectionView.dataSource = dataSource
        ballCountCollectionView.delegate = self
        bind()
        addBatterView()
        runToFirstBase()
        throwBall()
    }
    
    func depend(viewModel: PlayViewModel) {
        self.viewModel = viewModel
    }
    
    func addBatterView() {
        playerView = PlayerView(frame: CGRect(x: self.playBackgroundView.playView.bounds.midX-20, y: self.playBackgroundView.playView.bounds.maxY-20, width: 40, height: 40))
        self.playBackgroundView.playView.addSubview(playerView)
    }
    
    func PitchAnimation() {
        UIView.animate(withDuration:1,
        delay: 0,
        options: [],
        animations: {
            self.playerView.frame = CGRect(x: self.playBackgroundView.playView.bounds.midX-20, y: self.playBackgroundView.playView.bounds.maxY-20, width: 40, height: 40)
        },
        completion: { _ in self.runToSecondBase()})
    }
    
    func position(path: UIBezierPath, duration: Double, repeatCount: Float) -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position"
        animation.path = path.cgPath
        animation.duration = duration
        animation.timingFunctions = [CAMediaTimingFunction(name: .easeOut)]
        animation.repeatCount = repeatCount
        return animation
   }
    
    func createShadowLayer() -> CALayer {
        let shadowLayer = CALayer()
        shadowLayer.shadowColor = UIColor.red.cgColor
        shadowLayer.shadowOffset = CGSize.zero
        shadowLayer.shadowRadius = 2
        shadowLayer.shadowOpacity = 2
        shadowLayer.backgroundColor = UIColor.black.cgColor
        return shadowLayer
    }
    
    func throwBall() {
        
        let path = UIBezierPath()
        let line = CAShapeLayer()
 
        line.path = path.cgPath
        line.strokeColor = UIColor.blue.cgColor
        line.fillColor = UIColor.clear.cgColor
        line.lineWidth = 2.0
        baseBall.layer.addSublayer(line)

        path.move(to: CGPoint(x: baseBall.frame.midX, y: baseBall.frame.midY))
        path.addQuadCurve(to: CGPoint(x: playBackgroundView.playView.frame.midX, y: playBackgroundView.playView.frame.maxY), controlPoint: CGPoint(x: 220, y: 200))
        self.baseBall.layer.add(position(path: path, duration: 1.5, repeatCount: 3), forKey: "position")
        
    }
    
    func runToFirstBase() {
        UIView.animate(withDuration:1,
        delay: 0,
        options: [],
        animations: {
            self.playerView.frame = CGRect(x: self.playBackgroundView.playView.bounds.maxX-20, y: self.playBackgroundView.playView.bounds.midY-20, width: 40, height: 40)
        },
        completion: { _ in self.runToSecondBase()})
    }
    
    func runToSecondBase() {
        UIView.animate(withDuration:1,
        delay: 0,
        options: [],
        animations: {
        self.playerView.frame = CGRect(x: self.playBackgroundView.playView.bounds.midX-20, y: self.playBackgroundView.playView.bounds.minY-20, width: 40, height: 40)
        },
        completion: { _ in self.runToThirdBase()})
    }
    
    func runToThirdBase() {
        UIView.animate(withDuration:1,
        delay: 0,
        options: [],
        animations: {
        self.playerView.frame = CGRect(x: self.playBackgroundView.playView.bounds.minX-20, y: self.playBackgroundView.playView.bounds.midY-20, width: 40, height: 40)
        },
        completion: { _ in self.runToHomeBase() })
    }
    
    func runToHomeBase() {
        UIView.animate(withDuration:1,
        delay: 0,
        options: [],
        animations: {
        self.playerView.frame = CGRect(x: self.playBackgroundView.playView.bounds.midX-20, y: self.playBackgroundView.playView.bounds.maxY-20, width: 40, height: 40)
        },
        completion: nil)
    }
    
    func bind() {
        viewModel.fetchGame()
        viewModel.didUpdateGame { [weak self] (game) in
            self?.updateSnapshot(with: game)
            //현재타자
            if game.myTeam.isAttack == true {
                self?.currentBatter.text = game.myTeam.currentBatsman.name
            }
            
            //현재투수
            self?.currentPitcher.text = game.myTeam.currentPitcher.name
            //투수등판번호
            self?.currentPitcherNum.text = ""
            //1타석 0안타
            self?.currentBatterDescription.text = ""
            
            self?.strikeStackView.addSubview(UIView())
            self?.ballStackView.addSubview(UIView())
            self?.outStackView.addSubview(UIView())
            
            //2회초
            self?.inningLabel.text = ""
            //공격 또는 수비
            self?.offenseOrDefense.text = ""
        }
    }
    
    func configureDataSource() -> UICollectionViewDiffableDataSource<BallCountSection, Game> {
        let dataSource = UICollectionViewDiffableDataSource<BallCountSection, Game>(collectionView: ballCountCollectionView) { (collectionView, indexPath, game) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BallCountCollectionViewCell", for: indexPath) as! BallCountCollectionViewCell
            cell.ballState.text = "스트라이크"
            cell.cellCount.setTitle(String(indexPath.row), for: .normal)
            cell.ballStateHistoryNum.text = "\(game.ballCount.strike)-\(game.ballCount.ball)"
            return cell
        }
        return dataSource
    }
    
    func updateSnapshot(with: Game) {
        var snapshot = NSDiffableDataSourceSnapshot<BallCountSection, Game>()
        snapshot.appendSections(BallCountSection.allCases)
        snapshot.appendItems([with], toSection: BallCountSection.main)
       
        dataSource.apply(snapshot)
    }
}

extension PlayViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.ballCountCollectionView.frame.width, height: self.ballCountCollectionView.frame.height / 6)
    }
}
