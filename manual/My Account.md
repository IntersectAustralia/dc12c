---
layout: page
title: My Account
group: none
category: My Account
---
{% include JB/setup %}

<ul>
{% for post in site.categories["My Account"] reversed %}
  <li>
    <a href="{{BASE_PATH}}{{ post.url }}">{{ post.title }}</a>
  </li>
{% endfor %}
</ul>
