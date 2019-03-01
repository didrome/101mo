---
title: "Archives"
date: 2017-10-10
layout: "archives"
comments: false
draft: true
---

=> https://blog.atj.me/2017/10/generate-yearly-and-monthly-archive-pages-with-hugo-sections/

--------

This blog, which is now generated with Hugo, uses the permalink structure /:year/:month/:slug (the slug is a url-safe version of the title). There are also “archive” pages, which list the articles posted in a given month or year. These pages have a permalink structure that compliments the post permalinks: /:year/:month and /:year respectively.

Back when this blog was generated with Jekyll, I used a plugin to generate the archive pages but there is no such mechanism in Hugo. It is possible to use taxonomies to accomplish this, but it involves defining a taxonomy for each year in the Hugo config, creating a corresponding layout and also adding redundant frontmatter to each post.

As an alternative, I created 2 new “sections” (top level subfolders in the content folder): archy and archm. archy contains one file per year and archm contains one file per month. These files can be generated automatically (see below).

Config

Define permalinks in the Hugo config file:

config.toml

# prevent hugo from creating folders/indexes for each section
disableKinds = ["section"]

[permalinks]
    # :title is used if :slug is not defined in post frontmatter
    posts = "/:year/:month/:slug/"
    archm = "/:year/:month/"
    archy = "/:year/"

Templates
Section Layouts

Create a corresponding layout for each section:

layouts/archy/single.html

{{ $archYear := .Date.Format "2006" }}

<h2>Archive for {{ $archYear }}</h2>

{{ range where .Site.Pages "Section" "posts" }}
    {{ if eq (.Date.Format "2006") $archYear }}
        {{ partial "post/archive" . }}
    {{ end }}
{{ end }}

layouts/archm/single.html

{{ $archYear := .Date.Format "2006" }}
{{ $archMonth := .Date.Format "January" }}

<h2>Archive for {{ $archMonth }} {{ $archYear }}</h2>

{{ range where .Site.Pages "Section" "posts" }}
    {{ if and (eq (.Date.Format "2006") $archYear) (eq (.Date.Format "January") $archMonth) }}
        {{ partial "post/archive" . }}
    {{ end }}
{{ end }}

layouts/partials/post/archive.html

<h3 class="post-title"><a href="{{ .Permalink }}">{{ .Title }}</a></h3>
<span class="post-date">{{ .Date.Format "02 Jan 2006" }}</span>
<div>{{ .Summary }}</div>

RSS Template

You probably don’t want the archy and archm pages to appear in the main RSS feed, so ensure your RSS Template uses a range with a where clause that limits it to pages of type posts:

{{ range first 10 (where .Data.Pages "Section" "posts") }}
<item>
    {{/* item child elements */}}
</item>
{{ end }}

Note: It is not recommended to set the rssLimit Hugo config option because it will count pages of all types. This is why the first 10 clause exists in the above example (which causes the feed to display a maximum of 10 items).
Navigation

When disableKinds = ["section"] is set in the Hugo config, .NextInSection and .PrevInSection cannot be used when creating navigation links.

In effect, this:

{{ with .NextInSection }}
    <a class="next" href="{{ .Permalink }}"><b>Next:</b> {{ .Title }}</a>
{{ end }}
{{ with .PrevInSection }}
    <a class="prev" href="{{ .Permalink }}"><b>Previous:</b> {{ .Title }}</a>
{{ end }}

becomes this:

{{ $.Scratch.Set "found" false }}
{{ $.Scratch.Set "prev" "" }}
{{ $.Scratch.Set "next" "" }}
{{ range where .Site.Pages "Section" "posts" }}
    {{ if eq .Permalink $.Permalink }}
        {{ $.Scratch.Set "found" true }}
    {{ else }}
        {{ if not ($.Scratch.Get "found") }}
            {{ $.Scratch.Set "next" . }}
        {{ else if eq ($.Scratch.Get "prev") "" }}
            {{ $.Scratch.Set "prev" . }}
        {{ end }}
    {{ end }}
{{ end }}
{{ with $.Scratch.Get "next" }}
    <a class="next" href="{{ .Permalink }}"><b>Next:</b> {{ .Title }}</a>
{{ end }}
{{ with $.Scratch.Get "prev" }}
    <a class="prev" href="{{ .Permalink }}"><b>Previous:</b> {{ .Title }}</a>
{{ end }}

Archive Links Example

You can generate a list of archive links like so:

<h3>Archive</h3>
<ul class="years">
    {{ range where .Site.Pages "Section" "archy" }}
    {{ $year := .Date.Format "2006" }}
    <li>
        <a href="{{ .Permalink }}">{{ $year }}</a>
        <ul class="months">
            {{ range where .Site.Pages "Section" "archm" }}
                {{ if eq (.Date.Format "2006") $year }}
                    <li><a href="{{ .Permalink }}">{{ .Date.Format "January" }}</a></li>
                {{ end }}
            {{ end }}
        </ul>
    </li>
    {{ end }}
</ul>

Section Content

The archy and archm content files each contain a single line of JSON specifying the corresponding date. For example:

content/archy/2008.md

{"date": "2008-01-01 00:00:00"}

content/archm/2008-09.md

{"date": "2008-09-01 00:00:00"}

Automation

I use the following script to generate the content files for archy and archm after analyzing the articles in the posts section. Note: I use YAML frontmatter in the post markdown files so this script uses the yaml-front-matter npm module to parse them. Be sure to use a parser that matches your frontmatter format.

scripts/gen-archives.js

#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const mkdirp = require('mkdirp');
const jsYaml = require('yaml-front-matter');

const years = {};
const contentPath = path.join(__dirname, '..', 'content');
const postsPath = path.join(contentPath, 'posts');
const archmPath = path.join(contentPath, 'archm');
const archyPath = path.join(contentPath, 'archy');

mkdirp.sync(archmPath);
mkdirp.sync(archyPath);

fs.readdirSync(postsPath).forEach(filePath => {
    //console.log(filePath);
    if(!filePath.match(/\.md$/)) { return; }
    const content = fs.readFileSync(path.join(postsPath, filePath), 'utf8');
    const meta = jsYaml.loadFront(content);
    if (meta.draft) {
        return;
    }
    const y = meta.date.getFullYear().toString();
    const m = (meta.date.getMonth() + 1).toString().padStart(2, '0');
    if (!years.hasOwnProperty(y)) {
        years[y] = new Set();
        writeFile(path.join(archyPath, `${y}.md`), y, '01');
    }
    if (!years[y].has(m)) {
        years[y].add(m);
        writeFile(path.join(archmPath, `${y}-${m}.md`), y, m);
    }
});

function writeFile(outPath, y, m)
{
    fs.writeFileSync(outPath, JSON.stringify({date: `${y}-${m}-01 00:00:00`}), 'utf8');
    console.log('++', outPath);
}

