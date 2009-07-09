module ObjectMother
  class Factory
    @@index = 0
    def self.spawn
      raise 'No create method specified'
    end
    def self.populate(model)
      raise 'No populate method specified for ' + model.to_s
    end
    def self.to_hash(model)
      raise 'No to_hash method specified'
    end
    def self.unique(val)
      @@index += 1
      val.to_s + @@index.to_s
    end
    def self.unique_email(val)
      user, domain = val.split('@')
      unique(user) + '@' + domain
    end
    def self.create
      obj = spawn
      populate(obj)
      yield obj if block_given?
      obj
    end
    def self.create!(&block)
      obj = create(&block)
      obj.save!
      obj
    end
    def self.create_as_hash(&block)
      obj = create(&block)
      to_hash obj
    end
  end
end
