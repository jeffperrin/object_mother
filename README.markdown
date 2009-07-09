Object Daddy
============
_Version 0.2 (July 9th, 2009)_

__Authors:__  [Jeff Perrin](mailto:jeffperrin@gmail.com)

__License:__  MIT License.  See MIT-LICENSE file for more details.

object_mother is a library used as a plugin for Rails projects that establishes a
simple pattern for creating and persisting model objects. It takes inspiration from
the "Object Mother" pattern and is currently a work in progress.

See [http://jeffperrin.com/2009/07/08/object-mother-testing-pattern-in-rails/](http://jeffperrin.com/2009/07/08/object-mother-testing-pattern-in-rails/) for some context on why object_mother exists.

## Installation

object_mother lives as a gem dependency in your application. Since it is for testing only,
place the following line in config/environments/test.rb

  config.gem "jeffperrin-object_mother", :lib => "object_mother", :source => "http://gems.github.com"

You can then run:

  rake gems:install
  rake gems:unpack
  
Next, create a folder called `object_mother` in your Rails `test` directory. Create a blank ruby file (named whatever you want) in this directory and put your model factories inside.

## Testing

There are currently no tests to run. This is probably fixable.

## Usage

object_mother provides a single class called `ObjectMother::Factory` that is sub-classed in your Rails app. 
It will include all .rb files in a directory called test/object_mother within your app. A file might look like this
(where we have 3 models, City, Area, and Community):
    
    class CityFactory < ObjectMother::Factory
      def self.spawn
        City.new
      end
      def self.populate(model)
        model.name = unique('Calgary')
      end
    end

    class AreaFactory < ObjectMother::Factory
      def self.spawn
        Area.new
      end
      def self.populate(model)
        model.name = unique('SW')
        model.city = CityFactory.create!
      end
    end
    
    class CommunityFactory < ObjectMother::Factory
      def self.spawn
        Community.new
      end
      def self.populate(model)
        model.name = unique('Evergreen')
        model.area = AreaFactory.create!
      end
    end
    
Each factory deals specifically with one model type. The `spawn` method must be overridden to let object_mother know what type of object it should create. The `populate` method supplies the model with all attributes necessary to successfully persist a model instance. Once this is done, each factory can be used in tests like so:

    #Creates a valid `city` that is not yet persisted
    CityFactory.create
    
    #Creates a valid `city` and persists it
    CityFactory.create!
    
    #example usage...
    context "should show city" do
      setup do
        get :show, :id => CityFactory.create!.to_param
      end
      should_respond_with :success
    end
    
    #Can also override self.to_hash for your controller tests
    context "creating a valid city" do
      setup do
        post :create, :city => CityFactory.create_as_hash
      end
      should_redirect_to "city path" do 
        cities_path
      end
    end

## Blocks

object_mother lets you customize the look of your models by passing a block to `create`, `create!` or `create_as_hash` like so:
    
    #override the default name given in the UserFactory.populate method. All other 
    #attributes will stay the same.
    user = UserFactory.create! do |u|
      u.name = "Jorge"
    end

## Known Issues

1) Yes, the `spawn` method should be inferred.
2) Yes, the `create_as_hash` method should be inferred.
3) test/object_mother directory (and perhaps an .rb file) should be generated if they don't exist.
4) I didn't use any crazy meta-programming wizardry. Just really simple code. Sorry.