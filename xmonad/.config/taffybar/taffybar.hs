import System.Taffybar

import System.Taffybar.Widget.SNITray
import System.Taffybar.Widget.Workspaces
import System.Taffybar.Widget.Layout
import System.Taffybar.Widget.Windows
import System.Taffybar.Widget.SimpleClock
import System.Taffybar.Widget.FreedesktopNotifications
import System.Taffybar.Widget.Weather
import System.Taffybar.Widget.MPRIS2
import System.Taffybar.Widget.Battery

-- import System.Taffybar.Widgets.PollingBar
-- import System.Taffybar.Widgets.PollingGraph

import System.Taffybar.Information.Memory
import System.Taffybar.Information.CPU
import System.Taffybar.Information.Battery

import Data.Time.LocalTime(utc)
-- import Data.Text

memCallback = do
  mi <- parseMeminfo
  return [memoryUsedRatio mi]

cpuCallback = do
  (userLoad, systemLoad, totalLoad) <- cpuLoad
  return [totalLoad, systemLoad]

main = do
  let memCfg = defaultGraphConfig {
          graphLabel = Nothing -- Just "mem"
        , graphDirection = RIGHT_TO_LEFT
        , graphWidth = 40
        , graphDataColors = [(1, 0, 0, 1)]
      }
      cpuCfg = defaultGraphConfig {
          graphLabel = Nothing -- Just "cpu"
        , graphDirection = RIGHT_TO_LEFT
        , graphWidth = 40
        , graphDataColors = [
            (0, 1, 0, 1)
          , (1, 0, 1, 0.5)
          ]
      }
  let clock = textClockNew Nothing "<span fgcolor='orange'>%a %b %_d %H:%M</span>" 1
      zebra = textClockNewWith (ClockConfig (Just utc) Nothing) "<span fgcolor='silver'>%a %b %_d %H:%M</span>" 1
      pager = taffyPagerHUDNew defaultPagerConfig {
        activeLayout = escape . take 1
      , activeWindow = escape . shorten 20
      } defaultWorkspaceHUDConfig { windowIconSize = 12
      , minWSWidgetSize = Just 25
      , maxIcons = Just 1
      , showWorkspaceFn = hideEmpty
      , urgentWorkspaceState = True
      }
      -- note = notifyAreaNew defaultNotificationConfig
      -- wea = weatherNew (defaultWeatherConfig "KMSN") 10
      mpris = mprisNew defaultMPRISConfig
      mem = pollingGraphNew memCfg 1 memCallback
      cpu = pollingGraphNew cpuCfg 0.5 cpuCallback
      tray = systrayNew
      -- bat = textBatteryNew "%d%%" 1
      batt = batteryBarNew defaultBatteryConfig 30
  defaultTaffybar defaultTaffybarConfig { barPosition = Bottom
                                        , getMonitorConfig = allMonitors
                                        , startWidgets = [ pager ]
                                        , barHeight = 28
                                        , endWidgets = [ tray, zebra, clock,  batt, mem, cpu, mpris ]
                                        }
