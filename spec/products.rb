require '../lib/models/product'
require 'sqlite3'
require 'json'

RSpec.describe Product do
  db = SQLite3::Database.open "db/package_processing.db"

  describe 'Vegemite Scroll' do
    let (:item) { db.execute( "select code, name from products where code = 'VS5'" ) }
    subject { JSON.parse(item.map{|product| {code: product[0], name: product[1]} }.to_json, object_class: OpenStruct).first }

    it 'must have a name Vegemite scroll' do
      expect(subject.name.capitalize).to eq('Vegemite scroll')
    end

    it 'must have a code VS5' do
      expect(subject.code.upcase).to eq('VS5')
    end

    context 'Packs' do
      let (:packages) { db.execute( "select quantity, value from packs where product_code = ? order by quantity", subject.code.upcase ) }
      let (:packs) { JSON.parse(packages.map{|pack| {quantity: pack[0], value: pack[1]} }.to_json, object_class: OpenStruct) }

      it 'must be only 2 options' do
        expect(packs.count).to eq(2)
      end

      it 'must have options of 3 and 5' do
        expect(packs.map{|pkg| pkg.quantity}).to eq([3, 5])
      end

      it 'must cost 6.99 and 8.99' do
        expect(packs.map{|pkg| pkg.value}).to eq([6.99, 8.99])
      end
    end
  end

  describe 'Blueberry Muffin' do
    let (:item) { db.execute( "select code, name from products where code = 'MB11'" ) }
    subject { JSON.parse(item.map{|product| {code: product[0], name: product[1]} }.to_json, object_class: OpenStruct).first }

    it 'must have a name Blueberry muffin' do
      expect(subject.name.capitalize).to eq('Blueberry muffin')
    end

    it 'must have a code MB11' do
      expect(subject.code.upcase).to eq('MB11')
    end

    context 'Packs' do
      let (:packages) { db.execute( "select quantity, value from packs where product_code = ? order by quantity", subject.code.upcase ) }
      let (:packs) { JSON.parse(packages.map{|pack| {quantity: pack[0], value: pack[1]} }.to_json, object_class: OpenStruct) }

      it 'must be only 3 options' do
        expect(packs.count).to eq(3)
      end

      it 'must have options of 2, 5 and 8' do
        expect(packs.map{|pkg| pkg.quantity}).to eq([2, 5, 8])
      end

      it 'must cost 9.95, 16.95 and 24.95' do
        expect(packs.map{|pkg| pkg.value}).to eq([9.95, 16.95, 24.95])
      end
    end
  end

  describe 'Croissant' do
    let (:item) { db.execute( "select code, name from products where code = 'CF'" ) }
    subject { JSON.parse(item.map{|product| {code: product[0], name: product[1]} }.to_json, object_class: OpenStruct).first }

    it 'must have a name Croissant' do
      expect(subject.name.capitalize).to eq('Croissant')
    end

    it 'must have a code CF' do
      expect(subject.code.upcase).to eq('CF')
    end

    context 'Packs' do
      let (:packages) { db.execute( "select quantity, value from packs where product_code = ? order by quantity", subject.code.upcase ) }
      let (:packs) { JSON.parse(packages.map{|pack| {quantity: pack[0], value: pack[1]} }.to_json, object_class: OpenStruct) }

      it 'must be only 3 options' do
        expect(packs.count).to eq(3)
      end

      it 'must have options of 3, 5 and 9' do
        expect(packs.map{|pkg| pkg.quantity}).to eq([3, 5, 9])
      end

      it 'must cost 5.95, 9.95 and 16.99' do
        expect(packs.map{|pkg| pkg.value}).to eq([5.95, 9.95, 16.99])
      end
    end
  end
end
