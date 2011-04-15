# based on the import script by icebreaker, which is based on mojombo's
# https://github.com/mojombo/jekyll/blob/master/lib/jekyll/migrators/wordpress.rb
# https://gist.github.com/303570
# edited to rewrite image URLs to use my CloudFront URL

require 'rubygems'
require 'sequel'
require 'fileutils'

# $ export DB=my_wpdb
# $ export USER=dbuser 
# $ export PASS=dbpass 
# $ ruby -r './lib/jekyll/migrators/wordpress' -e 'Jekyll::WordPress.process( "#{ENV["DB"]}", "#{ENV["USER"]}", "#{ENV["PASS"]}")'

# NOTE: This converter requires Sequel and the MySQL gems.
# The MySQL gem can be difficult to install on OS X. Once you have MySQL
# installed, running the following commands should work:
# $ sudo gem install sequel
# $ sudo gem install mysql -- --with-mysql-config=/usr/local/mysql/bin/mysql_config

module Jekyll
  module WordPress

    # Reads a MySQL database via Sequel and creates a post file for each
    # post in wp_posts that has post_status = 'publish'.
    # This restriction is made because 'draft' posts are not guaranteed to
    # have valid dates.
    QUERY = "select post_title, post_name, post_date, post_content, post_excerpt, ID, guid from wp_posts where post_status = 'publish' and post_type = 'post'"
	# Fetch all tags for a given POST ID
	TAGS_QUERY = "select tm.term_id,tm.name from wp_term_relationships tr 
				  inner join wp_term_taxonomy tt on tr.term_taxonomy_id = tt.term_taxonomy_id 
				  inner join wp_terms tm on tm.term_id=tt.term_id  
				  where tr.object_id=%d and tt.taxonomy = 'post_tag'";

    def self.process(dbname = 'posts_db', user='root', pass='naMunr8R', host = 'localhost', domain = '')
      db = Sequel.mysql(dbname, :user => user, :password => pass, :host => host)

      FileUtils.mkdir_p "_posts"

      db[QUERY].each do |post|
        # Get required fields and construct Jekyll compatible name
        title = post[:post_title]
        slug = post[:post_name]
        date = post[:post_date]
        content = post[:post_content]
        name = "%02d-%02d-%02d-%s.markdown" % [date.year, date.month, date.day, slug]

		# Get associated taxonomy terms (tags)
		# We replace + with nothing and transform to lower case
		# TODO: figure out what other characters would fuck up YAML
		tags = []
		db[TAGS_QUERY % post[:ID]].each do |tag|
			tags << tag[:name].to_s.gsub('+','').downcase
		end

		# Process content to rewrite some URLs
		if domain
		        content = self.transformUrls(domain,content)
		end

        # Get the relevant fields as a hash, delete empty fields and convert
        # to YAML for the header
        data = {
           'layout' => 'post',
           'title' => title.to_s,
           'excerpt' => post[:post_excerpt].to_s,
		   'tags' => tags
         }.delete_if { |k,v| v.nil? || v == ''}.to_yaml

        # Write out the data and content to file
        File.open("_posts/#{name}", "w") do |f|
          f.puts data
          f.puts "---"
          f.puts content
        end
      end

    end

  end
end
