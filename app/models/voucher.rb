class Voucher < ActiveRecord::Base
  VOUCER_TYPE = ['30 off', '40 off', '45 off', '50 off', '55 off','60 off', '70 off',
                  'Buy 1 get 1 free', '199k', '299k', '99k',
                  'v40', 'v200', 'v500',
                  '200k mbs 400k', '500k mbs 900k'
                ]
end
