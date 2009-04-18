module ActsAsSlug

  def self.included(base)
    base.extend(ActMethods)
  end

  module ActMethods
    
    def acts_as_slug(opts)
      class_inheritable_accessor :slug_options
      self.slug_options = opts.is_a?(Hash) ? opts : { opts => true }
      self.slug_options[:source] ||= self.slug_options.keys.first || :name
      self.slug_options[:destination] ||= :slug

      class_eval <<-EOV
        before_save :create_slug
      EOV

      include InstanceMethods
    end

    module InstanceMethods
      
      private

      def create_slug
        tmp_source = self.send(self.slug_options[:source].to_s)
        tmp_slug = tmp_source.downcase.gsub(/\s+/, '-').gsub(/&/, 'and')

        self.send("#{self.slug_options[:destination].to_s}=", tmp_slug)
      end

    end

  end

end
