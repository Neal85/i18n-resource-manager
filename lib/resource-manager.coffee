
path = require 'path'
fs = require 'fs'
Utils = require './utils'
DefaultOptions = require './default-options'

class ResourceManager
  constructor: (@options)->
    @resourceUtils = new ResourceUtils(@options)

class ResourceUtils
  constructor: (@options)->
    @lang = ""
    @country = ""
    @options = Utils.FillObject DefaultOptions, @options, "full"
    @rules = this.resolveRules @options
    this.buildRules()


  # Resolver Rules
  resolveRules: (options)->
    results = new Array()
    key = options.key
    rules = options.rules;
    for item in rules
      rule = item
      for p of key
        reg = new RegExp '({'+p+'})', 'g'
        rule = rule.replace reg, key[p]
      if rule.indexOf('{') isnt -1 or rule.indexOf('}') isnt -1 then throw new Error 'Resolve rules error! rule: '+ item
      results.push(rule)

    return results

  # Build Rules
  buildRules:()->
    console.log this.buildRulesForFiles()


  # Build Rules for files
  buildRulesForFiles:()->
    results = {}
    for relativePath, i in @rules
      folderPhyPath = path.join @options.phyPath, relativePath
      if fs.existsSync(folderPhyPath) then this.buildFiles results, folderPhyPath, relativePath, null
    return results

  buildFiles: (files, folderPath, relativePath, prefix)->
    childes = fs.readdirSync folderPath
    for fName,i in childes
      itemPhyPath = path.join folderPath, fName
      itemRelativePath = path.join relativePath, fName
      fName = if prefix then prefix + '-' + fName else fName
      fStat = fs.statSync itemPhyPath
      if fStat.isFile()
        if typeof(files[fName.toLowerCase()]) isnt "undefined"
          if @options.isMultifile
            files[fName.toLowerCase()].push(itemRelativePath)
          else
            files[fName.toLowerCase()] = itemRelativePath
        else
          if @options.isMultifile
            files[fName.toLowerCase()] = [itemRelativePath]
          else
            files[fName.toLowerCase()] = itemRelativePath
      else if fStat.isDirectory()
        if fs.existsSync(folderPath) then this.buildFiles files, itemPhyPath, itemRelativePath,fName



module.exports = ResourceManager


