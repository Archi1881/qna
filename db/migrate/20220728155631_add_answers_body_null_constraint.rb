class AddAnswersBodyNullConstraint < ActiveRecord::Migration[7.0]
  def change
    change_column_null :answers, :body, false
  end
end
