module Jekyll
  module ToMonthFilter
    def to_month(input)
      return Date::MONTHNAMES[input.to_i]
    end
    def to_month_abbr(input)
      return Date::ABBR_MONTHNAMES[input.to_i]
    end
  end
end

Liquid::Template.register_filter(Jekyll::ToMonthFilter)