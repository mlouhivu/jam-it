# jam-it

Use *pdfjam* to jam together PDF slides into lecture handouts.

Layout of the output pages can be defined in the script (default: 2x4 grid)
and the input files are defined using an index file (see below for syntax).


## Usage

```
vi index
bash jam-it.sh
```


## Syntax of the index file

- Lines starting with `#` will be ignored as comments.
- Any word is considered a filename.
- Filenames that start with `@` start a new section.
- Filenames that start with `@` are also assumed to be in the correct output
  format (A4) and will be used as-is.
- Any other file will be first processed into the desired layout (edit the
  script, if needed).
- All files are jammed together in order.

**Note:** First "normal" file in a section is assumed to have a title slide for
the section as the first page, which will be dropped. So, use e.g.
`@section-title.pdf` to denote the start of a section **and** to give a A4
title page for the section.

## Example


```
$ cat index

# List of PDFs to jam together
#  an index file for jam-it.sh (https://github.com/mlouhivu/jam-it)

@title-course.pdf

@title-openacc-intro.pdf
01-GPU-intro.pdf
02-OpenACC-intro.pdf
03-OpenACC-data.pdf

@title-profiling.pdf
04-Profiling-GPUs.pdf
06-Multiple-GPUs.pdf
```

```
$ bash jam-it.sh
```
