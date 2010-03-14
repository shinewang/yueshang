# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format 
# (all these examples are active by default):
# Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

#Inflector.module_eval do
#
#  def zh(str)
#    humanize_zh = {"login"=>"用户名", "password"=>"密码", "password_confirmation"=>"密码确认", "email"=>"电子邮箱", "title"=>"标题", "body"=>"内容", "old_password"=>"当前密码",
#      "name"=>"名称", "description"=>"介绍", "signature"=>"签名", "location"=>"来自", "blog"=>"博客", "introduction"=>"介绍", "subject"=>"标题" }
#    humanize_zh[str]? humanize_zh[str] : str
#  end
#
#  def humanize_with_zh(str)
#     humanize_str = zh str
#     if humanize_str == str
#         humanize_without_zh(str)
#     else
#         humanize_str
#     end
#   end
#   alias_method_chain :humanize, :zh
#end