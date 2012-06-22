---
layout: page
title: Papyri
group: none
category: Papyri
---
{% include JB/setup %}

<ul>
{% for post in site.categories.Papyri %}
  <li>
    <a href="{{BASE_PATH}}{{ post.url }}">{{ post.title }}</a>
  </li>
{% endfor %}
</ul>
