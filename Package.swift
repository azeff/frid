import PackageDescription

let package = Package(
    name: "frid",
    targets: [
      Target(name: "fridgen", dependencies: ["frid"])
    ]
)
