-- vim: ft=haskell: ts=4: et:
--
-- XMonad Configuration
-- Written by Cassandra J Carter
--

import XMonad

import XMonad.Actions.FloatSnap

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName

import XMonad.Layout.NoBorders

import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (hPutStrLn, spawnPipe)
import XMonad.Util.SpawnOnce

import qualified XMonad.StackSet as W

import qualified Data.Map as M
import Data.Function (on)
import Data.List (sortBy)
import Data.Monoid
import Data.Ratio

import System.Exit

import Control.Monad

import Graphics.X11.ExtraTypes.XF86

myTerminal      = "alacritty"
myFileManager   = "pcmanfm"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth   = 1

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#404040"
myFocusedBorderColor = "#707070"

------------------------------------------------------------------------
-- Named Scratchpads
--
myScratchpads :: [NamedScratchpad]
myScratchpads = [ NS "files" spawnFiles findFiles manageFiles]
    where
        spawnFiles  = myFileManager
        findFiles   = resource =? myFileManager
        manageFiles = customFloating $ W.RationalRect 0.2 0.2 0.6 0.6

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
    , ((modm,               xK_p     ), spawn "dmenu_run")
    , ((modm .|. shiftMask, xK_c     ), kill)
    , ((modm,               xK_space ), sendMessage NextLayout)
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
    , ((modm,               xK_n     ), refresh)
    , ((modm,               xK_Tab   ), windows W.focusDown)
    , ((modm,               xK_j     ), windows W.focusDown)
    , ((modm,               xK_k     ), windows W.focusUp  )
    , ((modm,               xK_m     ), windows W.focusMaster  )
    , ((modm,               xK_Return), windows W.swapMaster)
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )
    , ((modm,               xK_h     ), sendMessage Shrink)
    , ((modm,               xK_l     ), sendMessage Expand)
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))
    , ((modm              , xK_s     ), withFocused (centerAndMove))

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    -- Scratchpads
    , ((modm .|. controlMask, xK_f), namedScratchpadAction myScratchpads "files")

    -- Audio keys
    , ((0,                    xF86XK_AudioMute), spawn "/home/alex/Scripts/notify-volume mute")
    , ((0,                    xF86XK_AudioLowerVolume), spawn "/home/alex/Scripts/notify-volume dec")
    , ((0,                    xF86XK_AudioRaiseVolume), spawn "/home/alex/Scripts/notify-volume inc")
    , ((0,                    xF86XK_AudioMicMute), spawn "/home/alex/Scripts/notify-mic mute")
    , ((0,                    xF86XK_MonBrightnessDown), spawn "/home/alex/Scripts/notify-backlight dec")
    , ((0,                    xF86XK_MonBrightnessUp), spawn "/home/alex/Scripts/notify-backlight inc")
    -- Application Shortcuts
    , ((modm.|.shiftMask, xK_p     ), spawn "passmenu")
    , ((modm.|.shiftMask, xK_b     ), spawn "brave")
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging, snapping to window edges
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w >> afterDrag (snapMagicMove (Just 50) (Just 50) w)))

    -- mod-button1 + shift, Set the window to floating mode and move by dragging, no snapping
    , ((modm .|. shiftMask, button1), (\w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging, snapping to window edges
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w >> afterDrag (snapMagicResize [R,D] (Just 50) (Just 50) w)))

    -- mod-button3 + shift, Set the window to floating mode and resize by dragging, no snapping
    , ((modm .|. shiftMask, button3), (\w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster))
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--

myLayout = avoidStruts $ smartBorders $ tiled ||| noBorders Full
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio
     -- The default number of windows in the master pane
     nmaster = 1
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

centerFloat w = windows (\s -> W.float w (W.RationalRect 0.2 0.2 0.6 0.6) s)

centerAndMove :: Window -> X ()
centerAndMove window = do
    focus window
    centerFloat window

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--

myManageHook = composeAll . concat $
    [ [ manageDocks ]
    , [namedScratchpadManageHook myScratchpads]
    , [isDialog --> doCenterFloat]
    , [className =? c --> doCenterFloat | c <- myClassFloats]
    , [title =? t --> doCenterFloat | t <- myTitleFloats]
    , [resource =? i --> doIgnore | i <- myIgnores]
    ]
    where
        myClassFloats = [ "mpv" ]
        myTitleFloats = [ "Save As..." ]
        myIgnores = ["desktop_window"]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = docksEventHook <+> ewmhDesktopsEventHook <+> fullscreenEventHook

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook = dynamicLogXinerama <+> ewmhDesktopsLogHook

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do
    spawnOnce "xsetroot -cursor_name left_ptr"
    spawnOnce "/home/alex/.config/autostart.sh"
    setWMName "LG3D"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do

    xmproc0 <- spawnPipe "xmobar $HOME/.config/xmobar/xmobarrc.hs"

    xmonad $ docks $ ewmh def
        {
          -- simple stuff
            terminal           = myTerminal,
            focusFollowsMouse  = myFocusFollowsMouse,
            clickJustFocuses   = myClickJustFocuses,
            borderWidth        = myBorderWidth,
            modMask            = myModMask,
            workspaces         = myWorkspaces,
            normalBorderColor  = myNormalBorderColor,
            focusedBorderColor = myFocusedBorderColor,

          -- key bindings
            keys               = myKeys,
            mouseBindings      = myMouseBindings,

          -- hooks, layouts
            layoutHook         = myLayout,
            manageHook         = myManageHook,
            handleEventHook    = myEventHook,
            logHook            = myLogHook <+> dynamicLogWithPP xmobarPP
                                                { ppOutput = \x -> hPutStrLn xmproc0 x
                                                , ppCurrent = xmobarColor "#ffffff" "" . wrap "[" "]"               -- Current workspace in xmobar
                                                , ppVisible = xmobarColor "#ffffff" "" . wrap " " " "               -- Visible but not current workspace
                                                , ppHidden = xmobarColor "#666666" "" . wrap "-" "-"                -- Hidden workspaces in xmobar
                                                , ppHiddenNoWindows = xmobarColor "#666666" "" . wrap " " " "       -- Hidden workspaces (no windows)
                                                , ppTitle = xmobarColor "#bbbbbb" "" . shorten 60                   -- Title of active window in xmobar
                                                },
            startupHook        = myStartupHook
        }
