#!/bin/bash
# file containing a list of input files (@ marks a title slide)
index=index
# output file name
output=lecture-slides.pdf

# default page selection
pages='1-'

# prefix for temp files
tmp=.tmp

jam() {
    local output=$1
    shift
    local args="$@"
    joined=$tmp-joined.pdf

    pdfjoin --outfile $joined -- $args
    pdfjam --nup 2x4 --a4paper --delta '0.05cm 1.5cm' --scale 0.95 \
        --frame true --outfile $output -- $joined 1-
}
add_to_manifest() {
    local file=$1
    local range=$2
    [ -z "$range" ] && range="1-"

    local pagecount=$(pdfinfo $file | grep Pages | cut -c8- | tr -d ' ')
    local spec="$out $range"
    if (( (pagecount % 2) == 1 ))
    then
        spec="${spec},{}"
    fi
    manifest="$manifest $spec"
}

manifest=""
todo=""
o=0
for name in $(cat index)
do
    echo "> $name"
    # check for title slides
    title=0
    if [ -z "${name##@*}" ]
    then
        title=1
        name=${name:1}
    fi

    if (( $title ))
    then
        if [[ $todo != "" ]]
        then
            out=$tmp-${o}.pdf
            let "o++"
            jam $out $todo
            add_to_manifest $out 2-
            todo=""
        fi
        out=$tmp-$(basename $name)
        pdfjoin $name $pages --outfile $out
        add_to_manifest $out
    else
        todo="$todo $name $pages"
    fi
done
if [[ "$todo" != "" ]]
then
    out=$tmp-${o}.pdf
    let "o++"
    jam $out $todo
    add_to_manifest $out 2-
fi

# jam it all together
echo ">> $manifest"
pdfjam $manifest --outfile $output

# remove temp files
rm ${tmp}*

