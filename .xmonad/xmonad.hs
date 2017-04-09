import XMonad
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


startupHook = startup

startup :: X ()
startup = do
  spawn "systemctl --user start xmonad"

myLayout = ifWider 1200 (toggle tall ||| full) (Mirror $ toggle tall ||| full)
  where
    basic = smartBorders $ fullscreenFocus $ Tall 1 (3 /100) (3/4)
    tall = named "Tall" $ avoidStruts $ basic
    wide = named "Wide" $ avoidStruts $ Mirror $ basic
    full = named "Full" $ avoidStruts $ noBorders Full
    toggle = toggleLayouts full

main = xmonad $
       ewmh $
       pagerHints $
       def { modMask = mod4Mask  -- super instead of alt (usually Windows key)
           , terminal = "urxvt"
           , layoutHook = myLayout
           , manageHook = manageDocks
           }
