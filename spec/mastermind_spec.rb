require './mastermind.rb'

mastermind = Mastermind.new
mastermind.assign_code(['1', '1', '2', '2'])

RSpec.describe 'Mastermind Tests' do
  describe '#check_code tests' do
    
    it 'no keys' do
      keys = mastermind.check_code(['3', '4', '5', '3'])
      result = [0, 0]
      expect(keys).to eq(result)
    end

    it 'four black' do
      keys = mastermind.check_code(['1', '1', '2', '2'])
      result = [4, 0]
      expect(keys).to eq(result)
    end

    it 'four white' do
      keys = mastermind.check_code(['2', '2', '1', '1'])
      result = [0, 4]
      expect(keys).to eq(result)
    end

    it 'two each' do
      keys = mastermind.check_code(['1', '2', '1', '2'])
      result = [2, 2]
      expect(keys).to eq(result)
    end
  end
end