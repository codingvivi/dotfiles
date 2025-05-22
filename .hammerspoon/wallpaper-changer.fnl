;(fn helloworld [] (hs.alert.show "Hello World!!"))
;(local currentFile  (.. (os.getenv :HOME "/Picturrs/Wallpaper Rotation/master/0 - Z-AO - 80713652_p0")))
;(each [file (hs.fs.dir imageFolder)] (print file))  

(print "wallpaper script:")
;(local supported-extensions [:bmp
;                             :gif
;                             :heic
;                             :heif
;                             :jpeg
;                             :jpg
;                             :pct
;                             :pict
;                             :png
;                             :tif
;                             :tiff
;                             :webp))
(local wallpaper-folder (.. (os.getenv :HOME) "/Pictures/Wallpaper Rotation/master"))

(local supported-UTIs ["com.apple.pict"
                       "com.compuserve.gif"
                       "com.microsoft.bmp"
                       "public.heic"
                       "public.heif"
                       "public.jpeg"
                       "public.png"
                       "public.tiff"])

;;(local min-until-switch 30) ;; time to have wallpaper on screen in minutes

;;(print "UTIs supported:")
;;(each [_ UTI (ipairs supported-UTIs)]
;;  (print UTI))

(fn hassupportedUTI? [UTI-list path]
  "Checks if file path matches one of the UTIs"
  (each [_ UTI (ipairs UTI-list)]
    (when (= UTI (hs.fs.fileUTI path))
      ;;(print (.. "File " path " has a supported UTI!"))
      (lua "return true"))))

;(local (candidate-paths candidate-num candidate-dir-num)
;       (hs.fs.fileListForPath image-folder {:subdirs true})))))

;(print (.. "Candidate count: " (tostring candidate-num)))

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

;(local wallpaper-list (make-file-list supported-UTIs candidate-paths))


(fn update-file-index [file-list index]
  "Increments a file index by 1, or sets it the previous index is invalid.
	Returns 0 if there is a problem with the file list"
  (let [image-list-length (length file-list)]
    (print (.. "Number of files available:" image-list-length))
    (print (.. "Current index position:" index))
    (case true
      (where _ (not file-list)) (do (print "Error: file-list is nil (or false). Somewhere something went wrong...")
                                  0)
      (where _ (= 0 image-list-length)) (do (print "Error: no images found")
                                          0)
      (where _ (<=  index 0)) (do (print "Error: index <= 0. Setting wallpaper to file 1") 
                                1)
      (where _ (< image-list-length index)) (do (print "Error: Index outside of total file list length. Setting wallpaper to file 1...") 
                                              1)
      (where _ (= image-list-length index)) (do (print "End of file list. Starting over.") 
                                              1)
      _ (do (print "Changing wallpaper") 
          (+ index 1)))))
 
  
(fn change-wallpaper [file-paths index screen]
  (let [url (.. "file://" (. file-paths index))]
    (hs.screen.mainScreen:desktopImageURL url))) 


(hs.hotkey.bind [:cmd :alt :ctrl] :E (fn [] (change-wallpaper []))) ;;[]) 
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
;(print (.. "Current wallpaper directory: " imageFolder))

(print "wallpaper-changer file loaded")


   
