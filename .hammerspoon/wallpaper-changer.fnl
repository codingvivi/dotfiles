(print "~~~~~~~~~~~~~~~ wallpaper rotator ~~~~~~~~~~~~~~~")
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ;
;                                  requires                                    ;
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ;
(local natcmp (require :string.natcmp))

;; utf8 sorter

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ;
;                                    locals                                    ;
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ;
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ user settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ;
(local WALLPAPER-FOLDER
       (.. (os.getenv :HOME) "/Pictures/Wallpaper Rotation/master"))

(local WALLPAPER-DUR-MINS 30)

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ script settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ;
(local SUPPORTED-FILETYPE-UTIS ["com.apple.pict"
                                "com.compuserve.gif"
                                "com.microsoft.bmp"
                                "public.heic"
                                "public.heif"
                                "public.jpeg"
                                "public.png"
                                "public.tiff"])

(local PAUSE_EVENTS
       {hs.caffeinate.watcher.screensDidSleep true
        hs.caffeinate.watcher.screensaverDidStart true})

(local RESUME_EVENTS
       {hs.caffeinate.watcher.screensDidWake true
        hs.caffeinate.watcher.screensaverDidStop true})

;(hs.settings.set "wallpaper-index" 507) ; for debugging

; ~~~~~~~~~~~~~~~~~~~ garbage collection timer protection ~~~~~~~~~~~~~~~~~~~~ ;
; Global = not garbage collected, empty table = assignable
(set _G.M {})
; local alias
(local M _G.M)

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ;
;                                   helpers                                    ;
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ;
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ files ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ;
(λ get-files [folder-path]
  "Returns number list with files, number of files and subdirs"
  (let [(files filenum dirnum) (hs.fs.fileListForPath folder-path
                                                      {:subdirs true})]
    (print (.. "Folder: " folder-path))
    (print (length files))
    (print (.. "Number of files: " filenum))
    (print (.. "Number of directories: " dirnum))
    (values files filenum dirnum)))

(λ hassupportedUTI? [UTI-list path]
  "Checks if file path matches one of the UTIs"
  (each [_ UTI (ipairs UTI-list)]
    (when (= UTI (hs.fs.fileUTI path))
      (lua "return true"))) ; Use the Lua return to exit immediately
  false)

;; debugging

(λ get-supported-file-paths [UTIs file-paths]
  "Takes a list of files, returns a list of files that match a list of UTIs"
  (let [file-list []]
    (each [_ path (ipairs file-paths)]
      (when (hassupportedUTI? UTIs path)
        (table.insert file-list path)))
    file-list))

(λ calculate-next-index [file-list current-idx]
  "Calculates the next valid index for the file-list using 'case true'.
   Handles wrap-around and initialization from 0 or invalid index.
   Returns nil if file-list is empty or nil."
  (let [image-list-length (length file-list)]
    ;; (length nil) or (length {}) will be 0
    (case true
      ;; Condition 1: No files available
      (where _ (= 0 image-list-length))
      (do
        (print "Error: No images found in file-list.")
        nil) ; No files, no valid index
      ;; Condition 2: Invalid or uninitialized current index
      (where _ (or (not current-idx) (<= current-idx 0)
                   (> current-idx image-list-length)))
      (do
        (print (.. "Info: Invalid or uninitialized index ("
                   (tostring current-idx) "). Setting to 1."))
        1) ; Set to first image
      ;; Condition 3: Reached the end of the list
      (where _ (= current-idx image-list-length))
      (do
        (print "Info: End of file list. Starting over.")
        1) ; Wrap to first image
      ;; Default Case: Valid index, not at end of list
      _
      (do
        (print (.. "Info: Advancing index from " current-idx " to "
                   (+ current-idx 1)))
        (+ current-idx 1)))))

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ screen stuff ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ;
(fn get-available-screens []
  "Returns all available screens connected as a list
	or nil if there are none"
  (print "Refreshing screens available...")
  (let [screen-list (hs.screen.allScreens)
        screen-amount (length screen-list)]
    (if (= 0 screen-amount)
        (do
          (print "Error: No screens detected...")
          nil)
        (do
          (print (.. "Number of screens detected: " screen-amount))
          screen-list))))

(λ print-screen-details [screen]
  "Returns text with screen name and dimensions for printing"
  (print (.. "Screen " (screen:name) " - "
             (let [frame (screen:frame)]
               (.. frame.w " x " frame.h "px")))))

(λ iterate-screens [screen-list func ?args]
  "Iterates to a list of screens running a function on each"
  (each [i screen (ipairs screen-list)]
    (func screen ?args)))

; ~~~~~~~~~~~~~~~~~~~~~~~ screen + file helper combos ~~~~~~~~~~~~~~~~~~~~~~~~ ;
(λ change-wallpaper-on-screen [screen file-path]
  "Sets the desktop image for the given screen."
  (let [url (.. "file://" file-path)]
    (print (.. "Setting wallpaper to: " url))
    (screen:desktopImageURL url))
  (print (.. "Wallpaper: " (hs.fs.displayName file-path)))
  0.5)

