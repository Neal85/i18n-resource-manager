path = require 'path'
fs = require 'fs'

ResourceType = require('../lib/resource-manager').ResourceType
DefaultOptions = require('../lib/resource-manager').DefaultOptions
ResourceManager = require('../lib/resource-manager').ResourceManager

### Html
DefaultOptions.phyPath = path.join process.cwd(), 'html'
DefaultOptions.key.platform = "apple"
DefaultOptions.key.subPlatform = "_null"
DefaultOptions.key.lang = "en"
DefaultOptions.key.resourceType = ResourceType.OVERRIDE
rm = new ResourceManager DefaultOptions
###


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
DefaultOptions.key.country = "CN"
DefaultOptions.key.resourceType = ResourceType.PROPERTIES
DefaultOptions.rules = [
  'country/_default/',
  'country/{country}/'
]
rm = new ResourceManager DefaultOptions
###

data = fs.readFileSync('config.properties')
#data = fs.readFileSync('kk.txt')
console.log typeof(data)
console.log data.toString()

lines = data.toString().split('\r\n');

for l,i in lines
  console.log i, l


