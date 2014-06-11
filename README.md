i18n-resource-manager
=====================

Localization strategy solution on node. Support all languages.

Scenario
---------------------
1. different platforms
2. different countries
3. different configurations

Directory Structure
---------------------
Directory:

    root
    | views (Override)
        | _default/country/_default
            | index.html
            | public.html
            | specific.html
        | _default/country/US
            | specific.html
        | platform/country/_default
            | index.html
        | platform/country/US
            | specific.html   
            
    | css (Append)
        | _default/lang/_default
            | style.css        
        | platform/lang/en
            | style.css
            | US/style.css
            
    | properties (Override specific config item)
        | country/default
            | config.json
            | language.properties        
        | country/CN
            | config.json
            | language.properties
    
Results:

    views ---------------------
       { 'index.html': 'platform\\country\\_default\\index.html',
         'public.html': '_default\\country\\_default\\public.html',
         'specific.html': 'platform\\country\\US\\specific.html'}
    
    css ------------------------
         { 'style.css': [ 
             '_default\\lang\\_default\\style.css',
             'platform\\lang\\en\\style.css',
             'platform\\lang\\en\\US\\style.css']}
             
    properties ------------------
         { 'config.json': { item: 'CN config', version: '0.0.1', extend: 'CN specific config' },
           'language.properties': { button: { save: '保存' } } }

Usage
------------------

    options = new ResourceOptions();
    options.phyPath = path.join process.cwd(), 'views'
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
    console.log 'index.html:', htmlResource.get('index.html')
    console.log 'specific.html:', htmlResource.get('specific.html')
    console.log 'END HTML ------------------------'
    
    OUTPUT:
    index.html: platform\country\_default\index.html
    specific.html: platform\country\US\specific.html
    

Code using coffescript, you can look the js file.

### ResourceOptions
  * I have the sames default field, but you should be set your field according to your rules, and add the somes field, javascript allows that.
  * such as:
  
        options.key.lang = "en"
   
    the lang is a new field, no in the ResourceOptions object
  * more skills, please see /test/index.coffe or index.js