(λ run-rotator [folder]
  (print "Starting wallpaper change routine...")
  (let [(cadidate-paths cadidate-num cadidate-dir-num) (get-files folder)
        image-paths (get-supported-file-paths SUPPORTED-FILETYPE-UTIS
                                              cadidate-paths)
        screens (get-available-screens)
        main-screen (hs.screen.mainScreen)]
    (table.sort image-paths natcmp.utf8.lt)
    (if (not (and image-paths (> (length image-paths) 0) screens main-screen))
        (print "Error: something is nil that shouldnt be...")
        (do
          ; print details
          (print "Screens available:")
          (iterate-screens screens print-screen-details)
          (print "Main screen:")
          (print-screen-details main-screen) ; Run changer: get file index...
          (let [next-index (calculate-next-index image-paths
                                                 (hs.settings.get "wallpaper-index"))]
            ;... and change wallpapers
            (if (not next-index)
                (print "Error: Next index position is nil....")
                (let [next-image (. image-paths next-index)]
                  (if (not next-image)
                      (print "Error: next image is nil...")
                      (do
                        (hs.settings.set "wallpaper-index" next-index)
                        (print (.. "Setting next image to " next-image))
                        (iterate-screens screens change-wallpaper-on-screen
                                         (. image-paths next-index))
                        (print "Changed wallpaper successfully!"))))))))))

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ timer helpers ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ;
(fn check-value-change [value-new value-old]
  (let [change (- value-new value-old)]
    (if (= 0 change)
        (print "Value remains the same")
        (print (.. "Value has changed by " change)))
    change))

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ;
;                              initialization                                  ;
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ;

(λ init-WALLPAPER-DUR-MINS [duration]
  "Initializes timer and timer duration. 
	Checks if there has been a duration chance since the last initalization"
  (let [duration-secs-new (hs.timer.minutes duration)]
    (print (.. "Converted duration of " duration " minutes into "
               duration-secs-new " seconds"))
    ;; get old duration
    (var duration-secs-old (hs.settings.get "wallpaper-timer-dur"))
    ;; if old duration is nil...
    (when (= nil duration-secs-old)
      (print "Old wallpaper timer duration is nil (due to this being the first run, or a bug. Setting it to 0")
      (set duration-secs-old 0))
    ;; calculate duration change
    (print "checking timer change (in seconds)")
    (let [change (check-value-change duration-secs-new duration-secs-old)]
      (if (not= 0 change (print (.. "Adjusting timer by " change " seconds"))
                (print "No change in duration of timer since last initialization"))
          ;; set new duration in persistent variable
          (hs.settings.set "wallpaper-timer-dur" duration-secs-new)))))

(print "Initalizing duration and timer")
(init-WALLPAPER-DUR-MINS WALLPAPER-DUR-MINS)

;; create timer object that will change wallpaper after certain amount of time
(set M.wallpaper-timer
     (hs.timer.new (* 60 WALLPAPER-DUR-MINS)
                   (fn [] (run-rotator WALLPAPER-FOLDER))))

(print "starting wallpaper-timer")
(M.wallpaper-timer:start)

; --- timer-pausing stuff ---
(fn pause-wallpaper-timer []
  "gets current wallpaper-timer time, 
	writes it to persistent var,
	pauses"
  (if (not (M.wallpaper-timer:running))
      (print "Warning: Timer not running. No action taken")
      (do
        (print "Saving time and pausing")
        (let [remaining-time (M.wallpaper-timer:nextTrigger)]
          (print (.. "Saving remaining wallpaper time: " remaining-time
                     " seconds"))
          (hs.settings.set "remaining-wallpaper-time" remaining-time)
          (print (.. "Saved " (hs.settings.get "remaining-wallpaper-time")
                     " seconds"))
          (M.wallpaper-timer:stop)
          (print "Stopped wallpaper-timer")))))

(fn resume-wallpaper-timer []
  "gets saved wallpaper-timer time, 
	continues timer"
  (if (M.wallpaper-timer:running)
      (print "Warning: Resumer called, but timer was already running. No action taken.")
      (do
        (print "Timer was stopped, running resumer...")
        (let [remaining-time (hs.settings.get "remaining-wallpaper-time")]
          (if (not (and remaining-time (> remaining-time 0)))
              (do
                (print "Warning: No valid remaining time found")
                (M.wallpaper-timer:start)
                (print "Restarted wallpaper timer"))
              (do
                (print "Remaining time found")
                (M.wallpaper-timer:setNextTrigger remaining-time)
                (print (.. "Recalled remaining time of " remaining-time "s"))
                (M.wallpaper-timer:start)
                (print (.. "Resumed timer with "
                           (hs.settings.get "remaining-wallpaper-time")))))))))

; pause on screen off var
(hs.settings.set "remaining-wallpaper-time" 0)
(print "Initalizing screen-state watcher")
(set M.screen-state-watcher
       (hs.caffeinate.watcher.new (fn [event-type]
                                    (when (. PAUSE_EVENTS event-type)
                                      (print "Screens went to sleep! running pauser")
                                      (pause-wallpaper-timer))
                                    (when (. RESUME_EVENTS event-type)
                                      (print "Screens have gone WOKE! running remainer")
                                      (resume-wallpaper-timer)))))

(print "starting wallpaper-timer")
(M.screen-state-watcher:start)
(print "wallpaper-timer started!")

;(print (.. "The value for screensaverDidStop is: "
;           hs.caffeinate.watcher.screensaverDidStop)

;; --- Hammerspoon Hotkey Binding ---
(hs.hotkey.bind ["cmd" "ctrl"] :E
                (fn []
                  (print "Hotkey E triggered for wallpaper rotation."
                         (run-rotator WALLPAPER-FOLDER))))
