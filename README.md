# CoderSchool Showcase

Currently deployed at http://showcase.coderschool.vn!

## Brief description of this project

We'd like a way to show great submissions from our students to the world, as that's a common request coming in from the BD side. So here's a page where all the great submissions can live.

The content here is backed by Airtable. We have a base called "Project Showcase", accessible here: https://airtable.com/tblGrl7sxqjrqkwXl/viwBw0K6uX6F0SHnq. There are two tables in this base, "Apps" and "People".

GIFs are assumed to be uploaded to gfycat, for reasons I'll go into below.

## Airtable Schema

Right now there are the following fields:

`name`: this needs to be unique
`description`: this is the text that appears in the upper right when a submission is clicked
`cohortName`: this is a single select. Right now the naming convention is `Language Month Year`, with titlecase, e.g. Swift December 2015.
`members`: this is an array of references to people from the People table. Entries in the `People` table are just `name` (first name) and `media`. Airtable assumes all "attachment" types are arrays, but the code assumes there's one image here, and uses that image for the avatar.
`appIcon`: similarly also a media field, and again the code assumes only one.
`collections`: multiple select. I decided to use this instead of using the views functionality, but this is a grouping of "collections" the project belongs in, e.g. main for homepage, final for final project.
`gfycatName`: the slug from gfycat. I used gfycat because it's just nice - it generates mp4 and webm (which I embed, instead of a GIF) as well as a poster image. The frontend relies on Gfycat's minimal API to fetch information about an image from its slug, which gives URLs to posters and videos.

## How to run

Go to the folder and:
```
python -m SimpleHTTPServer 8080
Go to http://localhost:8080.
```
Known caveats on local: the filtering options do not work on local. On local, you're loading hardcoded test.json, because on production we use this reverse proxy thing. What do I mean by this reverse proxy thing? Read on.

## Reverse Proxy Thing

So I wanted to keep this whole thing frontend only, without a complicated backend. Unfortunately, there's no good way to hide our API Key from the world if we insert it in our client, and Airtable doesn't have scopes on its keys. So the best way to hide the key was to add an endpoint to our server at /airtable. Here's what our current .conf for the site on nginx looks like:
```
server {
        listen 80;
        server_name showcase.coderschool.vn; # add showcase A record to matbao
        root /var/apps/showcase/public_html;
        index index.html; # or .htm

    location ~* ^/airtable/(.*) {
        if ($request_method != GET) {
            return 403;
        }
        proxy_set_header HOST api.airtable.com;
        set $args $args&api_key=keyUL0oulYSPup4V6;
        proxy_pass http://airtable_api/$1$is_args$args;
        }
}

upstream airtable_api {
  server api.airtable.com;
}
```
So now one can send a GET request to `/airtable` gets proxy'ed to the actual airtable api. **NOTE**: this went haywire at one point and started redirecting towards foxmovies; a nginx reload fixed this.

## More about the Frontend

This is running RiotJS. Code is pretty cute, except for when I mucked it up by adding code related to filtering.

## Filtering

There are now two ways you can filter. Note you can only filter by ONE condition right now, and that cohortName takes precedence over collection.

* cohortName does an exact match on cohort name (case sensitive and all).
* collection looks for submissions that have that collection in the collections field.

### Examples

* Find all submissions that were final projects: `http://showcase.coderschool.vn/?collection=final`
* `http://showcase.coderschool.vn/?cohortName=Swift%20August%202015`

### Last Caveat

Right now, you cannot show all submissions. You're hardcoded to view objects from main if you don't specify any filtering options.
