   BEGIN { FS="\n"; RS="" }
   NR==1 { if($0 ~ /name=top>/) next  }
         { print ""; print $0 }
