
path = require 'path'
fs = require 'fs'
Utils = require './utils'

ResourceType = {
  "OVERRIDE": 0,
  "APPEND": 1,
  "PROPERTIES": 2
}

DefaultOptions = {
  key: { platform: "_null", subPlatform: "_null", country: "US", resourceType: ResourceType.OVERRIDE },
  phyPath: process.cwd(),
  rules: [
    '_default/country/_default',
    '_default/country/{country}',
    '_default/{subPlatform}/country/_default',
    '_default/{subPlatform}/country/{country}',
    '{platform}/country/_default',
    '{platform}/country/{country}',
    '{platform}/{subPlatform}/country/_default',
    '{platform}/{subPlatform}/country/{country}'
  ]
}


class ResourceManager
  constructor: (@options)->
    @resourceUtils = new ResourceUtils(@options)

class ResourceUtils
  constructor: (@options)->
    @options = Utils.FillObject DefaultOptions, @options, "full"
    @options.rules = this.resolveRules @options
    this.buildRules()

  # Resolver Rules
  resolveRules: (opts)->
    results = new Array()
    key = opts.key
    rules = opts.rules;
    for item in rules
      rule = item
      for p of key
        reg = new RegExp '({'+p+'})', 'g'
        rule = rule.replace reg, key[p]
      if rule.indexOf('{') isnt -1 or rule.indexOf('}') isnt -1 then throw new Error 'Resolve rules error! rule: '+ item
      results.push(path.normalize(rule))

    return results

  # Build Rules
  buildRules:()->
    if @options.key.resourceType is ResourceType.OVERRIDE or @options.key.resourceType is ResourceType.APPEND
      console.log this.buildFilesByRules(@options)
    else if @options.key.resourceType is ResourceType.PROPERTIES
      @options.key.resourceType = ResourceType.APPEND
      console.log this.buildFilesByRules(@options)

    else
      throw new Error('Resource type invalid! Please check your options.resourceType.')

  buildFilesByRules: (opts)->
    results = {}
    for relativePath, i in opts.rules
      folderPhyPath = path.join opts.phyPath, relativePath
      if fs.existsSync(folderPhyPath)
        this.buildFilesByDirectory opts, results, folderPhyPath, relativePath, null
    return results

  buildFilesByDirectory: (opts, files, folderPath, relativePath, prefix)->
    childes = fs.readdirSync folderPath
    for fName,i in childes
      itemPhyPath = path.join folderPath, fName
      itemRelativePath = path.join relativePath, fName

      rule = item for item in opts.rules when item.replace(path.sep) is itemRelativePath.replace(path.sep)
      if rule isnt undefined then continue

      fName = if prefix then prefix + '-' + fName else fName
      fStat = fs.statSync itemPhyPath
      if fStat.isFile()
        if typeof(files[fName.toLowerCase()]) isnt "undefined"
          if opts.key.resourceType is ResourceType.APPEND
            isExists = item for item in files[fName.toLowerCase()] when item is itemRelativePath
            if(!isExists) then files[fName.toLowerCase()].push(itemRelativePath)
          else
            files[fName.toLowerCase()] = itemRelativePath
        else
          if opts.key.resourceType is ResourceType.APPEND
            files[fName.toLowerCase()] = [itemRelativePath]
          else
            files[fName.toLowerCase()] = itemRelativePath
      else if fStat.isDirectory()
        if fs.existsSync(folderPath) then this.buildFilesByDirectory opts, files, itemPhyPath, itemRelativePath, fName

  buildProperties: (filesDic)->
    result = {}
    for filename of filesDic
      files = filesDic[filename]

      if path.extname(filename).toLowerCase() is "json"
        result[filename] = this.handleJSONFile files
      else
        result[filename] = this.handlePropertyFile files

    return result

  handleJSONFile: (files)->
    result = null
    for f in files
      data = fs.ReadFileSync(f, {encoding: "utf8"});
      obj = JSON.parse data
      if result is null then result = obj else result = Utils.FillObject(result, obj, "full")

    return result


  handlePropertyFile: (files)->










exports.ResourceType = ResourceType
exports.DefaultOptions = DefaultOptions
exports.ResourceManager = ResourceManager