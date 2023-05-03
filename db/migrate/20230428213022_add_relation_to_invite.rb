class AddRelationToInvite < ActiveRecord::Migration[7.0]
  def change
    add_reference :invites, :user, foreign_key: true
    add_reference :invites, :company, foreign_key: true

  end
end
