require "sqlite3"
require 'json'
require 'byebug'


module CalculateOrder
  def calc! code, quantity
    return "invalid value inserted for #{code}" unless quantity.to_i > 0
    db = SQLite3::Database.open "db/package_processing.db"
    quantity = quantity.to_i

    packs = db.execute( "select quantity, value from packs where product_code = ? order by quantity", code.upcase ).reverse
    packs = create_object(packs.map{|pack| {unities: pack[0], value: pack[1], quantity: 0} })

    if packs.last.unities >= quantity
      total = create_object({data: [{value: packs.last.value, unities: packs.last.unities, quantity: 1}]})
      return format_return(total, code, quantity)
    else
      highest_result = try_highest(packs, quantity)
      return format_return(highest_result, code, quantity) if is_right_result?(highest_result, quantity)

      progressive_result = progressive_count(highest_result, quantity)

      if is_right_result?(progressive_result, quantity)
        return format_return(progressive_result, code, quantity)
      else
        return format_return(highest_result, code, quantity)
      end
    end
  end

  private

  def try_highest(packs, quantity)
    result = create_object({data: []})

    packs.each do |pack|
      break if quantity <= 0

      pack_object = create_object({value: pack.value, unities: pack.unities, quantity: 0})

      if quantity >= pack.unities
        pack_object.quantity = count_package(pack, quantity)
        pack_object.value = pack_object.quantity * pack.value

        quantity = update_quantity(pack, quantity)
      end

      if pack == packs.last && quantity < pack.unities
        pack_object = create_object({value: pack.value, unities: pack.unities, quantity: 1})
        quantity = pack.unities - quantity
      end

      result[:data] << pack_object
    end

    return result
  end

  def progressive_count(result, quantity)
    result = select_and_sort_result(result)

    return false if was_last_try? result

    result.data.first.quantity -= 1
    result.data[1].quantity += 1

    return result if is_right_result?(result, quantity)

    result = add_missing_unities(result, quantity)

    return result if is_right_result?(result, quantity)

    progressive_count(result, quantity)
  end

  #
  ## Helpers

  def create_object(obj)
    JSON.parse(obj.to_json, object_class: OpenStruct)
  end

  def is_right_result?(pack, quantity)
    return false if pack == false
    quantity - sum_total(pack) == 0
  end

  def add_missing_unities(result, quantity)
    missing_unities = quantity - sum_total(result)

    result.data.select{|pk| pk.unities <= missing_unities}.each do |pack|
      pack.quantity += count_package(pack, missing_unities)
      missing_unities = update_quantity(pack, missing_unities)

      break if missing_unities == 0
    end

    return result
  end

  def select_and_sort_result result
    result.data.sort_by(&:unities).reverse

    until result.data.first.quantity > 0
      result.data.delete(result.data.first)
    end

    return result
  end

  def sum_total packs
    packs.data.map{|pack| pack[:unities] * pack[:quantity]}.sum
  end

  def was_last_try? packs
    packs.data.map{|pack| pack.quantity}.sum == packs.data.last.quantity
  end

  def count_package(pack, quantity)
    quantity.to_i / pack.unities.to_i
  end

  def update_quantity(pack, quantity)
    quantity.to_i % pack.unities.to_i
  end

  def get_order_total(result)
    result.data.map{|pkg| pkg.value * pkg.quantity}.sum.round(2)
  end

  def format_return(result, code, quantity)
    result = select_and_sort_result(result)
    packs = result.data.map{|pack| pack.quantity.to_s + 'x' + pack.unities.to_s}.join(" | ")

    "#{quantity} #{code}: #{get_order_total(result)} (#{packs})"
  end
end
