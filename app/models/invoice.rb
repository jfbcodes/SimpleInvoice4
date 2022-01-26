class Invoice < ApplicationRecord

  belongs_to :user

  after_create :assign_random_number!

  def assign_random_number!
    letters = 'ABCDEFGHJKLMNPQRSTVWXZ'
    numbers = '0123456789'

    invoice_number =  3.times.collect{letters[rand(letters.length)] }.join +
      5.times.collect{numbers[rand(numbers.length)] }.join

    # keep looping until this invoice number is NOT found
    while Invoice.find_by(number: invoice_number)
      invoice_number =  3.times.collect{letters[rand(letters.length)] }.join +
        5.times.collect{numbers[rand(numbers.length)] }.join
    end

    self.number = invoice_number
    self.save!
  end
end
