require "tty-prompt"

# Monkeypatch for TTY::Prompt so that we can sanitize the filter value
module TTY
  class Prompt
    class List
      def choices(values = (not_set = true))
        if not_set
          if !filterable? || @filter.empty?
            @choices
          else
            filter_value = sanitize_for_filter(@filter.join)
            @filter_cache[filter_value] ||= @choices.enabled.select do |choice|
              sanitize_for_filter(choice.name.to_s).include?(filter_value)
            end
          end
        else
          @filter_cache = {}
          values.each { |val| @choices << val }
        end
      end

      def sanitize_for_filter(value)
        value
          .downcase
          .gsub(/[-_]/, '')
      end
    end
  end
end