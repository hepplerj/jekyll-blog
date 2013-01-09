# JasonHeppler.org  Site Source#
This repository contains the source for my personal site at [http://jasonheppler.org](http://jasonheppler.org).

The site runs on [Jekyll](https://github.com/mojombo/jekyll). 

# Source Structure #

> ├── _includes   globally included files  
> │   ├── analytics.html  
> ├── _layouts  
> │   ├── default.html  
> │   └── post.html  
> ├── _posts  
> ├── css

# Deployment Process #

Local site modifications are tested locally until correct and pushed to Github for storage offsite. Updates for public deployment are pushed to my web server through rsync.

# Terms of Use #
I'm more than pleased if you wish to borrow from my design but please be sure that *content* (anything inside _posts or pages, etc) is removed before you launch your site. If you don't understand it or didn't write it, remove it. Test everything locally before uploading your site.

Thanks!

# Licensing #
All the content (files and folders in _posts) along with the HTML files and index are under the [Attribution 3.0 Unported (CC BY 3.0)](http://creativecommons.org/licenses/by/3.0/) license (in short, my work is my contribution to free culture.) Feel free to use the HTML and CSS as you please. If you do use them, I would appreciate a link back to [http://github.com/hepplerj/jekyll-blog](http://github.com/hepplerj/jekyll-blog). 

# Notes #
My gitignore file ignores _site, .DS_Store, and _drafts.
