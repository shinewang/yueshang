class Category < ActiveRecord::Base
  belongs_to :parent,                        #固定写法，切记切记
             :class_name => 'Category'        #指明模型名

  has_many :children,                        #固定写法，切记切记
           :class_name => 'Category',         #指明模型名
           :foreign_key => 'parent_category_id',      #指明关联id
           :dependent => :nullify

  has_many :companies
end
