def main [] {
  help main
}

def "main org agenda" [] {
  emacsclient -c -F '((name . "OrgAgendaFrame"))' -e '(progn (org-agenda))'
}

def "main org agenda list" [] {
  emacsclient -c -F '((name . "OrgAgendaFrame"))' -e '(progn (org-agenda-list) (delete-other-windows))'
}

def "main org roam dailies today goto" [] {
  let note_path =  main org roam dailies today getpath 
  let note_exists = $note_path | path exists

  if ($note_exists) == false {
    main org roam dailies today create
  }

  emacsclient -c -F '((name . "OrgDailyFrame"))' -e '(org-roam-dailies-goto-today)'
}

def "main org roam dailies dir getpath" [] {
    $env
    | get --optional ORG_DAILIES_DIR
    | default  ( emacsclient --eval '(expand-file-name org-roam-dailies-directory org-roam-directory)')
    | str trim --char "\""
}

def "main org roam dailies today getpath" [] {
  let currdate = date now | format date "%Y-%m-%d"
  let daily_path = main org roam dailies dir getpath  

  { parent: $daily_path, stem: $currdate, extension: 'org' }
  | path join
}

def "main org roam dailies check-existence" [] {
  main org roam dailies dir getpath 
  | path exists
}

def "main org roam dailies today create" [] {
  emacsclient -e "(progn (org-roam-dailies-capture-today) (org-capture-finalize))"
}
