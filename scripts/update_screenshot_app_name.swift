import AppKit
import Foundation

struct TitlePatch {
    let rect: CGRect
    let fontSize: CGFloat
    let expansion: Int
}

let replacementTitle = "LIFELOOP"
let patches: [(prefix: String, patches: [TitlePatch])] = [
    ("AppStoreScreenshots/raw/", [
        TitlePatch(rect: CGRect(x: 455, y: 190, width: 410, height: 92), fontSize: 44, expansion: 3)
    ]),
    ("AppStoreScreenshots/final/", [
        TitlePatch(rect: CGRect(x: 500, y: 690, width: 320, height: 76), fontSize: 34, expansion: 3)
    ]),
    ("docs/lifeloop/assets/screens/", [
        TitlePatch(rect: CGRect(x: 154, y: 63, width: 134, height: 34), fontSize: 16, expansion: 1),
        TitlePatch(rect: CGRect(x: 174, y: 223, width: 94, height: 33), fontSize: 14, expansion: 1)
    ])
]

func patchesFor(path: String) -> [TitlePatch] {
    patches.first { path.hasPrefix($0.prefix) }?.patches ?? []
}

func isTitlePixel(_ color: NSColor) -> Bool {
    guard let color = color.usingColorSpace(.deviceRGB) else {
        return false
    }

    let brightness = (color.redComponent + color.greenComponent + color.blueComponent) / 3
    return brightness < 0.52 && color.alphaComponent > 0.6
}

func backgroundColor(in rep: NSBitmapImageRep, rect: CGRect) -> NSColor {
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var count: CGFloat = 0

    let minX = max(0, Int(rect.minX))
    let maxX = min(rep.pixelsWide - 1, Int(rect.maxX))
    let minY = max(0, Int(rect.minY))
    let maxY = min(rep.pixelsHigh - 1, Int(rect.maxY))

    for y in minY...maxY {
        for x in minX...maxX {
            guard let color = rep.colorAt(x: x, y: y)?.usingColorSpace(.deviceRGB),
                  !isTitlePixel(color)
            else {
                continue
            }

            red += color.redComponent
            green += color.greenComponent
            blue += color.blueComponent
            count += 1
        }
    }

    guard count > 0 else {
        return NSColor(calibratedWhite: 0.97, alpha: 1)
    }

    return NSColor(
        calibratedRed: red / count,
        green: green / count,
        blue: blue / count,
        alpha: 1
    )
}

func eraseTitle(in rep: NSBitmapImageRep, patch: TitlePatch) {
    let bg = backgroundColor(in: rep, rect: patch.rect)
    let minX = max(0, Int(patch.rect.minX))
    let maxX = min(rep.pixelsWide - 1, Int(patch.rect.maxX))
    let minY = max(0, Int(patch.rect.minY))
    let maxY = min(rep.pixelsHigh - 1, Int(patch.rect.maxY))
    var mask = Set<Int>()

    for y in minY...maxY {
        for x in minX...maxX {
            guard let color = rep.colorAt(x: x, y: y), isTitlePixel(color) else {
                continue
            }

            for dy in -patch.expansion...patch.expansion {
                for dx in -patch.expansion...patch.expansion {
                    let px = x + dx
                    let py = y + dy
                    guard px >= minX, px <= maxX, py >= minY, py <= maxY else {
                        continue
                    }
                    mask.insert(py * rep.pixelsWide + px)
                }
            }
        }
    }

    for key in mask {
        let x = key % rep.pixelsWide
        let y = key / rep.pixelsWide
        rep.setColor(bg, atX: x, y: y)
    }
}

func drawTitle(in rep: NSBitmapImageRep, patch: TitlePatch) {
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
    NSGraphicsContext.current?.imageInterpolation = .high

    let paragraph = NSMutableParagraphStyle()
    paragraph.alignment = .center
    let attributes: [NSAttributedString.Key: Any] = [
        .font: NSFont.systemFont(ofSize: patch.fontSize, weight: .semibold),
        .foregroundColor: NSColor.black,
        .paragraphStyle: paragraph
    ]

    let drawY = CGFloat(rep.pixelsHigh) - patch.rect.maxY
    let drawRect = CGRect(
        x: patch.rect.minX,
        y: drawY + (patch.rect.height - patch.fontSize - 8) / 2,
        width: patch.rect.width,
        height: patch.fontSize + 8
    )
    replacementTitle.draw(in: drawRect, withAttributes: attributes)

    NSGraphicsContext.restoreGraphicsState()
}

func updateImage(path: String, patches: [TitlePatch]) throws {
    let url = URL(fileURLWithPath: path)
    guard let image = NSImage(contentsOf: url),
          let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil)
    else {
        throw NSError(domain: "ScreenshotTitle", code: 1, userInfo: [NSLocalizedDescriptionKey: "Cannot load \(path)"])
    }

    let width = cgImage.width
    let height = cgImage.height
    guard let rep = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: width,
        pixelsHigh: height,
        bitsPerSample: 8,
        samplesPerPixel: 4,
        hasAlpha: true,
        isPlanar: false,
        colorSpaceName: .deviceRGB,
        bytesPerRow: width * 4,
        bitsPerPixel: 32
    ) else {
        throw NSError(domain: "ScreenshotTitle", code: 2, userInfo: [NSLocalizedDescriptionKey: "Cannot create bitmap for \(path)"])
    }

    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
    NSGraphicsContext.current?.imageInterpolation = .high
    NSImage(cgImage: cgImage, size: NSSize(width: width, height: height))
        .draw(in: CGRect(x: 0, y: 0, width: width, height: height))
    NSGraphicsContext.restoreGraphicsState()

    for patch in patches {
        eraseTitle(in: rep, patch: patch)
        drawTitle(in: rep, patch: patch)
    }

    guard let png = rep.representation(using: .png, properties: [:]) else {
        throw NSError(domain: "ScreenshotTitle", code: 2, userInfo: [NSLocalizedDescriptionKey: "Cannot encode \(path)"])
    }

    try png.write(to: url)
    print("updated \(path)")
}

do {
    for path in CommandLine.arguments.dropFirst() {
        let patches = patchesFor(path: path)
        if !patches.isEmpty {
            try updateImage(path: path, patches: patches)
        }
    }
} catch {
    fputs("\(error.localizedDescription)\n", stderr)
    exit(1)
}
