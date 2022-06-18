
# +--------------------
# |
# | dTreeChopper
# |
# | Allows players to chop down an entire tree by breaking only one
# | log on the tree. Includes a fast leaf decay mechanic.
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

    # disabledWorlds        <yaml[dtc_config].read[disabled-worlds]>
    # usableTools           <yaml[dtc_config].read[usable-tools]>
    # maxLogsPerChop        <yaml[dtc_config].read[max-logs-per-chop]>
    # leavesRequiredForTree <yaml[dtc_config].read[leaves-required-for-tree]>
    # treeAnimation         <yaml[dtc_config].read[tree-animation]>
    # requireSneaking       <yaml[dtc_config].read[require-sneaking]>
    # takeDurability        <yaml[dtc_config].read[take-durability]>
    # allowCreativeMode     <yaml[dtc_config].read[allow-creative-mode]>

DTCCommand:
  type: command
  debug: false
  name: dtreechopper
  description: Show what version of dTreeChopper is installed
  usage: /dtreechopper <&lt>version|reload<&gt>
  permission: dtreechopper.admin
  permission message: <red>Sorry, <player.name>, you do not have permission to run that command.
  tab complete:
  - if <context.args.size> < 1:
    - determine <list[reload|version]>
  - if <context.args.size> == 1 && "!<context.raw_args.ends_with[ ]>":
    - determine <list[reload|version].filter[starts_with[<context.args.get[1]>]]>
  script:
  - choose <context.args.get[1]||version>:
    - case version:
      - narrate "<red>RandomDeathMessages <green>v<script[rdm_version].data_key[version]>"
    - case reload:
      - inject rdm_init
      - narrate "<green>RandomDeathMessages has been reloaded."
    - default:
      - narrate "<red>Unknown argument: <gold><context.args.get[1]>"

dTreeChopperHandler:
  type: world
  events:
    on player breaks *_log:
      - define material <context.material.name>
      # Player is not in a disabled world
      - if !<yaml[dtc_config].read[disabled-worlds].contains[player.world.name]>:
        # Player is either in survival mode or allow-creative-mode is true
        - if <player.gamemode> == survival || <player.gamemode> == creative && <yaml[dtc_config].read[allow-creative-mode]>:
          # player is sneaking or require-sneaking is false
          - if <player.is_sneaking> && <yaml[dtc_config].read[require-sneaking]> || <yaml[dtc_config].read[require-sneaking]> == false:
            # Now we chop trees!