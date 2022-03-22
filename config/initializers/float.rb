class Float
  def to_price_text(r_to_2 = false); num = self; (r_to_2 || (!(num.round(0) == num))) ? sprintf('%.2f', num) : num.to_i.to_s; end
  def to_price_html(currency_html, r_to_2 = false)
    num = self
    "<span class='to_price_html_block'>#{ to_price_text(r_to_2) }&nbsp;#{ currency_html.html_safe }</span>".html_safe
  end
end

class BigDecimal
  def to_price_text(r_to_2 = false); num = self; (r_to_2 || (!(num.round(0) == num))) ? sprintf('%.2f', num) : num.to_i.to_s; end
  def to_price_html(currency_html, r_to_2 = false)    
    "<span class='to_price_html_block'>#{ to_price_text(r_to_2) }&nbsp;#{ currency_html.html_safe }</span>".html_safe
  end
end
