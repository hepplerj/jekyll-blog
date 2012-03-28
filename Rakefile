# Jason Heppler
# Modified from Jeff McFadden:
# http://jeffmcfadden.com/blog/2011/04/13/rsync-your-jekyll/

desc 'default: list available rake tasks'
task :default do
	puts 'Try one of these specific tasks:'
	sh 'rake --tasks --silent'
end

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
  puts 'Previewing the site with a local server.'
  puts 'Use CTRL+C to interrupt.'
  system('jekyll --auto --server --base-url / --url /')
end

desc "give title as argument and create new post title"
# usage rake write["Post Title Goes Here",category]
# category is optional
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
