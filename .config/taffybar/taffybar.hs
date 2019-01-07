import System.Taffybar
import System.Taffybar.Hooks
import System.Taffybar.Information.CPU
import System.Taffybar.Information.Memory
import System.Taffybar.SimpleConfig
import System.Taffybar.Widget
import System.Taffybar.Widget.Generic.PollingGraph
import System.Taffybar.Widget.Generic.PollingLabel
import System.Taffybar.Widget.Util
import System.Taffybar.Widget.Workspaces

import Data.Text(pack)
import Data.Time.LocalTime(utc)

memCallback = do
  mi <- parseMeminfo
  return [memoryUsedRatio mi]

cpuCallback = do
  (_, systemLoad, totalLoad) <- cpuLoad
  return [ totalLoad, systemLoad ]

main = do
  let
    graphCfg = defaultGraphConfig {
      graphLabel = Just (pack "mem")
        , graphDirection = RIGHT_TO_LEFT
        , graphWidth = 40
    }
    memCfg = graphCfg {
      graphLabel = Just (pack "mem")
        , graphDataColors = [(1, 0, 0, 1)]
    }
    cpuCfg = graphCfg {
      graphLabel = Just (pack "cpu")
        , graphDataColors = [ (0, 1, 0, 1), (1, 0, 1, 0.5)]
    }

    myWorkspacesConfig = defaultWorkspacesConfig {
      minIcons = 1
        , widgetGap=0
        , showWorkspaceFn = hideEmpty
    }
    workspaces = workspacesNew myWorkspacesConfig
    clock = textClockNew Nothing "<span fgcolor='orange'>%a %b %_d P %H:%M</span>" 1
    zebra = textClockNewWith (ClockConfig (Just utc) Nothing) "<span fgcolor='silver'>%a %b %_d Z %H:%M</span>" 1
    -- The right way seems to set up an sni listener in systemd?
    tray = sniTrayThatStartsWatcherEvenThoughThisIsABadWayToDoIt
    -- tray = sniTrayNew
    cpu = pollingGraphNew cpuCfg 0.5 cpuCallback
    mem = pollingGraphNew memCfg 1 memCallback
    -- batt = batteryBarNew defaultBatteryConfig 30
    batt = textBatteryNew "$percentage$% ($time$)"
    layout = layoutNew defaultLayoutConfig
    {-
     - the menu widget doesn't seem to accept a height?
     - or better still, respect the height of the bar it's put in.
    windows = windowsNew defaultWindowsConfig
    -}

    simpleConfig = defaultSimpleTaffyConfig {
      startWidgets = [ workspaces, layout ] --, layout, windows ]
        , endWidgets = [ tray, zebra, clock, mem, cpu, batt ]
        , barHeight = 20
        , barPosition = Bottom
    }
  dyreTaffybar $ toTaffyConfig simpleConfig
