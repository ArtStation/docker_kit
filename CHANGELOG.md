**0.5.9**(to be released)
- Added an ability to set custom user
- Allow setting environment variable in docker strategy

**0.5.8**
- Update gemspec to support ruby 2.5

**0.5.7**
- Look for kuber_kit root path in parent folders, so kit command will work in sub-folders

**0.5.6**
- Pre-process env file if it has .erb extension
- Allow attaching env file from configuration to docker container
- Change default data paths to use home directory
- Add env groups support to combine multiple env files

**0.5.5**
- Added ability to skip services during deployment using -S option

**0.5.4**
- Added disabled services support

**0.5.3**
- Change the symbol to exclude service from "-" to "!", you can pass "-s !auth_app" to exclude "auth_app"
- Added kit get command to find pods
 
**0.5.2**
- Added dependencies support to services
- Added an option to deploy all services in `kit deloy`
- Wait for rollout to finish during service deploy
- Deploy services in batches, not all of the simultaneously