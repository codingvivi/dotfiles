;; utf8 sorter
(local natcmp (require :string.natcmp))

(local wallpaper-folder
       (.. (os.getenv :HOME) "/Pictures/Wallpaper Rotation/master"))

(local wallpaper-duration 5)

;in mins

(local supported-UTIs-old ["com.apple.pict"
                           "com.compuserve.gif"
                           "com.microsoft.bmp"
                           "public.heic"
                           "public.heif"
                           "public.jpeg"
                           "public.png"
                           "public.tiff"])

(print "UTIs supported:")
(each [_ UTI (ipairs supported-UTIs-old)]
  (print UTI))

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
;(let [(file-list b c) (get-files wallpaper-folder)]
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

; Increment index

(fn change-wallpaper-on-screen [file-path screen]
  "Sets the desktop image for the given screen."
  (print "test")
  (when (and file-path screen)
    (let [url (.. "file://" file-path)]
      (print (.. "Setting wallpaper to: " url))
      (screen:desktopImageURL url))
    (hs.alert.show (.. "Wallpaper: " (hs.fs.displayName file-path)))
    0.5))

(fn run-rotator [folder]
  (let [supported-UTIs ["com.apple.pict"
                        "com.compuserve.gif"
                        "com.microsoft.bmp"
                        "public.heic"
                        "public.heif"
                        "public.jpeg"
                        "public.png"
                        "public.tiff"]
        (cadidate-paths cadidate-num cadidate-dir-num) (get-files folder)
        image-paths (get-supported-file-paths supported-UTIs cadidate-paths)]
    (table.sort image-paths natcmp.utf8.lt) ; if image list is not nil or 0
    (when (and image-paths (> (length image-paths) 0))
      (table.sort image-paths natcmp.utf8.lt) ; sort list with image-paths ; calculate next index
      (let [next-index (calculate-next-index image-paths
                                             (hs.settings.get "wallpaper-index"))]
        ;if index is not nil
        (when next-index
          (hs.settings.set "wallpaper-index" next-index) ; set system variable for index
          (change-wallpaper-on-screen (. image-paths next-index)
                                      (hs.screen.mainScreen)))))))

;change the wallpaper

;; --- timing stuff ---
(fn check-value-change [value-new value-old]
  (let [change (- value-new value-old)]
    (if (= 0 change)
        (print "Value remains the same")
        (print (.. "Value has changed by" change)))
    change))

(fn init-wallpaper-timer [duration folder]
  (print "checking timer change (in seconds)")
  (let [duration-secs-new (hs.timer.minutes duration)]
    (var duration-secs-old (hs.settings.get "wallpaper-timer-dur"))
    (when (= nil duration-secs-old)
      (print "Old wallpaper timer duration is nil (due to this being the first run, or a bug. Setting it to 0")
      (set duration-secs-old 0))
    (let [change (check-value-change duration-secs-new
                                     duration-secs-old)]
      (when change
        (print (.. "Adjusting timer by" change "minutes"))
        (hs.settings.set "wallpaper-timer-dur" duration-secs-new))
      (local wallpaper-timer
             (hs.timer.new (hs.settings.get "wallpaper-timer-dur")
                           (fn [] (run-rotator folder))))
      (wallpaper-timer:start))))

(init-wallpaper-timer wallpaper-duration wallpaper-folder)

;;(fn wallpaper-timer [duration folder])

;; --- Hammerspoon Hotkey Binding ---
(hs.hotkey.bind ["cmd" "ctrl"] :E
                (fn []
                  (print "Hotkey E triggered for wallpaper rotation."
                         (run-rotator wallpaper-folder))))

;; Removed the unused setup-wallpaper-rotator-new

;(fn setup-wallpaper-rotator []
;  (print "Setting up wallpaper rotator...")
;  (local all-files-in-folder (hs.fs.fileListForPath wallpaper-folder {:subdirs true}))
;  (when (not all-files-in-folder)
;    (print (.. "Error: Could not read wallpaper folder: " wallpaper-folder))
;    (lua "return function() print('Wallpaper rotator not initialized: folder error.') end"))
;
;  (print (.. "Found " (length all-files-in-folder) " total items in folder."))
;
;  (local available-wallpapers (list-supported-files supported-UTIs all-files-in-folder))
;  (print (.. "Found " (length available-wallpapers) " supported wallpaper files."))
;
;  (local current-wallpaper-idx 0) ; Initialized once, captured by the closure
;
;  (fn rotate-wallpaper-action []
;    (print "--- Hotkey Pressed: Rotate Wallpaper ---")
;    (if (= (length available-wallpapers) 0)
;      (do
;        (print "No wallpapers available to rotate.")
;        (hs.alert.show "No wallpapers found!" 2))
;      (let [next-idx (calculate-next-index available-wallpapers current-wallpaper-idx)]
;        (if next-idx
;            (do
;              ;; CRITICAL FIX: Use `set` to modify the closed-over `current-wallpaper-idx`
;              (var current-wallpaper-idx next-idx)
;              (change-wallpaper-on-screen (. available-wallpapers current-wallpaper-idx)
;                                          (hs.screen.mainScreen)))
;            (hs.alert.show "Error calculating next wallpaper index." 2))))))
;
;;; Create an instance of our rotator action
;(local rotate-wallpaper (setup-wallpaper-rotator))
;
;
;;; Optional: To set the first wallpaper immediately on load/reload:
;;; (if rotate-wallpaper (rotate-wallpaper))
;
;(print "Wallpaper rotator script loaded. Press Cmd+Alt+Ctrl+E to change wallpaper.")

;; For initial testing, you might want to call it once to set the first wallpaper:
;; (if rotate-wallpaper (rotate-wallpaper))
;(hs.hotkey.bind [:cmd :alt :ctrl] :E (fn [] (change-wallpaper []))) ;;[]) 
;(print (update-index wallpaper-list 1800))
; Indicate success

;(if (not (and image-list (= (length image-list) 0)))
;  (print "Error: No suitable files for wallpapers found, or list is empty.")
;  (if (not (and (>= index 1) (<= index (length image-list)))))
;   (print (.. "Error: Index " index " is out of bounds for wallpaper list of length " (length image-list) ".")))

;(rotate-wallpaper wallpaper-list 1)
;(hs.timer.doEvery 10 print-bang)

;;(print-filelist)
;(fn print-UTI [list-of-files]
;  "Print UTI list (for debug purposes)"
;  (each [_ file (ipairs list-of-files)] ; Using _ for index again
;    (print (hs.fs.fileUTI file))))
;(print-UTI candidate-list)

;(print "extensions supported:")
;(each [_ ext (ipairs supported-extensions)]
;  (print ext))

;(local extension-regex 
;   (icollect [_ ext-keyword (ipairs supported-extensions)] ; _ means we don't care about the index
;     ;; concat the endings into regex expressions
;     (.. "(?i)\\." (tostring ext-keyword) "$"))))
;(print "Generated regex patterns for filtering:" (hs.inspect extension-regex))
;
;(print (.. "Current wallpaper directory: " imageFolder))(print "wallpaper-changer file loaded")
