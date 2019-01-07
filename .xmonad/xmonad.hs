import XMonad
import qualified Data.Map as M
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops        (ewmh)
import XMonad.Hooks.ManageDocks
import XMonad.Layout
import XMonad.Layout.Fullscreen
import XMonad.Layout.PerScreen
import XMonad.Layout.Named
import XMonad.Layout.NoBorders
import XMonad.Layout.ToggleLayouts
import XMonad.Actions.WindowBringer
import qualified XMonad.Actions.CycleWS as C
import qualified XMonad.StackSet as W

-- c.f. http://hackage.haskell.org/package/xmonad-contrib-0.13/docs/XMonad-Actions-CycleWS.html

import System.Taffybar.Support.PagerHints (pagerHints)

startup :: X ()
startup = do
  spawn "systemctl --user restart xmonad.target"
  spawn "xss-lock -- i3lock -i ~/Data/Wallpaper/rotsnakes-tile.png -t"
  spawn "tmux start-server"

myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
workspacesWithKeys = zip myWorkspaces [xK_1,xK_2,xK_3,xK_4,xK_5,xK_6,xK_7,xK_8,xK_9,xK_0]

myLayout = avoidStruts $ ifWider 1900 (toggle tall ||| full) (Mirror $ toggle tall ||| full)
  where
    basic = smartBorders $ fullscreenFocus $ Tall 1 (3 /100) (3/4)
    tall = named "Tall" $ basic
    wide = named "Wide" $ Mirror $ basic
    full = named "Full" $ noBorders Full
    toggle = toggleLayouts full

myBringMenu = bringMenuArgs ["-i", "-l", "45"]
myActivateMenu = actionMenu def { menuArgs = ["-i", "-l", "45"] } activateWindow

-- decorateName ws w = do
--   name <- show <$> getName w
--   return $ name ++ " [" ++ W.tag ws ++ "]"

activateWindow w ws = W.shiftMaster (W.focusWindow w ws)

mainUp =   windows (W.focusDown   . W.swapUp)
mainDown = windows (W.focusUp     . W.swapDown)

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList ([
       ((modm, xK_z), spawn "i3lock -i ~/Data/Wallpaper/rotsnakes-tile.png -t &"),
       ((modm, xK_a), spawn "dmenu-screenlayout &"),
       ((modm, xK_grave), spawn "dmenu-scripts &"),
       ((modm, xK_g), myActivateMenu),
       ((modm, xK_b), myBringMenu),
       ((modm .|. shiftMask, xK_j ), mainDown ),
       ((modm .|. shiftMask, xK_k ), mainUp )
     ]
     ++ [ ((modm, key),                    C.toggleOrView tag) | (tag, key)  <- workspacesWithKeys ]
     ++ [ ((modm .|. shiftMask, key), (windows . W.shift) tag) | (tag, key)  <- workspacesWithKeys ]
     )
newKeys x = myKeys x `M.union` keys def x

myManageHook = composeAll [
    className =? "pinentry" --> doFloat
  , className =? "Pinentry" --> doFloat
  ]

main = xmonad $
       ewmh $
       pagerHints $
       docks $
       def { modMask = mod4Mask  -- super instead of alt (usually Windows key)
           , terminal = "alacritty"
           , startupHook = startup
           , layoutHook = myLayout
           , logHook = dynamicLogString defaultPP >>= xmonadPropLog
           , manageHook = myManageHook <+> manageHook def
           , workspaces = myWorkspaces
           , keys = newKeys
           , normalBorderColor  = "#aaaaaa"
           , focusedBorderColor = "#666699"
           }
