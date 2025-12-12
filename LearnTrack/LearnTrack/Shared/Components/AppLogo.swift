import SwiftUI

struct AppLogo: View {
    var size: CGFloat = 120
    @Environment(\.colorScheme) var colorScheme
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var body: some View {
        ZStack {
            ShieldShape()
                .fill(Color.white)
                .frame(width: size, height: size)
                .overlay(
                    ShieldShape()
                        .stroke(
                            Color(red: 0.25, green: 0.3, blue: 0.5),
                            lineWidth: size * 0.04
                        )
                )
            
            VStack(spacing: 0) {
                HStack(spacing: size * 0.15) {
                    Circle()
                        .fill(Color.white)
                        .frame(width: size * 0.25, height: size * 0.25)
                        .overlay(
                            Circle()
                                .fill(Color.black)
                                .frame(width: size * 0.08, height: size * 0.08)
                        )
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: size * 0.25, height: size * 0.25)
                        .overlay(
                            Circle()
                                .fill(Color.black)
                                .frame(width: size * 0.08, height: size * 0.08)
                        )
                }
                .offset(y: -size * 0.15)
                
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(Color(red: 0.6, green: 0.65, blue: 0.75))
                        .frame(width: size * 0.5, height: size * 0.35)
                    
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: size * 0.5, height: size * 0.35)
                }
                .offset(y: size * 0.1)
                
                DiamondShape()
                    .fill(Color.white)
                    .frame(width: size * 0.12, height: size * 0.08)
                    .offset(y: size * 0.05)
            }
        }
        .shadow(color: Color.black.opacity(0.2), radius: 10, y: 5)
    }
}

struct ShieldShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        path.move(to: CGPoint(x: width * 0.5, y: 0))
        path.addLine(to: CGPoint(x: width * 0.15, y: height * 0.2))
        path.addLine(to: CGPoint(x: width * 0.1, y: height * 0.4))
        path.addLine(to: CGPoint(x: width * 0.15, y: height * 0.65))
        path.addLine(to: CGPoint(x: width * 0.3, y: height * 0.9))
        path.addLine(to: CGPoint(x: width * 0.5, y: height))
        path.addLine(to: CGPoint(x: width * 0.7, y: height * 0.9))
        path.addLine(to: CGPoint(x: width * 0.85, y: height * 0.65))
        path.addLine(to: CGPoint(x: width * 0.9, y: height * 0.4))
        path.addLine(to: CGPoint(x: width * 0.85, y: height * 0.2))
        path.closeSubpath()
        
        return path
    }
}

struct DiamondShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        path.move(to: CGPoint(x: width * 0.5, y: 0))
        path.addLine(to: CGPoint(x: width, y: height * 0.5))
        path.addLine(to: CGPoint(x: width * 0.5, y: height))
        path.addLine(to: CGPoint(x: 0, y: height * 0.5))
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    VStack(spacing: 40) {
        AppLogo(size: 120)
        AppLogo(size: 80)
        AppLogo(size: 60)
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}

