
# +--------------------
# |
# | dTreeChopper
# |
# | Allows players to chop down an entire tree by breaking only one
# | log on the tree.
# |
# | Huge props to Daxz on the Denizen Discord for his old ChopChop script!
# +----------------------
#
# @author GoMinecraft ( Discord: BrainFailures#1421 )
# @date 2022-06-17
# @denizen-build ALWAYS USE THE LATEST @ https://ci.citizensnpcs.co/job/Denizen/
# @script-version 0.0
#
# Usage:
# /dtreechopper version - Shows the version
# /dtreechopper reload - Reloads the config.yml and any related language files.
#

# ---- Don't edit below here unless you know what you're doing.
# ---- I definitely don't know what I'm doing.

DTCVersion:
  type: data
  version: 0.0

DTCInit:
  type: task
  debug: false
  script:
  - if <server.has_file[../dTreeChopper/config.yml]>:
    - ~yaml load:../dTreeChopper/config.yml id:dtc_config
    - announce to_console "[dTreeChopper] Loaded config.yml"
  - else:
    - announce to_console "Unables to load plugins/dTreeChopper/config.yml"
  - define disbaledWorlds        <yaml[dtc_config].read[disabled-worlds]>
  - define usableTools           <yaml[dtc_config].read[usable-tools]>
  - define maxLogsPerChop        <yaml[dtc_config].read[max-logs-per-chop]>
  - define leavesRequiredForTree <yaml[dtc_config].read[leaves-required-for-tree]>
  - define treeAnimation         <yaml[dtc_config].read[tree-animation]>
  - define takeDurability        <yaml[dtc_config].read[take-durability]>

dTreeChopperHandler:
  type: world
  events:
    on player breaks *_log:
      - define material <context.material.name>