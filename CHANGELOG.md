**0.5.6** (To be released)
- Pre-process env file if it has .erb extension
- Change default data paths to use home directory

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