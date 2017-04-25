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
import System.Taffybar.Hooks.PagerHints (pagerHints)

startup :: X ()
startup = do
  spawn "systemctl --user restart xmonad.target"

myLayout = avoidStruts $ ifWider 1900 (toggle tall ||| full) (Mirror $ toggle tall ||| full)
  where
    basic = smartBorders $ fullscreenFocus $ Tall 1 (3 /100) (3/4)
    tall = named "Tall" $ basic
    wide = named "Wide" $ Mirror $ basic
    full = named "Full" $ noBorders Full
    toggle = toggleLayouts full

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList [
       ((modm, xK_s), sendMessage ToggleStruts)
     ]

newKeys x = myKeys x `M.union` keys def x


main = xmonad $
       ewmh $
       pagerHints $
       docks $
       def { modMask = mod4Mask  -- super instead of alt (usually Windows key)
           , terminal = "urxvt"
           , startupHook = startup
           , layoutHook = myLayout
           , logHook = dynamicLogString defaultPP >>= xmonadPropLog
           -- , manageHook = manageDocks
           , keys = newKeys
           }
