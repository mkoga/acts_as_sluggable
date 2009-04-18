module ActsAsSluggable

  def self.included(base)
    base.extend(ActMethods)
  end

  module ActMethods
    
    def acts_as_sluggable(column, opts = {})
      class_inheritable_accessor :slug_options
      self.slug_options = opts
      self.slug_options[:source] ||= column.to_sym || :name
      self.slug_options[:slug] ||= :slug
      self.slug_options[:to_param] = opts[:to_param].nil? ? true : opts[:to_param]

      class_eval <<-EOV
        before_save :create_slug
      EOV

      if self.slug_options[:to_param]
        class_eval <<-EOV
          def to_param
            self.send(self.slug_options[:slug].to_s)
          end
        EOV
      end

      include InstanceMethods
    end

    module InstanceMethods

      private

      def create_slug
        tmp_source = self.send(self.slug_options[:source].to_s)
        tmp_slug = tmp_source.downcase.gsub(/\s+/, '-').gsub(/&/, 'and')

        self.send("#{self.slug_options[:slug].to_s}=", tmp_slug)
      end

    end

  end

end
