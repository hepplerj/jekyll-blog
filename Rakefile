# Jason Heppler

desc 'deploy to jasonheppler.org via rsync'
task :deploy do
  # uploads ALL files b/c I often do site-wide changes and prefer overwriting all
  puts 'DEPLOYING TO JASONHEPPLER.ORG'
  # remove --rsh piece if not using 22
  sh "time jekyll && rsync -rtzh --progress _site/ jasonhep@jasonheppler.org:/home1/jasonhep/public_html/"
  puts 'Done!'
end

desc 'running Jekyll with --server --auto options'
task :dev do
  system('jekyll --server')
end

desc "give title as argument and create new post title"
# usage rake write["Post Title Goes Here",category]
task :write, [:title, :category] do |t, args|
  filename = "#{Time.now.strftime('%Y-%m-%d')}-#{args.title.gsub(/\s/, '_').downcase}.markdown"
  path = File.join("_posts", filename)
  if File.exist? path; raise RuntimeError.new("Won't clobber #{path}"); end
  File.open(path, 'w') do |file|
    file.write <<-EOS
---
layout: post
category: #{args.category}
title: #{args.title}
date: #{Time.now.strftime('%Y-%m-%d %k:%M:%S')}
---
EOS
    end
    puts "Now opening #{path} in TextMate..."
    system "mate #{path}"
end

namespace :tags do
  task :generate do
    puts 'Generating tags...'
    require 'rubygems'
    require 'jekyll'
    include Jekyll::Filters

    options = Jekyll.configuration({})
    site = Jekyll::Site.new(options)
    site.read_posts('')

    html =<<-HTML
---
layout: default
title: Tags
---

<h2>Tags</h2>

    HTML

    site.categories.sort.each do |category, posts|
      html << <<-HTML
      <h3 id="#{category}">#{category}</h3>
      HTML

      html << '<ul class="posts">'
      posts.each do |post|
        post_data = post.to_liquid
        html << <<-HTML
          <li>
            <div>#{date_to_string post.date}</div>
            <a href="#{post.url}">#{post_data['title']}</a>
          </li>
        HTML
      end
      html << '</ul>'
    end

    File.open('tags.html', 'w+') do |file|
      file.puts html
    end

    puts 'Done.'
  end
end
