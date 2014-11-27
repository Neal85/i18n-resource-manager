###
@author      Created by Haiwei Li <haiwei8086@gmail.com> on 2014-6-8.
@link        https://github.com/haiwei8086/i18n-resource-manager
@license     http://opensource.org/licenses/MIT
@version     0.0.1
###

path = require 'path'
fs = require 'fs'
Utils = require './utils'

ResourceType = {
  "OVERRIDE": "Override",
  "APPEND": "Append",
  "PROPERTIES": "Properties"
}

ResourceOptions= ()->
  this.key = {
    platform: '_default',
    subPlatform: '_default',
    country: '_default',
    flag: 'null',
    resourceType: ResourceType.OVERRIDE
  }
  this.phyPath = process.cwd()
  this.rules = [
    '_default/country/_default',
    '_default/country/{country}',
    '_default/{subPlatform}/country/_default',
    '_default/{subPlatform}/country/{country}',
    '{platform}/country/_default',
    '{platform}/country/{country}',
    '{platform}/{subPlatform}/country/_default',
    '{platform}/{subPlatform}/country/{country}'
  ]
  return this

class ResourceManager
  RESOURCE_KEY: "__localization_manager"
  constructor: (@options)->
    @resourceUtils = new ResourceUtils()
    @options.rules = @resourceUtils.resolveRules @options
    @indexKey = @resourceUtils.resolveKey @options.key

    if global[this.RESOURCE_KEY] is undefined or global[this.RESOURCE_KEY][@indexKey] is undefined
      if !global[this.RESOURCE_KEY]
        global[this.RESOURCE_KEY] = {}

      rulesCache = @resourceUtils.buildRules @options
      resource = global[this.RESOURCE_KEY]
      resource[@indexKey] = rulesCache

  ###
  Arguments:
  1: (filename) /index.html or folder/folder/index.html
  2: (folder..., filename) /part/view.html or /part/view/template.html
  ###
  get:()->
    key = ""
    prefix = ""
    if arguments.length > 1
      for item, i in arguments
        if i + 1 is arguments.length then break
        prefix += item + "-"

    if arguments.length > 0
      filePath = arguments[arguments.length - 1]
      if filePath.indexOf('/') is 0
        filePath = filePath.substr(1, filePath.length - 1)

      key = prefix + filePath.replace(/\//g, '-')
    else
      return null

    return global[this.RESOURCE_KEY][@indexKey]?[key]

  # get data from cache, use debug
  getCache: ()->
    return global[this.RESOURCE_KEY][@indexKey]

  getIndexKey: ()->
    return @indexKey

  getOptions: ()->
    return @options

  buildIndexKey: (options)->
    return @resourceUtils.resolveKey(options.key)

  # always build resource
  reBuild: ()->
    rulesCache = @resourceUtils.buildRules @options
    resource = global[this.RESOURCE_KEY] = {}
    resource[@indexKey] = rulesCache

class ResourceUtils
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

  resolveKey: (key)->
    result = ""
    for p of key
      if result isnt "" then result += "-"
      result += key[p]

    return result

  buildRules:(options)->
    if options.key.resourceType is ResourceType.OVERRIDE or options.key.resourceType is ResourceType.APPEND
      return this.buildFilesByRules(options)
    else if options.key.resourceType is ResourceType.PROPERTIES
      filesDic = this.buildFilesByRules(options)
      return this.buildProperties(options, filesDic)
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
          if opts.key.resourceType is ResourceType.OVERRIDE
            files[fName.toLowerCase()] = itemRelativePath
          else
            isExists = item for item in files[fName.toLowerCase()] when item is itemRelativePath
            if(!isExists) then files[fName.toLowerCase()].push(itemRelativePath)

        else
          if opts.key.resourceType is ResourceType.OVERRIDE
            files[fName.toLowerCase()] = itemRelativePath
          else
            files[fName.toLowerCase()] = [itemRelativePath]

      else if fStat.isDirectory()
        if fs.existsSync(folderPath) then this.buildFilesByDirectory opts, files, itemPhyPath, itemRelativePath, fName

  buildProperties: (opts, filesDic)->
    result = {}
    for filename of filesDic
      files = filesDic[filename]

      if path.extname(filename).toLowerCase() is ".json"
        result[filename] = this.JSONFilesParse files, opts.phyPath
      else
        result[filename] = this.propertyFilesParse files, opts.phyPath

    return result

  JSONFilesParse: (files, phyPath)->
    result = null
    for f in files
      data = fs.readFileSync path.join(phyPath, f), {encoding: "utf8"}
      obj = JSON.parse data
      result = if result is null then obj else Utils.FillObject(result, obj, "full")

    return result

  propertyFilesParse: (files, phyPath)->
    result = null
    for f in files
      data = fs.readFileSync path.join(phyPath, f), {encoding: "utf8"}
      fileObj = this.propertyFileToJSON(data)
      result = if result is null then fileObj else Utils.FillObject result, fileObj, "full"

    return result

  propertyFileToJSON: (fileData)->
    result = {}
    lineArr = fileData.toString().split('\n')
    for line in lineArr
      line = line.trim().replace(/\\r/g, '')
      if line[0] is "#" then continue
      if line.indexOf('=') is -1 then continue

      symbolIndex = line.indexOf('=')
      key = line.substr(0, symbolIndex).trim()
      value = line.slice(symbolIndex+1).trim()

      if key.indexOf('.') is -1
        result[key] = value
      else
        keyArr = key.split('.')
        c = result;
        for subKey,i in keyArr
          if subKey.trim() is "" then continue
          if typeof(c[subKey]) is "undefined" then c[subKey] = {}
          if i+1 is keyArr.length then c[subKey] = value else c = c[subKey]

    return result

exports.ResourceType = ResourceType
exports.ResourceOptions = ResourceOptions
exports.ResourceManager = ResourceManager