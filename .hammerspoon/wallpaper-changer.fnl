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
(local imageFolder (.. (os.getenv :HOME) "/Pictures/Wallpaper Rotation/master"))

(local supported-UTIs ["com.apple.pict"
                       "com.compuserve.gif"
                       "com.microsoft.bmp"
                       "public.heic"
                       "public.heif"
                       "public.jpeg"
                       "public.png"
                       "public.tiff"])
                       

                       
(local wallpaper-time 30) ;; time to have wallpaper on screen in minutes

(print "UTIs supported:")
(each [_ UTI (ipairs supported-UTIs)]
  (print UTI))

(fn hassupportedUTI? [UTIs path]
  (each [_ UTI (ipairs UTIs)]
    (when (= UTI (hs.fs.fileUTI path))
      ;;(print (.. "File " path " has a supported UTI!"))
      (lua "return true"))))
  

(local (candidate-paths candidate-num candidate-dir-num)
       (hs.fs.fileListForPath imageFolder {:subdirs true}))
                                           ;;:ignore ["^.*$"] ;; ignore everything...
                                           ;;:except extension-regex})) ;; ...except the file extensions (ignores subdirs...)
(print (.. "Candidate count: " (tostring candidate-num)))

(fn make-file-list [UTIs file-paths]
  (let [file-list []]
    (each [_ path (ipairs file-paths)]
      (when (hassupportedUTI? UTIs path)
        (table.insert file-list path)))
    file-list))

(local wallpaper-list (make-file-list supported-UTIs candidate-paths))

(print (.. "Number of images added to wallpaper rotation: " (length wallpaper-list))) 

(fn print-filelist [list-of-files]
  "Print file list (for debug purposes)"
  (each [_ file (ipairs list-of-files)] ; Using _ for index again
    (print file)))

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
