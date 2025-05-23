
;;(hs.hotkey.bind [:cmd :alt :ctrl] :W (fn [] (matches-bundleID? lexicon-id))) ;;[]) 


;; --- Configuration ---
(local target-bundle-id "com.apple.Terminal") ; Example: Only active for Terminal
;; (local target-bundle-id "com.microsoft.VSCode") ; Example: VS Code
;; (local target-bundle-id "com.google.Chrome")  ; Example: Chrome

;; --- State ---
;; This table will hold our hotkey objects that are app-specific
(var app-specific-hotkeys [])
(var app-watcher nil) ; To store our application watcher instance

;;; --- Helper Functions (your existing ones are good) ---
;(fn get-focused-bundleID []
; "Gets bundle-id of focused app and returns it"
; (let [app (hs.application.frontmostApplication)]
;   (when app
;     (app:bundleID))))

;; --- Core Logic ---

(fn setup-target-app-hotkeys []
  "Define the hotkeys that should only be active for the target app.
   They are created here but will be enabled/disabled by the watcher."
  ;; Clear any existing hotkeys if this function is called again (e.g., on reload)
  (each [_ hk (ipairs app-specific-hotkeys)] (hk:delete)) ; Fully remove old ones
  (set app-specific-hotkeys [])

  ;; Example Hotkey 1: Cmd+Shift+H for the target app
  (let [hk1 (hs.hotkey.bind [:cmd :shift] :h
              (fn []
                (hs.alert.show (.. "Hotkey active in " target-bundle-id "!"))
                (hs.notify.show {:title (.. target-bundle-id " Action")
                                 :informativeText "Cmd+Shift+H was pressed!"})))]
    (table.insert app-specific-hotkeys hk1))

  ;; Example Hotkey 2: Ctrl+Opt+P
  (let [hk2 (hs.hotkey.bind [:ctrl :opt] :p
              (fn []
                (hs.alert.show (.. "Another one for " target-bundle-id "!"))
                (hs.execute (.. "say \"Hello from " target-bundle-id "\""))))]
    (table.insert app-specific-hotkeys hk2))

  ;; --- Add more hotkeys here as needed ---

  ;; Initially, disable all of them. The watcher will enable them if appropriate.
  (each [_ hk (ipairs app-specific-hotkeys)]
    (hk:disable)))

(fn update-hotkey-states-for-app [app-object]
  "Enables or disables app-specific-hotkeys based on the given app-object."
  (let [current-bundle-id (when app-object (app-object:bundleID))]
    (if (= current-bundle-id target-bundle-id)
      (do
        (print (.. "INFO: " target-bundle-id " is focused. Enabling hotkeys."))
        (each [_ hk (ipairs app-specific-hotkeys)]
          (hk:enable)))
      (do
        ;; (print (.. "INFO: " (or current-bundle-id "No app") " is focused. Disabling hotkeys for " target-bundle-id "."))
        ;; This can be noisy, only print if current-bundle-id was the previous target or something
        (each [_ hk (ipairs app-specific-hotkeys)]
          (hk:disable))))))

(fn application-activated-callback [app-name event-type app-object]
  "Callback for hs.application.watcher when an app is activated."
  ;; We only care about the 'activated' event
  (when (= event-type hs.application.watcher.activated)
    (update-hotkey-states-for-app app-object)))

(fn start-app-watcher []
  "Initializes and starts the application watcher."
  (when app-watcher ; Stop existing watcher if script is reloaded
    (app-watcher:stop)
    (set app-watcher nil))

  (set app-watcher (hs.application.watcher.new application-activated-callback))
  (app-watcher:start)
  (print (.. "INFO: Application watcher started for " target-bundle-id " hotkeys.")))


;; --- Initialization ---
(fn init []
  (print (.. "INFO: Initializing app-specific keymaps for: " target-bundle-id))
  (setup-target-app-hotkeys) ; Define our hotkeys
  (start-app-watcher)      ; Start watching for app focus changes

  ;; Crucially, perform an initial check for the currently focused app
  ;; because the watcher only fires on *changes*.
  (update-hotkey-states-for-app (hs.application.frontmostApplication)))

;; Call init to set everything up
(init)

;; --- For Reloading Config ---
;; If you reload your Hammerspoon config, you might want to stop the watcher
;; to avoid multiple watchers or orphaned hotkeys. The init function already
;; handles stopping an existing watcher if `app-watcher` is not nil.
;; You can also add a more explicit cleanup if needed, e.g. in a separate function
;; that you would call before hs.reload().

(fn stop-everything []
 (when app-watcher
   (app-watcher:stop)
   (set app-watcher nil))
 (each [_ hk (ipairs app-specific-hotkeys)]
   (hk:delete)) ; or hk:disable() if you might reuse them
 (set app-specific-hotkeys [])
 (print "INFO: App-specific keymaps and watcher stopped."))

;; -- To test --
;; 1. Save this as part of your init.fnl or a separate file you `require`.
;; 2. Change `target-bundle-id` to an app you use (e.g., "com.apple.TextEdit").
;; 3. Reload Hammerspoon config.
;; 4. Switch to the target app. Try Cmd+Shift+H and Ctrl+Opt+P.
;; 5. Switch to another app. Try the hotkeys – they should do nothing.
;; 6. Check Hammerspoon console for INFO messages.
