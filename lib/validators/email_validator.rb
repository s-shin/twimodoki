require 'mail'

# http://memo.yomukaku.net/entries/166
class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    begin
      m = Mail::Address.new(value)
      # valueがドメイン名を含み、そのvalueがemailアドレスであることをチェック
      r = m.domain && m.address == value
      # treetopというPEGパーサー(http://treetop.rubyforge.org/index.html)で
      # 構文解析
      t = m.__send__(:tree)
      # 正しいドメインは dot_atom_textのsize > 1
      r &&= (t.domain.dot_atom_text.elements.size > 1)
    rescue Exception => e   
      r = false
    end
    # I18nしない場合は以下
    # record.errors[attribute] << (options[:message] || "is invalid") unless r
    # I18nを使ってエラーメッセージを多言語対応する場合は以下
    record.errors[attribute] << (options[:message] || I18n.t('activerecord.errors.messages.invalid')) unless r
  end
end
