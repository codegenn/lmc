class AddingRelationToJoinUs < ActiveRecord::Migration
  def change
    add_reference :applications, :job, index: true
  end
end
