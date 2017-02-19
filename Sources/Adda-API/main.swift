//
//  main.swift
//  PerfectTemplate
//
//  Created by Kyle Jessup on 2015-11-05.
//	Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

// import EventChatModel
import ToDoModel
import StORM
import PostgresStORM
import PerfectTurnstilePostgreSQL
import TurnstilePerfect


// Create HTTP Server
let server = HTTPServer()

// Registrer routes and handlers
let atuhWebRoutes = makeWebAuthRoutes()
let authJSONRoutes = makeJSONAuthRoutes()

// Add the routes to the server.
server.addRoutes(atuhWebRoutes)
server.addRoutes(authJSONRoutes)

// Set the connection properties for the Postgres Server
// Change to suit your specific environment
PostgresConnector.host        = "localhost"
PostgresConnector.username    = "alif"
PostgresConnector.password    = ""
PostgresConnector.database    = "adda_api"
PostgresConnector.port        = 5432

// Setup our EventChat in the Database and setup table is it doesn't exit


// User later is sript for the Realm and the user authenticates
let pturnstile = TurnstilePerfectRealm()

// Setup the Authentication table is it doesn't exist
let auth = AuthAccount()
try? auth.setup()

// Connect the AccessTokenStore and setup table if it doesn't exist
tokenStore = AccessTokenStore()
try? tokenStore?.setup()

// add routes to be excluded from auth check
var authenticationConfig = AuthenticationConfig()
authenticationConfig.exclude("/api/v1/login")
authenticationConfig.exclude("/api/v1/register")
// add routes to be checked for auth
authenticationConfig.include("/api/v1/count")
authenticationConfig.include("/api/v1/get/all")
authenticationConfig.include("/api/v1/create")
authenticationConfig.include("/api/v1/update")
authenticationConfig.include("/api/v1/delete")

let authFilter = AuthFilter(authenticationConfig)

// Note that order matters when the filters are of the same priority level
server.setRequestFilters([pturnstile.requestFilter])
server.setResponseFilters([pturnstile.responseFilter])

server.setRequestFilters([(authFilter, .high)])


// Setup main API
let routes = Router().makeRoutes()
server.addRoutes(routes)

// Set a listen port of 8181
server.serverPort = 8181

do {
    // Launch the servers based on the configuration data.
    try server.start()
} catch {
    fatalError("\(error)") // fatal error launching one of the servers
}
