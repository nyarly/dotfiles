set -x GOPATH ~/golang
set -x PATH $PATH $GOPATH/bin

if test -d /usr/lib/go/bin
  set -x PATH $PATH /usr/lib/go/bin
end
