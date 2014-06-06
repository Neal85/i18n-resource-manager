path = require 'path'

DefaultOptions = require '../lib/default-options'
ResourceManager = require '../lib/resource-manager'

pathStr = path.join process.cwd(), 'html'
console.log "Path: ", pathStr

DefaultOptions.phyPath = pathStr
DefaultOptions.key.platform = "apple"
DefaultOptions.key.subPlatform = ""
DefaultOptions.isMultifile = true

rm = new ResourceManager DefaultOptions
