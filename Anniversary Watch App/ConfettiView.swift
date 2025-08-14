import SwiftUI

// A single piece of confetti
private struct ConfettiPiece: Hashable {
    let id = UUID()
    var position: CGPoint
    var velocity: CGVector
    let color: Color
    let size: CGFloat
    var rotation: Angle
    var rotationalVelocity: Angle

    mutating func update(in size: CGSize) {
        // Apply gravity-like effect
        velocity.dy += 0.2

        // Update position
        position.x += velocity.dx
        position.y += velocity.dy

        // Update rotation
        rotation += rotationalVelocity

        // Reset if it falls off the bottom, send it back to the top
        if position.y > size.height + size.height * 0.1 {
            position = CGPoint(x: .random(in: 0...size.width), y: -size.height * 0.1)
            velocity = CGVector(dx: .random(in: -5...5), dy: .random(in: 5...15))
        }
    }
}

// The view that renders the confetti
struct ConfettiView: View {
    @State private var pieces: [ConfettiPiece] = []
    private let colors: [Color] = [.red, .green, .blue, .yellow, .purple, .orange, .pink]

    var body: some View {
        GeometryReader { geometry in
            TimelineView(.animation(minimumInterval: 1.0 / 60.0, paused: false)) { timeline in
                Canvas { context, size in
                    for piece in pieces {
                        var pieceContext = context
                        pieceContext.translateBy(x: piece.position.x, y: piece.position.y)
                        pieceContext.rotate(by: piece.rotation)

                        let rect = CGRect(x: -piece.size / 2, y: -piece.size / 2, width: piece.size, height: piece.size)
                        pieceContext.fill(Path(rect), with: .color(piece.color))
                    }
                }
                .onChange(of: timeline.date) { _, _ in
                    for i in pieces.indices {
                        pieces[i].update(in: geometry.size)
                    }
                }
            }
            .onAppear {
                if pieces.isEmpty {
                    pieces = createPieces(in: geometry.size)
                }
            }
        }
        .allowsHitTesting(false) // Let taps pass through to views behind
    }

    private func createPieces(count: Int = 75, in size: CGSize) -> [ConfettiPiece] {
        var newPieces: [ConfettiPiece] = []
        for _ in 0..<count {
            let piece = ConfettiPiece(
                position: CGPoint(x: .random(in: 0...size.width), y: .random(in: -size.height...0)),
                velocity: CGVector(dx: .random(in: -5...5), dy: .random(in: 5...15)),
                color: colors.randomElement()!,
                size: .random(in: 6...12),
                rotation: .degrees(.random(in: 0...360)),
                rotationalVelocity: .degrees(.random(in: -10...10))
            )
            newPieces.append(piece)
        }
        return newPieces
    }
}
