module Jekyll
  class TagDetail < Page
    def initialize(site, base, tag)
      @site = site
      @base = base
      @dir =  site.config['tags_dir'] || 'tags'
      @name = File.join(tag, 'index.html')

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'tag_detail.html')

      self.data['tag'] = tag
      tag.gsub('-', ' ').split(' ').map {|w| w.capitalize }.join(' ').gsub('And', 'and').gsub('On', 'on')

    end
  end

  class TagsGenerator < Generator
    safe true
    LayoutDetail = 'tag_detail'
    LayoutIndex = 'tag_index'
    def generate(site)
      unless site.layouts.key? LayoutDetail or
             site.layouts.key? LayoutIndex
        return
      end

      @site = site
      self.write_tag_details()
    end
  
    def write_tag_details
      unless @site.layouts.key? LayoutDetail
        return
      end

      @site.tags.keys.each do |tag|
        detail = TagDetail.new(@site, @site.source, tag)
        detail.render(@site.layouts, @site.site_payload)
        detail.write(@site.dest)
        @site.pages << detail
      end
    end
  end
end
