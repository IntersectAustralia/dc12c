---
layout: page
title: Papyri Admin
group: none
category: Papyri Admin
---
{% include JB/setup %}

<ul>
{% for post in site.categories["Papyri Admin"] %}
  <li>
    <a href="{{BASE_PATH}}{{ post.url }}">{{ post.title }}</a>
  </li>
{% endfor %}
</ul>
