path = require 'path'
fs = require 'fs'

ResourceType = require('../lib/resource-manager').ResourceType
ResourceOptions = require('../lib/resource-manager').ResourceOptions
ResourceManager = require('../lib/resource-manager').ResourceManager

# Html
options = new ResourceOptions();
options.phyPath = path.join process.cwd(), 'html'
options.key.platform = "apple"
options.key.subPlatform = "_null"
options.key.lang = "en"
options.key.resourceType = ResourceType.OVERRIDE
rm = new ResourceManager options



### CSS
DefaultOptions.phyPath = path.join process.cwd(), 'css'
DefaultOptions.key.platform = "apple"
DefaultOptions.key.subPlatform = "_null"
DefaultOptions.key.lang = "en"
DefaultOptions.key.resourceType = ResourceType.APPEND
DefaultOptions.rules = [
  '_default/lang/_default',
  '_default/lang/_default/{country}',
  '_default/lang/{lang}/{country}',
  '{platform}/lang/_default',
  '{platform}/lang/_default/{country}',
  '{platform}/lang/{lang}/{country}',
  '_default/{subPlatform}/lang/_default',
  '_default/{subPlatform}/lang/_default/{country}',
  '_default/{subPlatform}/lang/{lang}/{country}',
  '{platform}/{subPlatform}/lang/_default',
  '{platform}/{subPlatform}/lang/_default/{country}',
  '{platform}/{subPlatform}/lang/{lang}/{country}'
]
rm = new ResourceManager DefaultOptions
###

###
DefaultOptions.phyPath = path.join process.cwd(), 'properties'
DefaultOptions.key.platform = "apple"
DefaultOptions.key.subPlatform = "_null"
DefaultOptions.key.country = "US"
DefaultOptions.key.resourceType = ResourceType.PROPERTIES
DefaultOptions.key.flag = "countryConfig"
DefaultOptions.rules = [
  'country/_default',
  'country/{country}'
]

console.log "Phy Path: ", DefaultOptions.phyPath
rm = new ResourceManager DefaultOptions

DefaultOptions.phyPath = path.join process.cwd(), 'properties'
DefaultOptions.key.platform = "apple"
DefaultOptions.key.subPlatform = "_null"
DefaultOptions.key.country = "US"
DefaultOptions.key.resourceType = ResourceType.PROPERTIES
DefaultOptions.key.flag = "env"
DefaultOptions.rules = [
  'env/dev'
]

console.log "Phy Path: ", DefaultOptions.phyPath
rm = new ResourceManager DefaultOptions

###