---
title: example ...
date: 2017-03-20
draft: true
tags: ["example", "bigimg"]
bigimg: [{src: "/img/triangle.jpg", desc: "Triangle"}, {src: "/img/sphere.jpg", desc: "Sphere"}, {src: "/img/hexagon.jpg", desc: "Hexagon"}]
---

a encbla blab blablaa encbla blab blablaa encbla blab blablaa encbla blab blablaa encbla blab blablaa encbla blab blablaa encbla blab blablaa encbla blab blablaa encbla blab blablaa encbla blab blablaa encbla blab blabla

a encbla blab blablaa encbla blab blablaa encbla blab blablaa encbla blab blabla

<!--more-->

a encbla blab blablaa encbla blab blablaa encbla blab blabla

{{< vimeo id="244407565" class="flex-video" >}}

erfeerfrefe


------


Beautiful Hugo adds a few custom shortcodes created by [Li-Wen Yip](https://www.liwen.id.au/heg/) and [Gert-Jan van den Berg](https://github.com/GjjvdBurg/HugoPhotoSwipe) for making galleries with [PhotoSwipe](http://photoswipe.com) . 

{{< gallery caption-effect="fade" >}}
  {{< figure thumb="-thumb" link="/img/hexagon.jpg" >}}
  {{< figure thumb="-thumb" link="/img/sphere.jpg" caption="Sphere" >}}
  {{< figure thumb="-thumb" link="/img/triangle.jpg" caption="Triangle" alt="This is a long comment about a triangle" >}}
{{< /gallery >}}

<!--more-->
## Example
The above gallery was created using the following shortcodes:
```
{{</* gallery caption-effect="fade" */>}}
  {{</* figure thumb="-thumb" link="/img/hexagon.jpg" */>}}
  {{</* figure thumb="-thumb" link="/img/sphere.jpg" caption="Sphere" */>}}
  {{</* figure thumb="-thumb" link="/img/triangle.jpg" caption="Triangle" alt="This is a long comment about a triangle" */>}}
{{</* /gallery */>}}
```

## Usage
For full details please see the [hugo-easy-gallery GitHub](https://github.com/liwenyip/hugo-easy-gallery/) page. Basic usages from above are:

- Create a gallery with open and close tags `{{</* gallery */>}}` and `{{</* /gallery */>}}`
- `{{</* figure src="image.jpg" */>}}` will use `image.jpg` for thumbnail and lightbox
- `{{</* figure src="thumb.jpg" link="image.jpg" */>}}` will use `thumb.jpg` for thumbnail and `image.jpg` for lightbox
- `{{</* figure thumb="-small" link="image.jpg" */>}}` will use `image-small.jpg` for thumbnail and `image.jpg` for lightbox
- All the [features/parameters](https://gohugo.io/extras/shortcodes) of Hugo's built-in `figure` shortcode work as normal, i.e. src, link, title, caption, class, attr (attribution), attrlink, alt
- `{{</* gallery caption-effect="fade" */>}}` will fade in captions for all figures in this gallery instead of the default slide-up behavior
- Many gallery styles for captions and hover effects exist; view the [hugo-easy-gallery GitHub](https://github.com/liwenyip/hugo-easy-gallery/) for all options
- Note that this theme will load the photoswipe gallery theme and scripts by default, no need to load photoswipe on your individual pages