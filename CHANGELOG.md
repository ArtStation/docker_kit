**1.0.1**
- Change minimal ruby version to 2.6

**1.0.0**
- Bump stable release

**0.9.9**
- Fix updating artifact if it was force-pushed
- Improve resource selector, allow connecting to job via kit console

**0.9.0-0.9.8**
- Allow skipping confirmation during deployment
- Added `kit sh` command to create a new shell
- Use tmp dir as image builds parent dir for remote compilation

**0.8.4-0.8.8**
- Added initial services support, to deploy before all other servies
- Allow namespace as symbol in kubectl commands
- Allow setting kubectl entrypoint for configuration

**0.8.3**
- Always load artifacts, if kubeconfig is an artifact

**0.8.2**
- Update Kit Env command to support kubeconfig path as artifact

**0.8.1**
- Allow deploying services without dependecies
- Default services should be first in the list
- KubeConfig should be able to take file from artifact

**0.7.1**
- Added Ruby 3.0 support

**0.6.4**
- Improve context vars, allow checking if variable is defined

**0.6.3**
- Fix updating artifacts when there is only local artifacts

**0.6.2**
- Added an ability to return build vars as a hash value.
- Skip local artifacts while updating configuration, it sometimes produce an error

**0.6.1**
- Improve performance of artifacts update by updating in threads.
- Added an ability to define default services

**0.6.0**
- Cleanup old image build dirs
- Add rotation to deployment log file

**0.5.10**
- Fix a regression when deployment result would not be properly returned as json.

**0.5.9**
- Added an ability to set custom user
- Allow setting environment variable in docker strategy
- Properly stop deployment if image compilation is failed

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