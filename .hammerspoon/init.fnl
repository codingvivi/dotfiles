(hs.hotkey.bind [:cmd :alt :ctrl] :W
                (fn []
                  (: (hs.notify.new {:informativeText "Hello World"
                                     :title :Hammerspoon})
                     :send)))  
