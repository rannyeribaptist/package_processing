require_relative 'calculate_order'
include CalculateOrder

module MakeOrder
  p 'Type how many VS5 packs you want:'
  vs5 = gets

  p 'Type how many MB11 packs you want:'
  mb11 = gets

  p 'Type how many CF packs you want:'
  cf = gets

  total_vs5 = CalculateOrder.calc!('vs5', vs5)
  total_mb11 = CalculateOrder.calc!('mb11', mb11)
  total_cf = CalculateOrder.calc!('cf', cf)

  p total_vs5
  p total_mb11
  p total_cf
end

MakeOrder
