// Generated automatically by Perfect Assistant Application
// Date: 2017-02-17 19:33:04 +0000
import PackageDescription

let package = Package(
    name: "AddaApi",
    targets: [
        Target(
            name: "Adda-API",
            dependencies: [
                .Target(name: "ToDoModel")
            ]
        ),
        Target(
            name: "ToDoModel",
            dependencies: []
        )
    ],
    
    dependencies: [
        .Package(url: "https://github.com/PerfectlySoft/Perfect-Turnstile-PostgreSQL.git", majorVersion: 1),
        .Package(url: "https://github.com/rymcol/SwiftSQL.git", majorVersion: 0),
    ]
)
