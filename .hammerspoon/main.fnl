(fn helloworld [] (hs.alert.show "Hello World!!"))


(fn get-focused-app-bundle-id []
  "Gets bundle-id of focused app and returns it"
  (let [app (hs.application.frontmostApplication)]
    (when app
      (app:bundleID))))

(fn bundle-id-check [bundle-id-to-match]
  "checks if the supplied bundle-id is a match with the current app in focus"
  (let [curr-bundle-id (get-focused-app-bundle-id)]
    (print (.. "Current app bundle ID: " curr-bundle-id))
    (if (= curr-bundle-id bundle-id-to-match)
     (print "bundle id match!")
     (print "bundle does not match...")))) 
      

(local lexicon-id :com.rekord.cloud.lexicon)

(hs.hotkey.bind [:cmd :alt :ctrl] :W (fn [] (bundle-id-check lexicon-id))) ;;[])  
