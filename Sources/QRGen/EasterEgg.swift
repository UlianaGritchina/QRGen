import CoreMotion
import SwiftUI
import SpriteKit

//MARK: - EasterEggModifire
public struct EasterEggModifire: ViewModifier {
    @State private var isPresentedEggs = false
    
    public func body(content: Content) -> some View {
        content
            .onTapGesture(count: 3) { isPresentedEggs.toggle() }
            .fullScreenCover(isPresented: $isPresentedEggs) {
                EasterEggView()
            }
    }
}

//MARK: - View extension
public extension View {
    func easterEgg() -> some View {
        modifier(EasterEggModifire())
    }
}

// MARK: - EggsView
struct EasterEggView: View {
    @StateObject var vm = EggsViewViewModel()
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack {
            SpriteView(scene: vm.eggsRainScene)
                .overlay(alignment: .topTrailing) { closeButton }
        }
        .ignoresSafeArea()
    }
    
    private var closeButton: some View {
        Button(action: {dismiss()}) {
            Text("Закрыть")
                .foregroundColor(Color("mh-blue"))
                .font(.headline)
                .padding(4)
                .background { Color.white.cornerRadius(5) }
        }
        .padding(.top, 50)
        .padding(.trailing, 20)
    }
}

// MARK: - EggsViewViewModel
enum GameType {
    case bigEggs
    case eggsRain
}

final class EggsViewViewModel: ObservableObject {
    
    var eggsRainScene: SKScene {
        let scene = EggsRainScene()
        scene.size = CGSize(width: UIScreen.main.bounds.width, height: 600)
        scene.scaleMode = .fill
        return scene
    }
    
}

// MARK: - EggsRainScene
final class EggsRainScene: SKScene {
    
    private let motionManager = CMMotionManager()
    var scoreLabel: SKLabelNode!
    var score: Int = 0 {
        didSet { scoreLabel.text = "Score: \(score)" }
    }
    
    override func didMove(to view: SKView) {
        motionManager.startAccelerometerUpdates()
        addBackgraund()
        addScoreLabel()
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        addEgg(location)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            addEgg(location)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        setupGravity()
    }
    
    private func addBackgraund() {
        let background = SKSpriteNode(imageNamed: "eggsBack")
        background.size = self.frame.size
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        background.zPosition = -1
        addChild(background)
    }
    
    private func addScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.zPosition = 1
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 60)
        addChild(scoreLabel)
    }
    
    
    private func addEgg(_ location: CGPoint) {
        let egg = generateEgg(location)
        addChild(egg)
        score += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            egg.removeFromParent()
            self.score -= 1
        }
    }
    
    private func generateEgg(_ location: CGPoint) -> SKSpriteNode {
        let egg = SKSpriteNode(imageNamed: "egg\(Int.random(in: 1...9))")
        egg.position = location
        egg.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 30, height: 40))
        egg.physicsBody?.restitution = 0.0
        egg.size = CGSize(width: 50, height: 50)
        egg.position.x = location.x
        egg.position.y = location.y
        return egg
    }
    
    private func setupGravity() {
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(
                dx: accelerometerData.acceleration.x * 12,
                dy: accelerometerData.acceleration.y * 12
            )
        }
    }
    
}
