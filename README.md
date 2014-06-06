i18n-resource-manager
=====================

nodejs localization strategy solution

### Data in RAM ####
Data:

    global.LocalResource = {
      "apple-IPhone-en_US": {
         "Single": {
            "index.html": "./apple/IPhone/country/US/index.html",
            "about.html": "./apple/IPhone/country/_default/about.html"
         },
         "Multi": {
            "style.css": [
                "./_default/locale/_default/style.css",
                "./_default/locale/en/style.css",
                "./apple/locale/en/style.css",
                "./apple/IPhone/locale/en/style.css",
             ]
         },
         "Properties-country": {
            "config.properties": {
                "key1": "value1 from ./_default/country/_default/config.properties",
                "key2": "value2 from ./apple/IPhone/country/US/config.properties"
            }
         },
         "Properties-env": {
            "env.properties": {
                "key1": "value1 from ./_default/env/dev/env.properties",
                "key2": "value2 from ./apple/IPhone/env/dev/env.properties"
            }
         }
      }
    }

Options:

    {
        key: { platform: "apple", subPlatform: "IPhone", locale: "en_US"},
        phyPath: process.cwd(),
        rules: [
           '_default/country/_default',
           '_default/country/{country}',
           '_default/{subTarget}/country/_default',
           '_default/{subTarget}/country/{country}',
           '{target}/country/_default',
           '{target}/country/{country}',
           '{target}/{subTarget}/country/_default',
           '{target}/{subTarget}/country/{country}'
        ],
        isOnlyLeafFiles: false or true,  // file in en not only US folder
        isMultifile: false or true,  // html or css
        isProperties: false or true
    }

html
{platform}/{subPlatform}/country/US/file
css
{platform}/{subPlatform}/country/en/file
{platform}/{subPlatform}/country/en/US/file

properties group 1
{platform}/{subPlatform}/country/_default/properties
{platform}/{subPlatform}/country/en/properties
{platform}/{subPlatform}/country/en/US/properties

[folder]:folder-properties-key
{platform}/{subPlatform}/country/en/US/folder/properties

properties group 2
{platform}/{subPlatform}/countryLang/_default/properties
{platform}/{subPlatform}/countryLang/US/properties

properties group 3
{platform}/{subPlatform}/env/_default/properties
{platform}/{subPlatform}/env/{dev or prod}/properties

properties group 4
{platform}/{subPlatform}/noloc/properties