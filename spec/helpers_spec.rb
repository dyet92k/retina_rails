require 'spec_helper'

class Image

  def url(version)
    '/some_image.png'
  end

end

class Upload

  attr_accessor :avatar

  def initialize
    self.avatar = Image.new
  end

  def retina_dimensions
    {
      :avatar => {
        :small => {
          :width  => 40,
          :height => 30
        }
      }
    }
  end

end

describe ActionView::Helpers::AssetTagHelper, :type => :helper do

  subject { helper }

  describe '#retina_image_tag' do

    context 'with dimensions present' do

      it 'should set correct width and height' do
        image = helper.retina_image_tag(Upload.new, :avatar, :small)

        expect(image).to include('width="40"')
        expect(image).to include('height="30"')
      end

      it 'should be able to add a class' do
        image = helper.retina_image_tag(Upload.new, :avatar, :small, :class => 'foo')
        expect(image).to include('class="foo"')
      end

    end

    context 'without dimensions present' do

      before(:each) do
        allow_any_instance_of(Upload).to receive(:retina_dimensions).and_return(nil)
      end

      it 'should set correct width and height' do
        image = helper.retina_image_tag(Upload.new, :avatar, :small, :default => { :width => 25, :height => 40 })

        expect(image).to include('width="25"')
        expect(image).to include('height="40"')

        image = helper.retina_image_tag(Upload.new, :avatar, :small, :default => [25, 40])

        expect(image).to include('width="25"')
        expect(image).to include('height="40"')
      end

      it 'should set no height and width if no defaults present' do
        image = helper.retina_image_tag(Upload.new, :avatar, :small)

        expect(image).to_not include('width')
        expect(image).to_not include('height')
      end

      it 'should be able to add a class' do
        image = helper.retina_image_tag(Upload.new, :avatar, :small, :default => { :width => 25, :height => 40 }, :class => 'foo')

        expect(image).to include('class="foo"')
      end

      it 'should strip default attributes' do
        image = helper.retina_image_tag(Upload.new, :avatar, :small, :default => { :width => 25, :height => 40 })

        expect(image).to_not include('default')
      end

      it 'should respect other options' do
        image = helper.retina_image_tag(Upload.new, :avatar, :small, :default => { :width => 25, :height => 40 }, :alt => 'Some alt tag')

        expect(image).to include('alt="Some alt tag"')
      end

    end

  end

end
