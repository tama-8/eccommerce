class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  # created_at カラムを降順に並び替えた結果が取得できる
  scope :latest, -> { order(created_at: :desc) }
end
