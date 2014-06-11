###
@author      Created by Haiwei Li <haiwei8086@gmail.com> on 2014-6-8.
@link        https://github.com/haiwei8086/i18n-resource-manager
@license     http://opensource.org/licenses/MIT
@version     0.0.1
###

Utils =
  # Deep Clone
  Clone: (sObj)->
    if sObj is null then return null
    if typeof(sObj) isnt "object" then return sObj
    s = if sObj.constructor is Array then [] else {}

    for p of sObj
      s[p] = Utils.Clone sObj[p]

    return s
  # END

  # Fill original object use target object
  # @type: Full(if property not exists, add a new property), Child(child properties is full fill), OneWay(fill original from target just have properties)
  # @return: original object(reference).
  FillObject: (original, target, type) ->
    if original is undefined or original is null
      original = Utils.Clone target
      return original

    # fill exists properties
    for p of original
      pType = typeof original[p]
      if pType is "object"
        if typeof(target[p]) isnt "undefined"
          if type.toLowerCase() == "child"
            original[p] = Utils.Clone target[p]
          else
            original[p] = Utils.FillObject original[p], target[p], type
      else
        # base type, Array or function
        if typeof(target[p]) isnt "undefined"
          original[p] = Utils.Clone target[p]

    # add new properties
    if type.toLowerCase() is "full"
      for p of target
        pType = typeof target[p]
        if typeof(original[p]) isnt "undefined" then continue
        original[p] = Utils.Clone target[p]

    return original

module.exports = Utils