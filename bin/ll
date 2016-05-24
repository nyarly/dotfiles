#!/bin/bash
##############
# ll = Lojban Lookup
##############

GISMU=~/lojban/gismu.txt
CMAVO=~/lojban/cmavo.txt
TEMP=/tmp/ll.1
WORD="[] 	.,\":()[]"	#Word boundary pattern
GREP="egrep"

USAGE="
$0 [-a] [-n] [-i] [-g] [-c] [-t] <words>

$0 looks through the gismu and cmavo word files for the given word,
in that order, as described below.  The gismu and cmavo entries can be
told apart by the (always uppercase) selma'o name in the rafsi columns
(in effect, column 2),

By default, $0 looks for <word> as either the exact word in the
first column (i.e. the exact lojbanic word) or an exact word in the
rafsi, gloss or mnemonic columns.  IOW, $0 by default only looks in the
first line of the paragraphs it outputs (this was made a reasonable
proposition by the discover that neither file contains the character
'$'.)

However, it was then discovered that using '$', which has meaning to
both the shell and sed, scraped badly.  So '@' is being used for the
same purpose (paragraph breaking and such).

-a:	Find the word anywhere, i.e. not just in the first line, but
still an exact word match.

-n: No space checking.  'mil' finds 'milti'. Note that, keeping
shell quoting issues in mind, an arbitrary grep expression can be passed
to -n with the expected results.

-i: Case insensitive.

-c: cmavo only.

-h: turn h into '

-g: gismu only.

-w: Wiki format output.

-s: strict; searches only on the lojban word field.

Using both -n and -a causes a bare grep to be run, i.e. <word> will
be found _anywhere_ it can.

Using both -g and -c is a NOP.

The difference between the arguments is well exemplified by running
$0 ra'i, $0 -a ra'i, $0 -ai ra'i, $0 -n ra'i, $0 -an ra'i.
"

while getopts anigchsw c; do
    case $c in
	a)	ANY="ANY";;
	n)	NS="NS";;
	i)	GREP="$GREP -i";;
	g)	GONLY="g";;
	c)	CONLY="c";;
	h)	HCONV="h";;
	w)	WIKI="w";;
	s)	STRICT="s";;
	\?)     echo "$USAGE"
	exit 2;;
    esac
done

shift `expr $OPTIND - 1`

if [ $# -lt 1 ]; then
    echo "$USAGE"
    exit 2
fi

if [ -n "$WIKI" ]; then
    print "! Proposed Definitions And Examples\n\n";
fi

while [ "$1" ]; do

    pat=$1

    cat /dev/null >$TEMP

    #This section turns all 'h's into 's.  Done because putting ' on the
    #command line is a huge pain in the ass.
    if [ "$HCONV" ]
    then
	pat=`echo $pat | sed "s/h/['h]/g"`
    fi

    #The sed statements below are to turn, for example, 'can' into ' can '.
    #This way, we can take ' out of WORD and still get correct behaviour.
    #Taking ' out of $WORD is good because then ra doesn't match ra'o
    if [ -n "$GONLY" -o -z "$CONLY" ]
    then
	$GREP "$pat" $GISMU | \
	sed "s/ '\([A-Za-z][a-zA-Z. ]*[A-Za-z]\)' / ' \1 ' /" >> $TEMP
    fi
    if [ -n "$CONLY" -o -z "$GONLY" ]
    then
	$GREP "$pat" $CMAVO | \
	sed "s/[ .]'\([A-Za-z][a-zA-Z. ]*[A-Za-z]\)' / ' \1 ' /" >> $TEMP
    fi

    #lb rafsi english mnemonic description ??   freq notes
    #1  8     21      42       63          160  165  170

    if [ -n "$WIKI" ]
    then
	cat $CMAVO | $GREP "$pat" | $GREP -v '^ [0-9]* Lojban' | \
	awk '{ printf("!! Proposed Definition of ##%s##@@;__%s__ (%s): %s -- %s -- %s@** Keywords:@@!! Examples of ##%s## Usage@\n",
	substr($0, 0, 11), substr($0, 0, 11), substr($0, 12, 9), substr( $0, 21, 20),
	substr($0, 63, 96), substr($0, 169), substr($0, 0, 11) ); }' | \
	sed -e 's/ *__ */__/' -e 's/  *__/__/' -e 's/  *)/)/' | \
	sed -e 's/## *\([^ ]*\) *##/##\1##/g' | \
	sed -e 's/ *-- */ -- /g' | \
	$GREP "(\@\@;__[^_]*${pat}[^_]*__|^[^(]*\([^(]*${pat}[^)]*\))" | \
	tr -d '\r' | tr '@#' "\n"\'
	#$GREP "(\@\@;__${pat}__|^[^(]*\(${pat}\))" | tr -d '\r' | tr '@#' "\n"\'

	# Short circuit all the other crap.
	shift
	continue
    else
	cat $TEMP | $GREP -v '^ [0-9]* Lojban' | \
	awk '{ printf("@%s@%20s%s@@%20s%s\n", \
	substr($0, 0, 62), "", substr($0, 63, 97), "", substr( $0, 169)); }' | \
	sed 's/@   */@                    /g' | \
	cat >$TEMP.2
    fi

    if [ -z "$STRICT" ]
    then
	if [ -n "$NS" -a -n "$ANY" ]
	then
	    cat $TEMP.2 | \
	    tr '@' '\n' | fmt > $TEMP
	fi

	if [ -n "$NS" -a -z "$ANY" ]
	then
	    cat $TEMP.2 | \
	    $GREP "^@[^@]*${pat}[^@]*@" | \
	    tr '@' '\n' | fmt > $TEMP
	fi

	if [ -n "$ANY" -a -z "$NS" ]
	then
	    cat $TEMP.2 | \
	    $GREP "$WORD$pat$WORD" | \
	    tr '@' '\n' | fmt > $TEMP
	fi

	if [ -z "$ANY" -a -z "$NS" ]
	then
	    cat $TEMP.2 | \
	    $GREP "^@[^@]*${WORD}${pat}${WORD}[^@]*@" | \
	    tr '@' '\n' | fmt > $TEMP
	fi
    else
	cat $TEMP.2 | \
	$GREP "(^@ \.?${pat} [A-Z ].*|^@ \.?${pat} [a-z][a-z][a-z] .*)" | \
	tr '@' '\n' | fmt > $TEMP
    fi

    num=`cat $TEMP | wc -l`
    #####
    # This version works on linux, but not bsd.
    #
    eval `stty -a | tr ';' '
    ' | grep rows | sed 's/^ //' | tr ' ' '='`


    #####
    # This version works on bsd, but not linux.
    #
    #eval `stty -a | tr ';' '
    #' | grep rows | sed 's/^ //' | tr ' ' '=' \
    #| sed 's/\(.*\)=\(.*\)/\2=\1/'`

    if [ "$num" -gt "`expr $rows - 5`" ]
    then
	${PAGER-more} $TEMP
    else
	cat $TEMP
    fi
    rm $TEMP
    rm $TEMP.2

    shift

done

if [ -n "$WIKI" ]
then
    print "! Notes\n\n";
    print "! Impact\n\n";
fi
