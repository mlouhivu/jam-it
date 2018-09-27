#!/bin/bash
# file containing a list of input files (@ marks a title slide)
index=index
# output file name
output=lecture-slides.pdf

# pdfjam options to use
options="--nup 2x4 --a4paper --delta '0.05cm 1.5cm' --scale 0.95 --frame true"
# default page selection
pages='1-'

# prefix for temp files
tmp=.tmp

manifest=""
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

    out=$tmp-$(basename $name)

    if (( $title ))
    then
        cp $name $out
    else
#        pdfjam $options --outfile $out -- $name $pages
        pdfjam --nup 2x4 --a4paper --delta '0.05cm 1.5cm' --scale 0.95 \
            --frame true --outfile $out -- $name $pages
    fi
    pagecount=$(pdfinfo $out | grep Pages | cut -c8- | tr -d ' ')

    spec="$out 1-"
    if (( (pagecount % 2) == 1 ))
    then
        spec="${spec},{}"
    fi
    manifest="$manifest $spec"
done

# jam it all together
echo ">> $manifest"
pdfjam $manifest --outfile $output

# remove temp files
rm ${tmp}*

