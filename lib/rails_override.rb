module ActiveRecord
      class Errors
          begin
              @@default_error_messages.update( {
              :inclusion => "不在指定范围内",
              :exclusion => "被保留",
              :invalid => "格式无效",
              :confirmation => "不匹配",
              :accepted => "必须赋值",
              :empty => "不能为空",
              :blank => "不能为空",
              :too_long => "太长(最大长度为 %d 个字符)",
              :too_short => "太短(最短长度为 %d 个字符)",
              :wrong_length => "长度错误(长度应该是 %d 个字符)",
              :taken => "已存在",
              :not_a_number => "不是数字",
              :must_number => "必须是数字",
              })
          end
      end
end

module ActionView
  module Helpers
    module ActiveRecordHelper
      def error_messages_for(object_name, options = {})
        options = options.symbolize_keys
        object = instance_variable_get("@#{object_name}")
        if object && !object.errors.empty? 
          content_tag("div",content_tag(options[:header_tag] || "h4","提交的信息存在#{object.errors.count}个错误") + content_tag("p", "以下是错误的内容:") +
              content_tag("ul", object.errors.full_messages.collect { |msg| content_tag("li", msg) }),"id" => options[:id] ||"errorExplanation", "class" => options[:class] || "error")
        end
      end
    end
  end
end