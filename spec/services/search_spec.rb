require 'rails_helper'

RSpec.describe SearchService do
  context 'calls .find for' do
    it 'all resources' do
      expect(ThinkingSphinx).to receive(:search).with('test query')

      SearchService.call('test query', 'All')
    end


    %w[Question Answer Comment User].each do |resource|
      it "#{resource} model" do
        expect(resource.constantize).to receive(:search).with('test query')

        SearchService.call('test query', resource)
      end
    end
  end
end