module Jekyll

  class ArchiveIndex < Page
    def initialize(site, base, dir, type, collated)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), type + '.html')

      year, month, day = dir.split('/')
      self.data['year'] = year.to_i
      month and self.data['month'] = month.to_i
      day and self.data['day'] = day.to_i
      self.data['posts_by_year'] = collated['yearly']
      self.data['posts_by_month'] = collated['monthly']
      self.data['posts_by_day'] = collated['daily']
    end
  end

  class ArchiveGenerator < Generator
    safe true
    LayoutDaily = 'archive_daily'
    LayoutMonthly = 'archive_monthly'
    LayoutYearly = 'archive_yearly'
    def generate(site)
      unless site.layouts.key? LayoutDaily or
        site.layouts.key? LayoutMonthly or
        site.layouts.key? LayoutYearly
        return
      end

      @site = site
      @collated = self.collate(@site.posts)
      self.write_archives()
    end

    # Given a list of posts, return a hash of posts, collated by date.
    def collate(posts)
      collated = { 'yearly' => {}, 'monthly' => {}, 'daily' => {} }
      posts.reverse.each do |post|
        y, m, d = post.date.year, post.date.month, post.date.day
        unless collated[ 'yearly' ].key? y
          collated[ 'yearly' ][ y ] = []
          collated[ 'monthly' ][ y ] = {}
          collated[ 'daily' ][ y ] = {}
        end
        unless collated[ 'monthly' ][y].key? m
          collated[ 'monthly' ][ y ][ m ] = []
          collated[ 'daily' ][ y ][ m ] = {}
        end
        unless collated[ 'daily' ][ y ][ m ].key? d
          collated[ 'daily' ][ y ][ m ][ d ] = []
        end

        collated[ 'yearly' ][ y ] += [ post ]
        collated[ 'monthly' ][ y ][ m ] += [ post ]
        collated[ 'daily' ][ y ][ m ][ d ] += [ post ]
      end
      return collated
    end

    def write_archives
      @collated[ 'yearly' ].keys.each do |y|
        if @site.layouts.key? LayoutYearly
          self.write_archive( y.to_s, LayoutYearly )
        end

        if @site.layouts.key? LayoutMonthly
          @collated[ 'monthly' ][ y ].keys.each do |m|
            self.write_archive( sprintf("%04d/%02d", y.to_s, m.to_s ), LayoutMonthly )
          end

          if @site.layouts.key? LayoutDaily
            @collated[ 'daily' ][ y ][ m ].keys.each do |d|
              self.write_archive( sprintf("%04d/%02d/%02d", y.to_s, m.to_s, d.to_s ), LayoutDaily )
            end
          end
        end
      end
    end

    #   Write post archives to <dest>/<year>/, <dest>/<year>/<month>/,
    #   <dest>/<year>/<month>/<day>/
    #
    #   Returns nothing
    def write_archive(dir, type)
      archive = ArchiveIndex.new(@site, @site.source, dir, type, @collated)
      archive.render(@site.layouts, @site.site_payload)
      archive.write(@site.dest)
      @site.pages << archive
    end

  end

end
