;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ;
;                                   require                                    ;
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ;
;; utf8 sorter
(local natcmp (require :string.natcmp))

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ;
;                                    locals                                    ;
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ;
(local WALLPAPER-FOLDER
       (.. (os.getenv :HOME) "/Pictures/Wallpaper Rotation/master"))

;;in mins
(local WALLPAPER-DUR-MINS 30)

(local SUPPORTED-UTIS ["com.apple.pict"
                       "com.compuserve.gif"
                       "com.microsoft.bmp"
                       "public.heic"
                       "public.heif"
                       "public.jpeg"
                       "public.png"
                       "public.tiff"])

(print "UTIs supported:")
(each [_ UTI (ipairs SUPPORTED-UTIS)]
  (print UTI))

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ;
;                                   helpers                                    ;
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ;
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ files ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ;
(fn get-files [folder-path]
  "Returns number list with files, number of files and subdirs"
  (let [(files filenum dirnum) (hs.fs.fileListForPath folder-path
                                                      {:subdirs true})]
    (print (.. "Folder: " folder-path))
    (print (length files))
    (print (.. "Number of files: " filenum))
    (print (.. "Number of directories: " dirnum))
    (values files filenum dirnum)))

(fn print-file-list [file-list]
  "Print file list (for debug purposes)"
  (each [_ file (ipairs file-list)]
    (print file)))

;; debugging
;(let [(file-list b c) (get-files WALLPAPER-FOLDER)]
;  (print-file-list file-list))

(fn hassupportedUTI? [UTI-list path]
  "Checks if file path matches one of the UTIs"
  (each [_ UTI (ipairs UTI-list)]
    (when (= UTI (hs.fs.fileUTI path))
      (lua "return true")))
  false)

; Explicitly return false if no match

(fn get-supported-file-paths [UTIs file-paths]
  "Takes a list of files, returns a list of files that match a list of UTIs"
  (let [file-list []]
    (each [_ path (ipairs file-paths)]
      (when (hassupportedUTI? UTIs path)
        (table.insert file-list path)))
    file-list))

(fn calculate-next-index [file-list current-idx]
  "Calculates the next valid index for the file-list using 'case true'.
   Handles wrap-around and initialization from 0 or invalid index.
   Returns nil if file-list is empty or nil."
  (if (= file-list nil)
      (print "Error: file list is nil...")
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
            (+ current-idx 1))))))

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

(lambda print-screen-details [screen]
  "Returns text with screen name and dimensions for printing"
  (print (.. "Screen" (screen:name) " - "
             (let [frame (screen:frame)]
               (.. frame.w " x " frame.h "px")))))

(lambda iterate-screens [screen-list func ?args]
  "Iterates to a list of screens running a function on each"
  (each [i screen (ipairs screen-list)]
    (func screen)))

; ~~~~~~~~~~~~~~~~~~~~~~~ screen + file helper combos ~~~~~~~~~~~~~~~~~~~~~~~~ ;
(fn change-wallpaper-on-screen [screen file-path]
  "Sets the desktop image for the given screen."
  (print "test")
  (when (and file-path screen)
    (let [url (.. "file://" file-path)]
      (print (.. "Setting wallpaper to: " url))
      (screen:desktopImageURL url))
    (print (.. "Wallpaper: " (hs.fs.displayName file-path)))
    0.5))

(lambda run-rotator [folder]
  (let [supported-UTIs ["com.apple.pict"
                        "com.compuserve.gif"
                        "com.microsoft.bmp"
                        "public.heic"
                        "public.heif"
                        "public.jpeg"
                        "public.png"
                        "public.tiff"]
        (cadidate-paths cadidate-num cadidate-dir-num) (get-files folder)
        image-paths (get-supported-file-paths supported-UTIs cadidate-paths)
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
                                                 (hs.settings.get "wallpaper-index"))
                next-image (. image-paths next-index)]
            ;... and change wallpapers
            (when next-index
              (hs.settings.set "wallpaper-index" next-index)
              (change-wallpaper-on-screen (. image-paths next-index)
                                          (hs.screen.mainScreen))))))))

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

(fn init-WALLPAPER-DUR-MINS [duration]
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
(local wallpaper-timer
       (hs.timer.new (hs.settings.get "wallpaper-timer-dur")
                     (fn [] (run-rotator WALLPAPER-FOLDER))))

(print "starting wallpaper-timer")
(wallpaper-timer:start)

; --- timer-pausing stuff ---
(fn pause-wallpaper-timer []
  "gets current wallpaper-timer time, 
	writes it to persistent var,
	pauses"
  (print "Screens went to sleep.")
  (print "Saving remaining wallpaper time")
  (hs.settings.set "remaining-wallpaper-time" (wallpaper-timer:nextTrigger))
  (print (.. (hs.settings.get "remaining-wallpaper-time") " seconds remaining"))
  (print "Stopping wallpaper-timer"))

(fn resume-wallpaper-timer []
  "gets saved wallpaper-timer time, 
	continues timer"
  (print "Screens woke up. Resuming wallpaper-timer")
  (print (.. (hs.settings.get "remaining-wallpaper-time") " seconds remaining"))
  (wallpaper-timer:setNextTrigger (hs.settings.get "remaining-wallpaper-time")))

; pause on screen off var
(hs.settings.set "remaining-wallpaper-time" 0)
(print "Initalizing screen-state watcher")
(local screen-state-watcher
       (hs.caffeinate.watcher.new (fn [event-type]
                                    (when (= event-type
                                             ;(or hs.caffeinate.watcher.screensaverDidStart)
                                             hs.caffeinate.watcher.screensDidSleep)
                                      (pause-wallpaper-timer)
                                      (wallpaper-timer:stop))
                                    (when (= event-type
                                             (or hs.caffeinate.watcher.screensaverDidStop
                                                 hs.caffeinate.watcher.screensDidWake))
                                      (resume-wallpaper-timer)))))

(print "starting wallpaper-timer")
(screen-state-watcher:start)

;; --- Hammerspoon Hotkey Binding ---
(hs.hotkey.bind ["cmd" "ctrl"] :E
                (fn []
                  (print "Hotkey E triggered for wallpaper rotation."
                         (run-rotator WALLPAPER-FOLDER))))
