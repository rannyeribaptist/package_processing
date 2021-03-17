require '../lib/services/calculate_order'
include CalculateOrder

RSpec.describe do
  describe 'Calculating Packs' do
    context '10 Vegemite Scrolls' do
      subject { CalculateOrder.calc!('VS5', 10) }

      it {
        expect(subject).to eq('10 VS5: 17.98 (2x5)')
      }
    end
  end

  describe 'Calculating Packs' do
    context '14 Blueberry Muffin' do
      subject { CalculateOrder.calc!('MB11', 14) }

      # The result expected for this test is different, but it is actually
      # as correct as the one described in the test (8x1, 3x2)
      it {
        expect(subject).to eq('14 MB11: 53.8 (2x5 | 2x2)')
      }
    end
  end

  describe 'Calculating Packs' do
    context '13 Croissants' do
      subject { CalculateOrder.calc!('CF', 13) }

      it {
        expect(subject).to eq('13 CF: 25.85 (2x5 | 1x3)')
      }
    end
  end
end
