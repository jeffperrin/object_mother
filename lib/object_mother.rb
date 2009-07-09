require 'object_mother/factory'

if defined? Rails.configuration
  Rails.configuration.after_initialize do
    path = File.join(RAILS_ROOT, 'test', 'object_mother')
    Dir[File.join(path, '*.rb')].each do |file|
      require file
    end
  end
end