function line() {
  if (sub(/^--\]\]/,"")) { # multi-line comments end
    b4  = code = 1
    top = loop = 0 
    return
  } 
  if (sub(/^--\[\[/,"")) { # multi-line comments start
    if (!top) print "```"  # if top, then nothing to close
    b4  = loop = 1 
    top = code = 0
    return
  } 
  if (loop) { # loop over multi line commnts
    print
    return
  } 
  # toggle between comments and non-comments
  now = sub(/^-- /,"")
  if (  b4 && !now ) { code=1; print "```lua" }
  if ( !b4 &&  now ) { code=0; print "```"    }
  print 
  b4  = now
  top = loop = 0 
}

BEGIN { 
  code = 0 # are we processing code?
  b4   = 0 # was the line before a comment?
  loop = 0 # are we looping thru multi-line comments?
  top  = 1 # is this the first thing in the file?
  while (getline) line()
  if(code) print "```\n"
}
