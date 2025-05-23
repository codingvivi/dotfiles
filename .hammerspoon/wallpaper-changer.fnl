(local wallpaper-folder (.. (os.getenv :HOME) "/Pictures/Wallpaper Rotation/master"))

(local supported-UTIs ["com.apple.pict"
                       "com.compuserve.gif"
                       "com.microsoft.bmp"
                       "public.heic"
                       "public.heif"
                       "public.jpeg"
                       "public.png"
                       "public.tiff"])

;; (local min-until-switch 30) ;; We'll ignore this for now

(print "UTIs supported:")
(each [_ UTI (ipairs supported-UTIs)]
  (print UTI))

(fn hassupportedUTI? [UTI-list path]
  "Checks if file path matches one of the UTIs"
  (each [_ UTI (ipairs UTI-list)]
    (when (= UTI (hs.fs.fileUTI path))
      (lua "return true")))
  false) ; Explicitly return false if no match

(fn print-file-list [file-list]
  "Print file list (for debug purposes)"
  (each [_ file (ipairs file-list)]
    (print file)))

(fn list-supported-files [UTIs file-paths]
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
  (let [image-list-length (length file-list)] ;; (length nil) or (length {}) will be 0
    (case true
      ;; Condition 1: No files available
      (where _ (or (not file-list) (= 0 image-list-length)))
      (do
        (print "Error: No images found in file-list or file-list is nil.")
        nil) ; No files, no valid index

      ;; Condition 2: Invalid or uninitialized current index
      (where _ (or (not current-idx) (<= current-idx 0) (> current-idx image-list-length)))
      (do
        (print (.. "Info: Invalid or uninitialized index (" (tostring current-idx) "). Setting to 1."))
        1) ; Set to first image

      ;; Condition 3: Reached the end of the list
      (where _ (= current-idx image-list-length))
      (do
        (print "Info: End of file list. Starting over.")
        1) ; Wrap to first image

      ;; Default Case: Valid index, not at end of list
      _
      (do
        (print (.. "Info: Advancing index from " current-idx " to " (+ current-idx 1)))
        (+ current-idx 1))))) ; Increment index

(fn change-wallpaper-on-screen [file-path screen]
  "Sets the desktop image for the given screen."
  (when (and file-path screen)
    (let [url (.. "file://" file-path)]
      (print (.. "Setting wallpaper to: " url))
      (screen:desktopImageURL url))
    (hs.alert.show (.. "Wallpaper: " (hs.fs.displayName file-path))) 0.5)) ; Show a brief notification

(fn setup-wallpaper-rotator-new []
  (print "Setting up wallpaper rotator..."))
  



;; Removed the unused setup-wallpaper-rotator-new

(fn setup-wallpaper-rotator []
  (print "Setting up wallpaper rotator...")
  (local all-files-in-folder (hs.fs.fileListForPath wallpaper-folder {:subdirs true}))
  (when (not all-files-in-folder)
    (print (.. "Error: Could not read wallpaper folder: " wallpaper-folder))
    (lua "return function() print('Wallpaper rotator not initialized: folder error.') end"))

  (print (.. "Found " (length all-files-in-folder) " total items in folder."))

  (local available-wallpapers (list-supported-files supported-UTIs all-files-in-folder))
  (print (.. "Found " (length available-wallpapers) " supported wallpaper files."))

  (local current-wallpaper-idx 0) ; Initialized once, captured by the closure

  (fn rotate-wallpaper-action []
    (print "--- Hotkey Pressed: Rotate Wallpaper ---")
    (if (= (length available-wallpapers) 0)
      (do
        (print "No wallpapers available to rotate.")
        (hs.alert.show "No wallpapers found!" 2))
      (let [next-idx (calculate-next-index available-wallpapers current-wallpaper-idx)]
        (if next-idx
            (do
              ;; CRITICAL FIX: Use `set` to modify the closed-over `current-wallpaper-idx`
              (var current-wallpaper-idx next-idx)
              (change-wallpaper-on-screen (. available-wallpapers current-wallpaper-idx)
                                          (hs.screen.mainScreen)))
            (hs.alert.show "Error calculating next wallpaper index." 2))))))

;; Create an instance of our rotator action
(local rotate-wallpaper (setup-wallpaper-rotator))

;; --- Hammerspoon Hotkey Binding ---
(hs.hotkey.bind ["cmd" "alt" "ctrl"] :E
  (fn []
    (print "Hotkey E triggered for wallpaper rotation.")
    (when rotate-wallpaper ; Good practice to check if it was initialized
      (rotate-wallpaper))))


;; Optional: To set the first wallpaper immediately on load/reload:
;; (if rotate-wallpaper (rotate-wallpaper))

(print "Wallpaper rotator script loaded. Press Cmd+Alt+Ctrl+E to change wallpaper.")

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


   
