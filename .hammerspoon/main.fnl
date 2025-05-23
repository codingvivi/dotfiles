;(require :wallpaper-changer)
(require :keymaps)

(local managed-apps {:Lexicon {:bundleID "com.rekord.cloud.lexicon"
                               :keymaps true}
                     :Terminal {:bundleID "com.apple.Terminal"
                                :keymaps false}})
                     

       

(fn get-focused-bundleID []
  "Gets bundle-id of focused app and returns it"
  (let [app (hs.application.frontmostApplication)]
    (when app
      (app:bundleID))))

;(fn matches-bundleID? [bundle-id-to-match]
;  "checks if the supplied bundle-id is a match with the current app in focus"
;  (let [curr-bundle-id (get-focused-bundleID)]
;    (print (.. "Current app bundle ID: " curr-bundle-id))
;    (if (= curr-bundle-id bundle-id-to-match)
;     (print "bundle id match!")
;     (print "bundle does not match...")))) 

(fn managed-bundle? [bundleID]
  (each [managed-name managed-info (pairs managed-apps)]
    (let [managed-bundleID (. managed-info :bundleID)]
      (when (= managed-bundleID bundleID)
        (print (.. "App" bundleID "is managed under \"" managed-name"\"!"))
        managed-name))))

(managed-bundle? :com.rekord.cloud.lexicon)

(fn has-keymaps? [appname])
  
  

;(fn handle-app-activation  [appName eventType appObject])
;  
;  
;
;;; Create a new watcher instance and tell it to call `handle-app-activation`
;(local app-watcher (hs.application.watcher.new handle-app-activation))
;
;
;;; Start the watcher
;(app-watcher:start)
;
;;; --- Initial Check (Optional) ---
;;;  run  logic once at startup for the currently active app
;;; because the watcher only triggers on *changes*.
;(fn run-for-current-app []
;  (let [current-app (hs.application.frontmostApplication)]
;    (when current-app
;      (handle-app-activation (current-app:name
;                               "initialCheck" ; pseudo event type
;                               current-app)))))
;
;(run-for-current-app) ; Call it
