## Get ready
Replace the contents of `css/theme` with the contents from the same directory in the new revealjs version

## Font prep
Grab fonts offline using an [npm module](https://github.com/makovich/google-fonts-offline). 
If there's no change in fonts, then no need to run through this step

Current offline fonts required:

- https://fonts.googleapis.com/css?family=Lato:400,700,400italic,700italic
- https://fonts.googleapis.com/css?family=News+Cycle:400,700
- https://fonts.googleapis.com/css?family=Quicksand:400,700,400italic,700italic
- https://fonts.googleapis.com/css?family=Open+Sans:400italic,700italic,400,700
- https://fonts.googleapis.com/css?family=Ubuntu:300,400,700,300italic,700italic

How to add offline fonts to dir and css:

- `goofoffline outDir=font "https://fonts.googleapis.com/css?family=Lato:400,700,400italic,700italic"`

## Replace online calls
From this directory, call SwtcihToOffline.r

This will read the settings files in `css/theme/source`, replace any online calls to use the `fonts.css` file instead.

## Run gulp
To generate new copies of the all relevant CSS files, we need to build them from the scss files

- `npm install`
- `npm install grunt --save-dev`
- `grunt css-themes`

## Copy over contents
From `altcss/`, put the new contents into the various folders. Make sure to edit the destination directory.

- `cp -r css/* ../reveal.js-3.6.0/css`
- `cp -r css/* ../reveal.js-3.6.0/lib/font`