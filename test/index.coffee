path = require 'path'
fs = require 'fs'

ResourceType = require('../index').ResourceType
ResourceOptions = require('../index').ResourceOptions
ResourceManager = require('../index').ResourceManager

# Html ============================================================
options = new ResourceOptions();
options.phyPath = path.join process.cwd(), 'html'
options.key.platform = "platform"
options.key.subPlatform = "null"
options.key.country = "US"
options.key.flag = "HTML"
options.key.resourceType = ResourceType.OVERRIDE
options.rules = [
  '_default/country/_default',
  '_default/country/{country}',
  '_default/{subPlatform}/country/_default',
  '_default/{subPlatform}/country/{country}',
  '{platform}/country/_default',
  '{platform}/country/{country}',
  '{platform}/{subPlatform}/country/_default',
  '{platform}/{subPlatform}/country/{country}'
]

htmlResource = new ResourceManager options
console.log 'HTML ----------------------------'
console.log 'IndexKey: \n', htmlResource.getIndexKey()
console.log 'Cache: \n', htmlResource.getCache()

console.log "OUTPUT *******************"
console.log 'index.html:', htmlResource.get('index.html')
console.log 'specific.html:', htmlResource.get('specific.html')
console.log 'future.html:', htmlResource.get('module','specific','future.html')
console.log 'END HTML ------------------------'

# CSS ============================================================
cssOptions = new ResourceOptions();
cssOptions.phyPath = path.join process.cwd(), 'css'
cssOptions.key.platform = "platform"
cssOptions.key.subPlatform = "null"
cssOptions.key.lang = "en"
cssOptions.key.country = "US"
cssOptions.key.flag = "CSS"
cssOptions.key.resourceType = ResourceType.APPEND
cssOptions.rules = [
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
styleResource = new ResourceManager cssOptions
console.log 'CSS ----------------------------'
console.log 'IndexKey: \n', styleResource.getIndexKey()
console.log 'Cache: \n', styleResource.getCache()

console.log "OUTPUT *******************"
console.log 'style.css:', styleResource.get('style.css')
console.log 'apple.css:', styleResource.get('apple.css')
console.log 'module.css:', styleResource.get('module','module.css')
console.log 'END CSS ------------------------'


# Config ============================================================
configOptions = new ResourceOptions();
configOptions.phyPath = path.join process.cwd(), 'properties'
configOptions.key.platform = "null"
configOptions.key.subPlatform = "null"
configOptions.key.country = "CN"
configOptions.key.resourceType = ResourceType.PROPERTIES
configOptions.key.flag = "config"
configOptions.rules = [
  'country/_default',
  'country/{country}'
]
configResource = new ResourceManager configOptions
console.log 'Config ----------------------------'
console.log 'IndexKey: \n', configResource.getIndexKey()
console.log 'Cache: \n', configResource.getCache()

console.log "OUTPUT *******************"
console.log 'config.json item:', configResource.get('config.json').item
console.log 'language.properties save:', configResource.get('language.properties').button?.save
console.log 'END Config ------------------------'

# ENV ============================================================
envOptions = new ResourceOptions();
envOptions.phyPath = path.join process.cwd(), 'properties'
envOptions.key.resourceType = ResourceType.PROPERTIES
envOptions.key.env = "prod"
envOptions.key.flag = "env"
envOptions.rules = [
  'env/{env}'
]
envResource = new ResourceManager envOptions
console.log 'ENV ----------------------------'
console.log 'IndexKey: \n', envResource.getIndexKey()
console.log 'Cache: \n', envResource.getCache()

console.log "OUTPUT *******************"
console.log 'config.properties env.name:', envResource.get('config.properties').env?.name
console.log 'END ENV ------------------------'

# no locale ============================================================
nOptions = new ResourceOptions();
nOptions.phyPath = path.join process.cwd(), 'properties'
nOptions.key.resourceType = ResourceType.PROPERTIES
nOptions.key.flag = "nolocale"
nOptions.rules = [
  'nolocale/'
]
nResource = new ResourceManager nOptions
console.log 'No Locale ----------------------------'
console.log 'IndexKey: \n', nResource.getIndexKey()
console.log 'Cache: \n', nResource.getCache()

console.log "OUTPUT *******************"
console.log 'config.properties namespace.item:', nResource.get('config.properties').namespace?.item
console.log 'END No Locale ------------------------'